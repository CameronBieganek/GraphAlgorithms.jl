

# Running `] test` does not work, since Julia is bad at working with
# local projects. (It can't find GraphTypes even though it is defined in
# the Manifest.toml file for the project.) For now, just run include("test/runtests.jl") from
# the REPL instead.

using Test
using GraphTypes
using GraphAlgorithms


@testset "shortest_path" begin
    g = Graph{Int}()
    add_weighted_edges!(g, [
        (1, 2, 1),
        (2, 3, 2),
        (1, 3, 4)
    ])
    @test shortest_path(g, 1, 3) == [1, 2, 3]

    g = Graph{Int}()
    add_weighted_edges!(g, [
        (1, 2, 1),
        (2, 3, 4),
        (3, 4, 2),
        (5, 1, 1),
        (6, 1, 1),
        (6, 2, 1),
        (7, 2, 2),
        (8, 3, 1),
        (8, 4, 2),
        (5, 6, 2),
        (6, 7, 4),
        (7, 8, 1),
        (5, 9, 1),
        (6, 9, 3),
        (9, 7, 1)
    ])
    @test shortest_path(g, 6, 4) == [6, 2, 7, 8, 4]
end
