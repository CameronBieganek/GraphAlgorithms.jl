module GraphsWrapper

using Graphs
using SimpleWeightedGraphs
using DataStructures
using Test

function shortest_path(g::AbstractGraph{U}, src, dst) where {U}
    distmx = weights(g)
    T = eltype(distmx)
    nvg = nv(g)
    dists = fill(typemax(T), nvg)
    parents = zeros(U, nvg)
    visited = zeros(Bool, nvg)
    H = PriorityQueue{U,T}()

    dists[src] = zero(T)
    visited[src] = true
    H[src] = zero(T)

    while !isempty(H)
        u = dequeue!(H)
        d = dists[u] # Cannot be typemax if `u` is in the queue
        for v in outneighbors(g, u)
            alt = d + distmx[u, v]
            if !visited[v]
                visited[v] = true
                dists[v] = alt
                parents[v] = u
                H[v] = alt
            elseif alt < dists[v]
                dists[v] = alt
                parents[v] = u
                H[v] = alt
            end
        end
    end

    path = [dst]
    v = dst
    while parents[v] != 0
        p = parents[v]
        pushfirst!(path, p)
        v = p
    end

    return path
end

@testset "shortest_path" begin
    g = SimpleWeightedGraph(3)
    add_edge!(g, 1, 2, 1)
    add_edge!(g, 2, 3, 2)
    add_edge!(g, 1, 3, 4)
    @test shortest_path(g, 1, 3) == [1, 2, 3]

    g = SimpleWeightedGraph(9)
    add_edge!(g, 1, 2, 1)
    add_edge!(g, 2, 3, 4)
    add_edge!(g, 3, 4, 2)
    add_edge!(g, 5, 1, 1)
    add_edge!(g, 6, 1, 1)
    add_edge!(g, 6, 2, 1)
    add_edge!(g, 7, 2, 2)
    add_edge!(g, 8, 3, 1)
    add_edge!(g, 8, 4, 2)
    add_edge!(g, 5, 6, 2)
    add_edge!(g, 6, 7, 4)
    add_edge!(g, 7, 8, 1)
    add_edge!(g, 5, 9, 1)
    add_edge!(g, 6, 9, 3)
    add_edge!(g, 9, 7, 1)
    @test shortest_path(g, 6, 4) == [6, 2, 7, 8, 4]
end

end
