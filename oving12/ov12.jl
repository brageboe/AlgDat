
using DataStructures

function find_augmenting_path(source, sink, nodes, flows, capacities)

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
  n = length(path)
  flow = Inf
  for i in 2:n
    u, v = path[i-1], path[i]
    flow = min(flow, capacities[u, v] - flows[u, v])
  end
  return flow
end

function send_flow!(path, flow, flows)
  n = length(path)
  for i in 2:n
    u, v = path[i-1], path[i]
    flows[u, v] += flow
    flows[v, u] -= flow
  end
end

function max_flow(source, sink, nodes, capacities)
  flows = zeros(Float64, size(capacities))

  total_flow = 0
  path = find_augmenting_path(source, sink, nodes, flows, capacities)
  while path ≠ nothing
    flow = max_path_flow(path, flows, capacities)
    send_flow!(path, flow, flows)
    total_flow += flow
    path = find_augmenting_path(source, sink, nodes, flows, capacities)
  end

  return flows, total_flow
end


function min_cut(source, sink, nodes, capacities)
  flows, total_flow = max_flow(source, sink, nodes, capacities)
  graph = capacities - flows

  # DFS to traverse
  function traverse(source, nodes, graph)
    stack = [source]
    discovered = zeros(Bool, nodes)
    discovered[source] = true
    while !isempty(stack)
      node = pop!(stack)
      for neighbour in 1:nodes
        if !discovered[neighbour] && graph[node, neighbour] > 0
          discovered[neighbour] = true
          push!(stack, neighbour)
        end
      end
    end
    return discovered
  end

  discovered = traverse(source, nodes, graph)

  # cut is all traversed nodes, and all untraversed nodes
  cut = (Vector(1:nodes)[discovered], Vector(1:nodes)[.!discovered])
  return cut
end

function find_trusted_cluster(trusted_peers, peers, network)
  # trusted_peers::Vector{Int}, liste over noder vi stoler på
  # peers::Int, antall peers
  # network::Matrix{Float64}, kanter inneholder hvor mye trust man en peer har til en annen ∈ [0, 1]
  num_trusted = length(trusted_peers)

  # legg til superkilde og supersluk
  to_supernodes = zeros(peers, 2)
  from_supernodes = zeros(2, peers+2)
  for peer in trusted_peers
    from_supernodes[1, peer] = Inf
  end
  to_supernodes[:,2] = map(x -> x == Inf ? 0 : 1, transpose(from_supernodes[1, 1:peers]))

  flow_network =  vcat(hcat(network, to_supernodes), from_supernodes)

  # finn min cut
  s = peers+1
  t = peers+2
  S, _ = min_cut(s, t, peers+2, flow_network)

  # fjern superkilde og returner
  return filter(peer -> peer ≠ s, S)
end


struct MFTestCase
  source::Int
  sink::Int
  nodes::Int
  capacities::Matrix{Float64}
  max_flow_solution::Int
  min_cut_solution::Tuple{Vector{Int}, Vector{Int}}
end

function mftests()
  tests = [
           MFTestCase(
                      1,
                      6,
                      6,
                      [
                       0 16 13  0  0  0;
                       0  0  0 12  0  0;
                       0  4  0  0 14  0;
                       0  0  9  0  0 20;
                       0  0  0  7  0  4;
                       0  0  0  0  0  0;
                      ],
                      23,
                      ([1, 2, 3, 5], [4, 6])
                     ),
           MFTestCase(
                      1,
                      6,
                      6,
                      [
                        0 16 13  0  0  0;
                       16  0  4 12  0  0;
                       13  4  0  9 14  0;
                        0 12  9  0  7 20;
                        0  0 14  7  0  4;
                        0  0  0 20  4  0;
                      ],
                      24,
                      ([1, 2, 3, 4, 5], [6])
                     ),
           MFTestCase(
                      1,
                      6,
                      6,
                      [
                        0 16 13  0  0  0;
                       16  0  4 12  0  0;
                       13  4  0  7 14  0;
                        0 12  7  0  1 20;
                        0  0 14  1  0  4;
                        0  0  0 20  4  0;
                      ],
                      24,
                      ([1, 2, 3, 5], [4, 6])
                     ),
           MFTestCase(
                      1,
                      5,
                      5,
                      [
                       0 1 1 1 1;
                       1 0 1 1 1;
                       1 1 0 1 1;
                       1 1 1 0 1;
                       1 1 1 1 0;
                      ],
                      4,
                      ([1], [2, 3, 4, 5])
                     )
          ]
  function randomtest()
    nodes = rand(3:10)
    source = rand(1:nodes-1)
    sink = rand(source+1:nodes)
    capacities = rand(1:200, (nodes, nodes))
    for i in 1:nodes capacities[i,i] = 0 end
    _, flow = max_flow(source, sink, nodes, capacities) # TODO
    cut = min_cut(source, sink, nodes, capacities)
    MFTestCase(
               source,
               sink,
               nodes,
               capacities,
               flow,
               cut
              )
  end
  randomtests = [
                 randomtest() for _ in 1:10
                ]
  vcat(tests, randomtests)
