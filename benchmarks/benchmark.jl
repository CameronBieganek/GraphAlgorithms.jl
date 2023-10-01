

using Combinatorics
using StatsBase
import SimpleWeightedGraphs
using GraphTypes
using GraphAlgorithms
using BenchmarkTools

include("GraphsWrapper.jl")


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
