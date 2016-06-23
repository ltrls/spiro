defmodule Spiro.TraversalTest do
  use ExUnit.Case, async: true

  import Spiro.Traversal

  test "traversal addE" do
    steps = Spiro.Traversal.new(%{}) |> addE("edge") |> getSteps()
    [%Spiro.Traversal.Step{params: %{label: "edge"},type: :addE}] = steps
  end

  test "traversal addV" do
    steps = Spiro.Traversal.new(%{}) |> addV("vertex") |> getSteps()
    [%Spiro.Traversal.Step{params: %{label: "vertex"},type: :addV}] = steps
  end

  test "traversal has(key)" do
    steps = Spiro.Traversal.new(%{}) |> has("key") |> getSteps()
    [%Spiro.Traversal.Step{params: %{key: "key"}, type: :has}] = steps
  end

  test "traversal has(key, value)" do
    steps = Spiro.Traversal.new(%{}) |> has("key", "value") |> getSteps()
    [%Spiro.Traversal.Step{params: %{key: "key", value: "value"}, type: :has}] = steps
  end

  test "traversal hasLabel" do
    steps = Spiro.Traversal.new(%{}) |> hasLabel(["label1", "label2"]) |> getSteps()
    [%Spiro.Traversal.Step{params: %{labels: ["label1", "label2"]}, type: :hasLabel}] = steps
  end

  test "traversal hasId" do
    steps = Spiro.Traversal.new(%{}) |> hasId(["id1", "id2"]) |> getSteps()
    [%Spiro.Traversal.Step{params: %{ids: ["id1", "id2"]}, type: :hasId}] = steps
  end

  test "traversal hasKey" do
    steps = Spiro.Traversal.new(%{}) |> hasKey(["key1", "key2"]) |> getSteps()
    [%Spiro.Traversal.Step{params: %{keys: ["key1", "key2"]}, type: :hasKey}] = steps
  end

  test "traversal hasValue" do
    steps = Spiro.Traversal.new(%{}) |> hasValue(["value1", "value2"]) |> getSteps()
    [%Spiro.Traversal.Step{params: %{values: ["value1", "value2"]}, type: :hasValue}] = steps
  end

  test "traversal hasNot" do
    steps = Spiro.Traversal.new(%{}) |> hasNot("key") |> getSteps()
    assert [%Spiro.Traversal.Step{params: %{key: "key"}, type: :hasNot}] = steps
  end

  test "traversal out" do
    steps = Spiro.Traversal.new(%{}) |> out(["label1", "label2"]) |> getSteps()
    assert [%Spiro.Traversal.Step{params: %{labels: ["label1", "label2"]}, type: :out}] = steps
  end

  test "traversal both" do
    steps = Spiro.Traversal.new(%{}) |> both(["label1", "label2"]) |> getSteps()
    assert [%Spiro.Traversal.Step{params: %{labels: ["label1", "label2"]}, type: :both}] = steps
  end

  test "traversal outE" do
    steps = Spiro.Traversal.new(%{}) |> outE(["label1", "label2"]) |> getSteps()
    assert [%Spiro.Traversal.Step{params: %{labels: ["label1", "label2"]}, type: :outE}] = steps
  end

  test "traversal inE" do
    steps = Spiro.Traversal.new(%{}) |> inE(["label1", "label2"]) |> getSteps()
    assert [%Spiro.Traversal.Step{params: %{labels: ["label1", "label2"]}, type: :inE}] = steps
  end

  test "traversal bothE" do
    steps = Spiro.Traversal.new(%{}) |> bothE(["label1", "label2"]) |> getSteps()
    assert [%Spiro.Traversal.Step{params: %{labels: ["label1", "label2"]}, type: :bothE}] = steps
  end

  test "traversal outV" do
    steps = Spiro.Traversal.new(%{}) |> outV() |> getSteps()
    assert [%Spiro.Traversal.Step{params: %{}, type: :outV}] = steps
  end

  test "traversal inV" do
    steps = Spiro.Traversal.new(%{}) |> inV() |> getSteps()
    assert [%Spiro.Traversal.Step{params: %{}, type: :inV}] = steps
  end

  test "traversal bothV" do
    steps = Spiro.Traversal.new(%{}) |> bothV() |> getSteps()
    assert [%Spiro.Traversal.Step{params: %{}, type: :bothV}] = steps
  end

  test "traversal otherV" do
    steps = Spiro.Traversal.new(%{}) |> otherV() |> getSteps()
    assert [%Spiro.Traversal.Step{params: %{}, type: :otherV}] = steps
  end

  test "traversal limit" do
    steps = Spiro.Traversal.new(%{}) |> limit(100) |> getSteps()
    assert [%Spiro.Traversal.Step{params: %{count: 100}, type: :limit}] = steps
  end

  test "traversal max" do
    steps = Spiro.Traversal.new(%{}) |> max() |> getSteps()
    assert [%Spiro.Traversal.Step{params: %{}, type: :max}] = steps
  end

  test "traversal mean" do
    steps = Spiro.Traversal.new(%{}) |> mean() |> getSteps()
    assert [%Spiro.Traversal.Step{params: %{}, type: :mean}] = steps
  end

  test "traversal min" do
    steps = Spiro.Traversal.new(%{}) |> min() |> getSteps()
    assert [%Spiro.Traversal.Step{params: %{}, type: :min}] = steps
  end

  test "traversal order" do
    steps = Spiro.Traversal.new(%{}) |> order() |> getSteps()
    assert [%Spiro.Traversal.Step{params: %{}, type: :order}] = steps
  end

  test "traversal path" do
    steps = Spiro.Traversal.new(%{}) |> path() |> getSteps()
    assert [%Spiro.Traversal.Step{params: %{}, type: :path}] = steps
  end

  test "traversal property" do
    steps = Spiro.Traversal.new(%{}) |> property("key", "value") |> getSteps()
    assert [%Spiro.Traversal.Step{params: %{key: "key", value: "value"}, type: :property}] = steps
  end

  test "traversal range" do
    steps = Spiro.Traversal.new(%{}) |> range(5, 10) |> getSteps()
    assert [%Spiro.Traversal.Step{params: %{low: 5, high: 10}, type: :range}] = steps
  end

  test "traversal sum" do
    steps = Spiro.Traversal.new(%{}) |> sum() |> getSteps()
    assert [%Spiro.Traversal.Step{params: %{}, type: :sum}] = steps
  end

  test "traversal tail" do
    steps = Spiro.Traversal.new(%{}) |> tail(2) |> getSteps()
    assert [%Spiro.Traversal.Step{params: %{count: 2}, type: :tail}] = steps
  end

  test "traversal timeLimit" do
    steps = Spiro.Traversal.new(%{}) |> timeLimit(5000) |> getSteps()
    assert [%Spiro.Traversal.Step{params: %{timeout: 5000}, type: :timeLimit}] = steps
  end

  test "traversal values" do
    steps = Spiro.Traversal.new(%{}) |> values(["key1", "key2"]) |> getSteps()
    [%Spiro.Traversal.Step{params: %{keys: ["key1", "key2"]}, type: :values}] = steps
  end

  test "traversal vertices" do
    steps = Spiro.Traversal.new(%{}) |> vertices(["id1", "id2"]) |> getSteps()
    [%Spiro.Traversal.Step{params: %{ids: ["id1", "id2"]}, type: :V}] = steps
  end

  test "traversal edges" do
    steps = Spiro.Traversal.new(%{}) |> edges(["id1", "id2"]) |> getSteps()
    [%Spiro.Traversal.Step{params: %{ids: ["id1", "id2"]}, type: :E}] = steps
  end

  test "traversal multistep composition with addE and addV" do
    steps = Spiro.Traversal.new(%{}) |> addV("vertex") |> addE("edge") |> getSteps()
    assert [%Spiro.Traversal.Step{params: %{label: "vertex"}, type: :addV}, %Spiro.Traversal.Step{params: %{label: "edge"}, type: :addE}] = steps
  end

end