end

struct TNTestCase
  trusted_peers::Vector{Int}
  network::Matrix{Float64}
  peers::Int
  find_trusted_cluster_solution::Vector{Int}
end

function tntests()
  tests = [
           TNTestCase(
                      [1, 2],
                      [
                       0 0.7 0.9 0.1
                       0.9 0 0.7 0.1
                       0.5 0.5 0 0.5
                       0.9 0.9 0.9 0
                      ],
                      4,
                      [1, 2, 3]
                     ),
           TNTestCase(
                      [1, 3],
                      [
                       0 0.7 0.9 0.1
                       0.9 0 0.7 0.1
                       0.5 0.5 0 0.5
                       0.9 0.9 0.9 0
                      ],
                      4,
                      [1, 2, 3]
                     ),
           TNTestCase(
                      [2, 3],
                      [
                       0 0.7 0.9 0.1
                       0.9 0 0.7 0.1
                       0.5 0.5 0 0.5
                       0.9 0.9 0.9 0
                      ],
                      4,
                      [1, 2, 3]
                     ),
          ]

  function randomtest()
    peers::Int = rand(3:10)
    trusted_peers = rand(1:peers, floor(Int, rand(2:max(2, floor(Int, peers/2)))))
    network = rand(0.0:0.1:1.0, (peers, peers))
    for i in 1:peers network[i,i] = 0 end
    solution = find_trusted_cluster(trusted_peers, peers, network)
    TNTestCase(
               trusted_peers,
               network,
               peers,
               solution
              )
  end
  randomtests = [
                 randomtest() for _ in 1:10
                ]
  vcat(tests, randomtests)
end

function test_max_flow()
  println("Tester max_flow")

  for test ∈ mftests()
    flows, total_flow = max_flow(test.source, test.sink, test.nodes, copy(test.capacities))
    msg = ""
    if total_flow != test.max_flow_solution
      msg = "Funksjonen returnerte feil svar! Output var $(total_flow), mens forventet output er $(test.max_flow_solution)."
    end

    if length(msg) > 0
      return false, "$(msg) Input var $(test.source), $(test.sink), $(test.nodes), $(test.capacities)."
    end
  end

  return true, nothing
end

function test_min_cut()
  println("Tester min_cut")

  for test ∈ mftests()
    cut = min_cut(test.source, test.sink, test.nodes, copy(test.capacities))
    msg = ""
    if cut != test.min_cut_solution
      msg = "Funksjonen returnerte feil svar! Output var $(cut), mens forventet output er $(test.min_cut_solution)."
    end

    if length(msg) > 0
      return false, "$(msg) Input var $(test.source), $(test.sink), $(test.nodes), $(test.capacities)."
    end
  end

  return true, nothing
end

function test_find_trusted_cluster()
  println("Tester find_trusted_cluster")

  for test ∈ tntests()
    cluster = test.trusted_peers
    for i in 1:3
      cluster = find_trusted_cluster(cluster, test.peers, copy(test.network))
    end
    #cluster = find_trusted_cluster(copy(test.trusted_peers), test.peers, copy(test.network))
    msg = ""
    if cluster != test.find_trusted_cluster_solution
      msg = "Funksjonen returnerte feil svar! Output var $(cluster), mens forventet output er $(test.find_trusted_cluster_solution)."
    end

    if length(msg) > 0
      return false, "$(msg) Input var $(test.trusted_peers), $(test.peers), $(test.network)."
    end
  end

  return true, nothing
end


function run(test)
  correct, msg = test()
  if correct
    println("Alt rett!")
  else
    println(msg)
  end
end

run(test_max_flow)
run(test_min_cut)
run(test_find_trusted_cluster)
