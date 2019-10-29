using DataStructures: Queue, enqueue!, dequeue!

mutable struct Node
    id::Int
    neighbours::Array{Node}
    color::Union{String, Nothing}
    distance::Union{Int, Nothing}
    predecessor::Union{Node, Nothing}
end
Node(id) = Node(id, [], nothing, nothing, nothing)
##############################################

function makenodelist(adjacencylist)    ### OPPGAVE 1
    nodelist = []
    for i=1:length(adjacencylist)
        push!(nodelist, Node(i))
    end
    for node in nodelist
        for neighbourid in adjacencylist[node.id]
            push!(node.neighbours, nodelist[neighbourid])
        end
    end
    return nodelist
end


function printnodelist(nodelist)
    println("Skriver ut nodeliste med printnodelist")
    for node in nodelist
        neighbourlist = [neighbours.id for neighbours in node.neighbours]
        println("id: $(node.id), neighbours: $neighbourlist")
    end
end


function main(;n=5, degree=3)
    println("Kjører makenodelist")
    adjacencylist = generateadjacencylist(n, degree)
    @info "adjacencylist" adjacencylist
    nodelist = makenodelist(adjacencylist)
    printnodelist(nodelist)
end


generateadjacencylist(n, degree) = [rand(1:n, degree) for id = 1:n]


# Det kan være nyttig å kjøre mange tester for å se om programmet man har laget
# krasjer for ulike instanser
function runmanytests(;maxlistsize=15)
    # Kjører n tester for hver listestørrelse – én for hver grad
    for n = 1:maxlistsize
        for degree = 1:n
            adjacencylist = generateadjacencylist(n, degree)
            @info "Listelendge $n" n, degree #, adjacencylist
            makenodelist(adjacencylist)
        end
    end
end

function bfs!(nodes, start)     ###### OPPGAVE 2
    for node in nodes
        node.color = "white"
        node.predecessor = nothing
        node.distance = typemax(Int)
    end
    start.color = "grey"
    start.distance = 0
    queue = Queue{Node}()
    enqueue!(queue, start)
    while !isempty(queue)
        current = dequeue!(queue)
        if isgoalnode(current)
            return current
        end
        for neighbour in current.neighbours
            if neighbour.color = "white"
                neighbour.color = "grey"
                neighbour.distance = current.distance + 1
                neighbour.predecessor = current
                enqueue!(queue, neighbour)
            end
        end
        current.color = "black"
    end
    return nothing
end

function makepathto(goalnode::Node)     #### OPPGAVE 3
    current = goalnode
    path = []
    while current.distance != 0
        push!(path, current.id)
        current = current.predecessor
    end
    return reverse(path)
end

main()
#runmanytests()
