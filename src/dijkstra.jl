

function shortest_path(g::AbstractGraph, src, dst)
    V = vertex_type(g)
    dist = Dict{V, Float64}()
    parent = Dict{V, V}()
    visited = Set{V}()
    H = PriorityQueue{V, Float64}()

    dist[src] = 0.0
    push!(visited, src)
    H[src] = 0.0

    while !isempty(H)
        u = dequeue!(H)
        d = get(dist, u, Inf)
        for v in neighbors(g, u)
            alt = d + g.weights[u, v]
            if v ∉ visited
                push!(visited, v)
                dist[v] = alt
                parent[v] = u
                H[v] = alt
            elseif alt < dist[v]
                dist[v] = alt
                parent[v] = u
                H[v] = alt
            end
        end
    end

    path = [dst]
    v = dst
    while v in keys(parent)
        p = parent[v]
        pushfirst!(path, p)
        v = p
    end

    return path
end
