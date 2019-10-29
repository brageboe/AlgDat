function certifysubsetsum(set, subsetindices, s)
    testsum = 0
    for i = 1:length(subsetindices)
        testsum += set[subsetindices[i]]
    end
    return testsum == s
end

function certifytsp(path, maxweight, neighbourmatrix)
    len = length(path)
    # sjekk at path slutter der den starter
    if path[1] != path[len]
        return false
    # sjekk om path mangler noder
    elseif path[1] >= len || path[len] >= len
        return false
    # nabomatrisestørrelse og stilengde må samsvare
    elseif size(neighbourmatrix)[1] != len-1
        return false
    end
    frequency = zeros(Int,len)
    weightsum = 0
    for i = 2:(len)
        frequency[path[i]] += 1
        # sjekk om noder besøkes flere ganger
        if frequency[path[i]] > 1
            return false
        end
        if path[i] >= len
            return false
        end
        weightsum += neighbourmatrix[path[i-1], path[i]]
    end
    # stivekt må være mindre enn maxvekt
    return weightsum <= maxweight
end

function alldistinct(list)
    sort!(list)
    for i = 2:length(list)
        if list[i] == list[i-1]
            return false
        end
    end
    return true
end

function cliquetovertexcover(neighbourmatrix, minimumcliquesize)
    # reduction from clique to vertex-cover
    # output is compliment of clique graph G, containing the edges that are not in G,
    # and
    newneighbourmatrix = zeros(typeof(neighbourmatrix[1,1]), size(neighbourmatrix))
    for i = 1:size(neighbourmatrix)[1]
        for j = 1:size(neighbourmatrix)[2]
            if neighbourmatrix[i,j] == 1
                newneighbourmatrix[i,j] = 0
            elseif neighbourmatrix[i,j] == 0
                newneighbourmatrix[i,j] = 1
            elseif neighbourmatrix[i,j] == -1 # unødvendig? forventer bare true/false elementer
                newneighbourmatrix[i,j] = -1
            end
        end
    end
    maximumvertexcoversize = size(neighbourmatrix)[1] - minimumcliquesize
    return newneighbourmatrix, maximumvertexcoversize
end

set =  [3, 5, 8, 1, 2, 5]
subsetindices = [2,3,4,5]
println(certifysubsetsum(set,subsetindices,16))

path=[1, 2, 3, 1]
maxweight=0
neighbourmatrix=[-1 0 0; 0 -1 0; 0 0 -1]
println(certifytsp(path, maxweight, neighbourmatrix))

nb = [-1 1 0 1 1 1; 1 -1 0 1 1 0; 0 0 -1 0 1 1; 1 1 0 -1 1 1; 1 1 1 1 -1 0; 1 0 1 1 0 -1]
min_clique = 4
println(cliquetovertexcover(nb, min_clique))
