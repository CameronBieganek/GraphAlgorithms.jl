

function Base.union(g::AbstractGraph, h::AbstractGraph)
    out = empty(g)
    add_vertices!(out, vertices(g))
    add_vertices!(out, vertices(h))
    add_edges!(out, edges(g))
    add_edges!(out, edges(h))
end

function Base.intersect(g::AbstractGraph, h::AbstractGraph)
    out = empty(g)
    add_vertices!(out, intersect(vertices(g), vertices(h)))
    add_edges!(out, intersect(edges(g), edges(h)))
end
