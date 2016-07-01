defmodule GraphTest do
  use ExUnit.Case
  doctest Spiro.Graph

  alias Spiro.Vertex
  alias Spiro.Edge

  defmodule Graph do
    use Spiro.Graph, adapter: Spiro.Adapter.Digraph
    # use Spiro.Graph, adapter: Spiro.Adapter.Neo4j, adapter_opts: [host: "localhost:7474", username: "neo4j", password: "neoneo"]
  end

  setup do
    Graph.start_link()
    :ok
  end

  test "add_vertex(properties :: keyword)" do
    properties = [foo: "bar"]
    v = Graph.add_vertex(properties)
    assert Graph.properties(%Vertex{id: v.id}) == properties
  end

  test "add_vertex(vertex :: Spiro.Vertex.t)" do
    properties = [foo: "bar"]
    v = Graph.add_vertex(%Vertex{properties: properties})
    assert Graph.properties(%Vertex{id: v.id}) == properties
  end

  test "add_edge(properties :: keyword, vertex_from :: Spiro.Vertex.t, vertex_to :: Spiro.Vertex.t[, type])" do
    v1 = Graph.add_vertex([foo: "bar"])
    v2 = Graph.add_vertex([foo2: "bar2"])
    properties = [foo3: "bar3"]
    e = case Graph.supports_function?(:edge_type) do
      true -> Graph.add_edge(properties, v1, v2, "type")
      false -> Graph.add_edge(properties, v1, v2)
    end
    assert Graph.properties(e) == properties
  end

  test "add_edge(edge :: Spiro.Edge.t, vertex_from :: Spiro.Vertex.t, vertex_to :: Spiro.Vertex.t[, type])" do
    v1 = Graph.add_vertex([foo: "bar"])
    v2 = Graph.add_vertex([foo2: "bar2"])
    properties = [foo3: "bar3"]
    e = case Graph.supports_function?(:edge_type) do
      true -> Graph.add_edge(%Edge{properties: properties}, v1, v2, "type")
      false -> Graph.add_edge(%Edge{properties: properties}, v1, v2)
    end
    assert Graph.properties(e) == properties
  end

  test "add_edge(edge :: Spiro.Edge.t)" do
    v1 = Graph.add_vertex([foo: "bar"])
    v2 = Graph.add_vertex([foo2: "bar2"])
    properties = [foo3: "bar3"]
    e = case Graph.supports_function?(:edge_type) do
      true -> Graph.add_edge(%Edge{from: v1, to: v2, properties: properties, type: "type"})
      false -> Graph.add_edge(%Edge{from: v1, to: v2, properties: properties})
    end
    assert Graph.properties(e) == properties
  end

  test "set_properties(edge :: Spiro.Edge.t, properties :: keyword)" do
    v1 = Graph.add_vertex([foo: "bar"])
    v2 = Graph.add_vertex([foo2: "bar2"])
    e = Graph.add_edge([foo3: "bar3"], v1, v2, "knows")
    new_properties = [foo4: "bar4"]
    new_properties2 = [foo5: "bar5"]
    Graph.set_properties(v1, new_properties)
    Graph.set_properties(e, new_properties2)
    assert Graph.properties(v1) == new_properties
    assert Graph.properties(e) == new_properties2
  end

  test "set_properties(edge :: Spiro.Edge.t)" do
    v1 = Graph.add_vertex([foo: "bar"])
    v2 = Graph.add_vertex([foo2: "bar2"])
    e = Graph.add_edge([foo3: "bar3"], v1, v2, "knows")
    new_properties = [foo4: "bar4"]
    new_properties2 = [foo5: "bar5"]
    Graph.set_properties(%{v1 | properties: new_properties})
    Graph.set_properties(%{e | properties: new_properties2})
    assert Graph.properties(v1) == new_properties
    assert Graph.properties(e) == new_properties2
  end

  test "add_properties(edge :: Spiro.Edge.t)" do
    properties = [foo: "bar"]
    properties2 = [foo2: "bar2"]
    v1 = Graph.add_vertex(properties)
    v2 = Graph.add_vertex([foo3: "bar3"])
    e = Graph.add_edge(properties2, v1, v2, "knows")
    new_properties = [foo4: "bar4"]
    new_properties2 = [foo5: "bar5"]
    Graph.add_properties(v1, new_properties)
    Graph.add_properties(e, new_properties2)
    assert Graph.properties(v1) == properties ++ new_properties
    assert Graph.properties(e) == properties2 ++ new_properties2
  end

  test "delete(element :: element)" do
    v1 = Graph.add_vertex([foo: "bar"])
    v2 = Graph.add_vertex([foo2: "bar2"])
    e = Graph.add_edge([foo3: "bar3"], v1, v2, "knows")
    Graph.delete(v1)
    Graph.delete(e)
    assert Graph.properties(v1) == {:error, :not_found}
    assert Graph.properties(e) == {:error, :not_found}
  end

  test "properties(element :: element)" do
    properties = [foo: "bar"]
    v = Graph.add_vertex(properties)
    assert Graph.properties(%Vertex{id: v.id}) == properties
  end

  test "get_property(element :: element, key :: String.t)" do #maybe functions working on vertices and edges should be tested with both
    v = Graph.add_vertex([foo: "bar"])
    assert Graph.get_property(v, :foo) == "bar"
  end

  test "set_property(element :: element, key :: String.t, value :: term)" do
    v = Graph.add_vertex([foo: "bar"])
    Graph.set_property(v, :foo, "bar2")
    Graph.set_property(v, :foo2, "bar3")
    assert Enum.sort(Graph.properties(v)) == Enum.sort([foo: "bar2", foo2: "bar3"])
  end

  test "fetch_properties(element :: element)" do
  end

  test "vertex_degree(vertex :: Spiro.Vertex.t, direction :: (:in | :out | :all)[, types :: list(String.t)])" do
    v1 = Graph.add_vertex([])
    v2 = Graph.add_vertex([])
    v3 = Graph.add_vertex([])
    v4 = Graph.add_vertex([])
    Graph.add_edge([], v1, v2, "knows")
    Graph.add_edge([], v1, v3, "knows")
    Graph.add_edge([], v4, v1, "knows")
    assert Graph.vertex_degree(v1, :in) == 1
    assert Graph.vertex_degree(v1, :out) == 2
    assert Graph.vertex_degree(v1, :all) == 3
  end
  
  test "adjacent_edges(vertex :: Spiro.Vertex.t, direction :: (:in | :out | :all)[, types :: list(String.t)])" do
    v1 = Graph.add_vertex([])
    v2 = Graph.add_vertex([])
    v3 = Graph.add_vertex([])
    v4 = Graph.add_vertex([])
    e1 = Graph.add_edge([], v1, v2, "knows")
    e2 = Graph.add_edge([], v1, v3, "knows")
    e3 = Graph.add_edge([], v4, v1, "knows")
    assert Graph.adjacent_edges(v1, :in) == [e3]
    assert Enum.sort(Graph.adjacent_edges(v1, :out)) == Enum.sort([e1, e2])
    assert Enum.sort(Graph.adjacent_edges(v1, :all)) == Enum.sort([e1, e2, e3])
  end

  test "vertex_neighbours(vertex :: Spiro.Vertex.t, direction :: (:in | :out | :all)[, types :: list(String.t)])" do
    v1 = Graph.add_vertex([])
    v2 = Graph.add_vertex([])
    v3 = Graph.add_vertex([])
    v4 = Graph.add_vertex([])
    Graph.add_edge([], v1, v2, "knows")
    Graph.add_edge([], v1, v3, "knows")
    Graph.add_edge([], v4, v1, "knows")
    assert Enum.sort(Graph.vertex_neighbours(v1, :in)) == Enum.sort([v4])
    assert Enum.sort(Graph.vertex_neighbours(v1, :out)) == Enum.sort([v2, v3])
    assert Enum.sort(Graph.vertex_neighbours(v1, :all)) == Enum.sort([v2, v3, v4])
  end

  if Graph.supports_function?(:edge_type) do
    test "list_types()" do
    end
  end

  if Graph.supports_function?(:vertex_labels) do
    test "list_labels()" do
    end

    test "vertices_by_label(label :: String.t)" do
    end

    test "get_labels(vertex :: Spiro.Vertex.t)" do
      v = Graph.add_vertex([])
      Graph.add_labels(v, ["Person", "Student"])
      assert Graph.get_labels(v) == ["Person", "Student"]
    end

    test "add_labels(vertex :: Spiro.Vertex.t, labels :: list(String.t)" do
      v = Graph.add_vertex([])
      Graph.add_labels(v, ["Person", "Student"])
      assert Graph.get_labels(v) == ["Person", "Student"]
    end

    test "set_labels(vertex :: Spiro.Vertex.t, labels :: list(String.t)" do
      v = Graph.add_vertex([])
      Graph.add_labels(v, ["Person", "Student"])
      Graph.set_labels(v, ["Person", "Superhero"])
      assert Graph.get_labels(v) == ["Person", "Superhero"]
    end

    test "set_labels(vertex :: Spiro.Vertex.t)" do
      v = Graph.add_vertex([])
      Graph.add_labels(v, ["Person", "Student"])
      Graph.set_labels(%{v | labels: ["Person", "Superhero"]})
      assert Graph.get_labels(v) == ["Person", "Superhero"]
    end

    test "remove_label(vertex :: Spiro.Vertex.t, label :: String.t)" do
      v = Graph.add_vertex([])
      Graph.add_labels(v, ["Person", "Student"])
      Graph.remove_label(v, "Person")
      assert Graph.get_labels(v) == ["Student"]
    end
  end

  ## errors handling
  
end
