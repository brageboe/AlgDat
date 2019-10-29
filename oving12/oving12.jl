function find_augmenting_path(source, sink, nodes, flows, capacities)
#Denne funksjonen tar inn kilden, sluket (som heltall), antall noder i nettverket
#og to matriser som inneholder henholdvis flyten over hver kant i nettverket og
#kapasitetene i nettverket. Den returnerer en liste over nodene på en flytforøkende
#sti gjennom nettverket, men oppdaterer ikke flyten. Dersom det ikke er mulig å
#sende mer flyt gjennom nettverket returnerer funksjonen nothing.
  function create_path(source, sink, parent)
    # creates a path from source to sink using parent list
    node = sink
    path = Vector{Int}([sink])
    while node ≠ source
      node = parent[node]
      push!(path, node)
    end
    return reverse(path)
  end

  discovered = zeros(Bool, nodes)
  parent = zeros(Int, nodes)
  queue = Queue{Int}()
  enqueue!(queue, source)

  # BFS to find augmenting path, while keeping track of parent nodes
  while !isempty(queue)
    node = dequeue!(queue)
    if node == sink
      return create_path(source, sink, parent)
    end

    for neighbour ∈ 1:nodes
      if !discovered[neighbour] && flows[node, neighbour] < capacities[node, neighbour]
        enqueue!(queue, neighbour)
        discovered[neighbour] = true
        parent[neighbour] = node
      end
    end
  end

  return nothing # no augmenting path found
end

function max_path_flow(path, flows, capacities)
  # find max flow to send through a path

  #path er her en liste over noder på en flytforøkende sti gjennom nettverket.
  #Denne funksjonen returnerer den maksimale flyten som kan sendes gjennom
  #nettverket på denne stien, men oppdaterer ikke flyten.
  n = length(path)
  flow = Inf
  for i in 2:n
    u, v = path[i-1], path[i]
    flow = min(flow, capacities[u, v] - flows[u, v])
  end
  return flow
end

function send_flow!(path, flow, flows)
  #sender en flyt av størrelse flow gjennom path i nettverket, og oppdaterer
  #flows tilsvarende. Denne funksjonen returnerer ingenting, men endrer flows.
  n = length(path)
  for i in 2:n
    u, v = path[i-1], path[i]
    flows[u, v] += flow
    flows[v, u] -= flow
  end
end

function send_flow!(path, flow, flows)
#Funksjonen skal returnere en matrise med flyten i grafen og den maksimale
#flyten som en Tuple. Hint: For å returnere flere argumenter kan du skrive
#return flows, total_flow, der flows og total_flow er variabler.



end
