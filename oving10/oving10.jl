using DataStructures

mutable struct Node
    ip::Int
    neighbours::Array{Tuple{Node,Int}}
    risk::Union{Float64, Nothing}
    predecessor::Union{Node, Nothing}
    probability::Float64
end

function initialize_single_source!(graph, start)
    for node in graph
        node.risk = typemax(Float64)
        node.predecessor = nothing
    end
    start.risk = 0.0
end

function relax!(from_node, to_node, cost)
    if to_node.risk > from_node.risk + cost/to_node.probability
        to_node.risk = from_node.risk + cost/to_node.probability
        to_node.predecessor = from_node
    end
end

function dijkstra!(graph, start)
    initialize_single_source!(graph, start)
    S = Array{Node,1}()
    Q = PriorityQueue{Node,Float64}()
    for node in graph
        enqueue!(Q, node, node.risk)
        #Q[node] = node.risk
    end
    while !isempty(Q)
        u = dequeue!(Q)
        push!(S, u)
        for (nb_node, nb_cost) in u.neighbours
            tmp = nb_node.risk
            relax!(u, nb_node, nb_cost) # nb = (Node, cost)
            if tmp != nb_node.risk
	            Q[nb_node] = nb_node.risk
            end
        end
    end
end

function bellman_ford!(graph, start)
    initialize_single_source!(graph, start)
    for node in graph
	    for node in graph
    	    for (nb_node, nb_cost) in node.neighbours
        	    relax!(node, nb_node, nb_cost) # nb::Tuple{Node, Int}
	        end
    	end
    end
    for node in graph
        for (nb_node, nb_cost) in node.neighbours
            if node.risk > node.risk + nb_cost/nb_node.probability
                return false
            end
        end
    end
    return true
end

function new_node(ip, prob)
    return Node(ip,[],nothing,nothing,prob)
end


prob = 1
graph = []
for ip = 1:5
    push!(graph, new_node(ip,prob))
end
graph[1].probability = 0.75
graph[2].probability = 0.5

graph[1].neighbours = [(graph[4], 8)]
graph[2].neighbours = [(graph[4], 2), (graph[5], 5)]
graph[3].neighbours = [(graph[2], 9)]
graph[4].neighbours = [(graph[3], 1)]
graph[5].neighbours = [(graph[1], 10), (graph[2], 5), (graph[4], 5)]

dijkstra!(graph, graph[4])

#Node(ip, prob) = Node(ip, [], nothing, nothing, prob)

#n = Node(3, 4.32)
