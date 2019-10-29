function floyd_warshall(adjacency_matrix, nodes, f, g)
    D = adjacency_matrix
    for k = 1:nodes
        for i = 1:nodes
                for j = 1:nodes
                    if i != j
                        D[i,j] = f(D[i,j], g(D[i,k], D[k,j]))
                    end
                end
        end
    end
    return D
end

function transitive_closure(adjacency_matrix, nodes)
    T = zeros(Int,nodes,nodes)
    for i = 1:nodes
        for j = 1:nodes
            if i == j || adjacency_matrix[i,j] < typemax(Int)
                T[i,j] = 1
            end
        end
    end
    return floyd_warshall(T, nodes, f_transitive, g_transitive)
end

function f_transitive(a,b)
    return a | b
end
function g_transitive(a,b)
    return a & b
end
function f(a,b)
    return min(a,b)
end
function g(a,b)
    return a+b
end
function f_schulze(a,b)
    return max(a,b)
end

function create_preference_matrix(ballots::Vector{String}, voters::Int, candidates::Int)
    P = zeros(Int,candidates,candidates)
    for vote in ballots
        for i = 1:(candidates-1)    # for every char, except the last, in each vote string (e.g. "ABC" then for "A" and "B")
            index_i = vote[i] - 'A' + 1
            for j = (i+1):candidates    # for every char after i (e.g. "B" and "C" over)
                index_j = vote[j] - 'A' + 1
                P[index_i, index_j] += 1
            end
        end
    end
    return P
end

function find_strongest_path(preference_matrix, candidates)
    P = preference_matrix   # reduced preference matrix
    # remove weakest edge
    for i = 1:candidates
        for j = 1:candidates
            if i != j
                if preference_matrix[i,j] < preference_matrix[j,i]
                    P[i,j] = 0
                else
                    P[j,i] = 0
                end
            end
        end
    end
    # find largest smallest path from node X to Y
    return floyd_warshall(P, candidates, f_schulze, f)
end

function find_schulze_ranking(strongest_paths, candidates)
    sum_array = []
    for i = 1:candidates
        letter = string('A' + i - 1)
        push!(sum_array, (0,letter))
        idk = 0
        for j = 1:candidates
            if (strongest_paths[i,j] > strongest_paths[j,i]) && (i != j)
                idk += 1
            end
        end
        sum_array[i] = (idk, letter)
    end
    reverse!(sort!(sum_array))
    output = []
    for i = 1:candidates
        push!(output, sum_array[i][2])
    end
    return output
end

ballots = ["ABC", "CBA", "BAC"]
voters = 3
candidates=3
P = create_preference_matrix(ballots, voters, candidates)

pref = [0 20 26	30 22; 25 0 16 33 18; 19 29 0 17 24; 15	12 28 0 14; 23 27 21 31 0]
c = size(pref)[1]
S = find_strongest_path(pref,c)
println(S)
println(find_schulze_ranking(S,c))
rank = find_schulze_ranking(S,c)

#adjacency_matrix = [0 7 2; typemax(Int) 0 typemax(Int); typemax(Int) 4 0]
#nodes = 3
#println(transitive_closure(adjacency_matrix, nodes))

#f = min og g = +, skal dette fungere som Floyd-Warshall og gi output [0 6 2; Inf 0 Inf; Inf 4 0].
