mutable struct DisjointSetNode
    rank::Int
    p::DisjointSetNode
    DisjointSetNode() = (obj = new(0); obj.p = obj;)
end

function findset(x::DisjointSetNode)
    if x != x.p
        x.p = findset(x.p)
    end
    return x.p
end

function union!(x::DisjointSetNode, y::DisjointSetNode)
    # joins together two sets
    link!(findset(x), findset(y))
end

function link!(x::DisjointSetNode, y::DisjointSetNode)
    # takes the root of two sets as input, and links them together depending on the sets' comparative rank
    if x.rank > y.rank
        y.p = x
    else    # x.rank <= y.rank
        if x.rank == y.rank # arbitrarily choose y as higher rank if they are equal
            y.rank += 1
        end
        x.p = y
    end
end

function hammingdistance(s1::String, s2::String)
    #Hamming-avstand for to strenger av lik lengde defineres som antallet
    #bokstaver på de samme posisjonene som er ulike mellom de to strengene.
    output = 0
    string_length = length(min(s1, s2))
    for i = 1:string_length
        if s1[i] != s2[i]
            output += 1
        end
    end
    return output
end

function findclusters(E::Vector{Tuple{Int, Int, Int}}, n::Int, k::Int)
    # Edges E = (w,u,v), w=weight of edge, u->v=the edge
    #A = Array{Tuple{Int, Int}}(undef, k)
    A = Array{Int}[]
    nodes = Array{DisjointSetNode,1}()  # array containing all nodes
    for 1:n # create the nodes
        push!(nodes,DisjointSetNode())
    end
    sort!(E) # sort the Edges in non-descending order
    for edge in E
        if findset(nodes[edge[2]]) != findset(nodes[edge[3]]) && length(A) <= k # if node u and v are not in the same tree
            push!(A, (edge[2],edge[3]) # add edge [u,v] to A
            union!(nodes[edge[2]], nodes[edge[3]])
        end
    end
    return A
end


function findanimalgroups(animals::Vector{Tuple{String, String}}, k::Int64)
    # animals[i] = [animalname, gene sequence]
    E = Vector{Tuple{Int, Int, Int}}()
    n_animals = length(animals)
    for i = 1:n_animals
        for j = 1:n_animals
            if i != j
                push!(E, (hammingdistance(animals[i][2], animals[j][2]), i, j)
            end
        end
    end
    tmp = findclusters(E, n_animals, k)
    A = Array{String}[]
    for i=1:k
        for j=1:length(tmp[i])
            push!(A, animals[j][1])
        end
    end
    return A
end
