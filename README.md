# Spiro

**Spiro** aims to be Ecto's sibling in the [Elixir](http://elixir-lang.org/) ecosystem, providing a DSL interface for [graph databases](https://en.wikipedia.org/wiki/Graph_database).

[Ecto](https://github.com/elixir-lang/ecto) is an incredible tool for building relational repositories, schemas, and changesets for Elixir applications.  However, the structure and query interfaces for graph databases have special needs that a relational interface just cannot wholly meet.  In reality, using SQL-based interface would sacrifice much of the performance and cross-referential features that projects use graph databases to achieve.

The goal is not to compete with Ecto, but provide a similar abstraction layer specific to the peculiarities found in graph database systems.  As such, support for non-graph datastores is not planned.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add spiro to your list of dependencies in `mix.exs`:

        def deps do
          [{:spiro, "~> 0.0.1"}]
        end

  2. Ensure spiro is started before your application:

        def application do
          [applications: [:spiro]]
        end

## Usage

Below is a working draft of what graph manipulation and traversal might look like.  Sample graph and traversal borrowed from the [TinkerPop3 docs](http://tinkerpop.apache.org/docs/3.1.1-incubating/reference/#_the_graph_structure).

```elixir
# In your config/config.exs file
config :my_graph, Sample.MyGraph,
  adapter: Spiro.Adapter.Digraph,
  type: [:cyclic, :protected]

# In your application code
defmodule Sample.MyGraph do
  use Spiro.Graph, otp_app: :my_graph
end

defmodule Sample.Person do
  @moduledoc "Define vertex for 'person' type."
  use Spiro.Vertex
  import Spiro.Element

  vertex "person" do
    property :name     # Defaults to type :string
    property :age, :integer
  end

  @doc "Override default from Spiro.Element to provide property validation."
  def element(person, params \\ :empty) do
    person
    |> cast(params, ~w(name), ~w(age))
    |> validate_number(:age, greater_than: 13)
  end
end

defmodule Sample.Software do
  @moduledoc "Define vertex for 'software' type."
  use Spiro.Vertex
  import Spiro.Element

  vertex "software" do
    property :name
    property :lang
  end
end

defmodule Sample.Knows do
  @moduledoc "Define edge for 'knows' relationship."
  use Spiro.Edge
  import Spiro.Element

  edge "knows" do
    property :weight, :double
  end
end

defmodule Sample.Created do
  @moduledoc "Define edge for 'created' relationship."
  use Spiro.Edge
  import Spiro.Element

  edge "created" do
    property :weight, :double
  end
end

defmodule Sample.App do
  alias Sample.Person
  alias Sample.Software
  alias Sample.Knows
  alias Sample.Created
  alias Sample.MyGraph

  @doc "Populate the graph with some vertices and edges"
  def populate_graph do
    # Add some vertices to the graph.
    marko = MyGraph.addVertex!(Person.element(name: "marko", age: 29))
    vadas = MyGraph.addVertex!(Person.element(name: "vadas", age: 27))
    lop = MyGraph.addVertex!(Software.element(name: "marko", lang: "java"))
    josh = MyGraph.addVertex!(Person.element(name: "josh", age: 32))
    ripple = MyGraph.addVertex!(Software.element(name: "ripple", lang: "java"))
    peter = MyGraph.addVertex!(Person.element(name: "peter", age: 35))

    # Add some edges to the graph.
    MyGraph.addEdge(marko, Knows.element(weight: 0.5), vadas)
    MyGraph.addEdge(marko, Knows.element(weight: 1.0), josh)
    MyGraph.addEdge(marko, Created.element(weight: 0.4), lop)
    MyGraph.addEdge(josh, Created.element(weight: 1.0), ripple)
    MyGraph.addEdge(josh, Created.element(weight: 0.4), lop)
    MyGraph.addEdge(peter, Created.element(weight: 0.2), lop)
  end

  @doc "Traverse graph looking for friends of so-and-so, return list of names."
  def find_friends(name) do
    MyGraph.traversal()
    |> V()
    |> has("name", name)
    |> out(Knows)
    |> values("name")
  end
end
```

## Roadmap

Planned development targets, in order:

  1. Erlang's [digraph](http://erlang.org/doc/man/digraph.html)
      Why start here?  Because it's built in and has a fairly simple, well-documented interface. Bonus is it makes unit tests of the core interface dead simple.
  2. [Neo4j](http://neo4j.com/)
  3. [OrientDB](http://orientdb.com/orientdb/)
  4. [Gremlin Server](http://tinkerpop.apache.org/docs/3.1.1-incubating/reference/#gremlin-server)

Once digraph support is in and the architecture has been validated, additional support to add more targets would be greatly appreciated!

## Contributing

Once the core package is fairly stable, contributions will be more than welcome!  Additional datastore support would preferably be developed in separate projects named something like **spiro_xyz** for datastore XYZ to keep the core framework small.

The only datastore support that will be bundled into **Spiro** directly will be digraph since it's built into Elixir/Erlang.

## Background

This project came about from conversations in the elixir/ecto Slack group and email correspondence with [florinpatrascu](https://github.com/florinpatrascu) regarding his experiences, trials and tribulations while building the [Neo4j.Sips](https://github.com/florinpatrascu/neo4j_sips) package.

In reviewing various cross-database and cross-language interfaces that could be applied equally well across many common graph databases, the most promising technology I've found so far to base the DSL on is the [Apache TinkerPop](http://tinkerpop.apache.org/) Gremlin interface.  The good folks who initially developed TinkerPop as well as Apache's team have come up with a query interface that works across several popular graph databases and has been ported to quite a few different languages (including some functional ones) without sacrificing the specific features and functionality a graph database offers.

Oh, and the name?  Anyone ever play with a [Spirograph](https://en.wikipedia.org/wiki/Spirograph)?  :)
