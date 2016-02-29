# Spiro

**Spiro** aims to be Ecto's sibling in the [Elixir](http://elixir-lang.org/) ecosystem, providing a DSL interface for [graph databases](https://en.wikipedia.org/wiki/Graph_database).

[Ecto](https://github.com/elixir-lang/ecto) is an incredible tool for building relational repositories, schemas, and changesets for Elixir applications.  However, the structure and query interfaces for graph databases have special needs that a relational interface just cannot wholly meet, and in reality would sacrifice much of the performance and cross-referential gains that projects use graph databases to address.

The goal is not to compete with Ecto, but provide a similar abstraction layer specific to the peculiarities found in graph database systems.  Support for non-graph databases is not planned.

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

## Background

This project came about from conversations in the elixir/ecto Slack group and email correspondence with [florinpatrascu](https://github.com/florinpatrascu) regarding his experiences, trials and tribulations encountered while building the [Neo4j.Sips](https://github.com/florinpatrascu/neo4j_sips) package.

In reviewing various cross-database and cross-language interfaces that could be applied equally well across many common graph databases via DSL, the most promising technology I've found so far to base the DSL on is the [Apache TinkerPop](http://tinkerpop.apache.org/) Gremlin interface.  The good folks who initially developed TinkerPop as well as Apache's team have come up with a query interface that works across several popular graph databases and has been ported to quite a few different languages (including some FP ones) without sacrificing the specific features and functionality a graph database offers.

Oh, and the name?  Anyone ever play with a [Spirograph](https://en.wikipedia.org/wiki/Spirograph)?  :)
