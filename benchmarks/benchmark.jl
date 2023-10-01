

using Combinatorics
using StatsBase
import SimpleWeightedGraphs
import Graphs
using GraphTypes
using GraphAlgorithms
using BenchmarkTools

include("GraphsWrapper.jl")


# -------- Shortest path. --------

function random_edges(; nv=10_000, ne=40_000)
    possible_edges = collect(combinations(1:nv, 2))
    edges = sample(possible_edges, ne; replace=false)
    weights = rand(ne)
    edges, weights
end

edges, weights = random_edges()

gt = Graph{Int}()
for ((u, v), w) in zip(edges, weights)
    add_edge!(gt, u, v, w)
end

swg = SimpleWeightedGraphs.SimpleWeightedGraph(first.(edges), last.(edges), weights)

@btime GraphsWrapper.shortest_path($swg, 1, 10_000);
@btime shortest_path($gt, 1, 10_000);


# -------- Set operations. --------

possible_edges1 = collect(combinations(1:8_000, 2))
edges1 = sample(possible_edges1, 40_000; replace=false)

possible_edges2 = collect(combinations(2_000:10_000, 2))
edges2 = sample(possible_edges2, 40_000; replace=false)

sg1 = Graphs.SimpleGraph(10_000)
for (u, v) in edges1
    Graphs.add_edge!(sg1, u, v)
end

sg2 = Graphs.SimpleGraph(10_000)
for (u, v) in edges2
    Graphs.add_edge!(sg2, u, v)
end

g1 = Graph{Int}()
add_vertices!(g1, 1:10_000)
add_edges!(g1, Edge.(edges1))

g2 = Graph{Int}()
add_vertices!(g2, 1:10_000)
add_edges!(g2, Edge.(edges2))

@btime union($sg1, $sg2);
@btime union($g1, $g2);

@btime intersect($sg1, $sg2);
@btime intersect($g1, $g2);
