function counting_sort_letters(A::Array{String,1}, position::Int64)
    k = 'z'-'a'+1   # assume all strings in A contains small letters a-z.
    C = Array{Int64,1}(undef, k)  # tmp storage array of "number of occurances of each char-value".
    B = Array{String,1}(undef, length(A)) # output array
    for i = 1:k
        C[i] = 0    # zero occurances of i yet.
    end
    for j = 1:length(A)
        index = convert(Int64, A[j][position]-'a') + 1 # letter at A[j][position] represented as number in alphabet
        C[index] = C[index] + 1   # count number of times A[j][position] occurs
    end
    #println("C after counting: ", C)
    for i = 2:k
        C[i] = C[i] + C[i-1]    # let C accumulate. C[i] = where should the last i be?
    end
    #println("C after accumulating: ", C)
    for j = length(A):-1:1  # descending as not to trade equal values => stable
        index = convert(Int64, A[j][position]-'a') + 1
        B[C[index]] = A[j]   # i = A[j]
        #println("-----")
        #println("j = ", j, ". index = ", index)
        #println("B = ", B)
        #println("C = ", C)
        C[index] = C[index] - 1   # the next i should be one step to the left

    end
    return B
end
 #A = ["ccc", "cba", "ca", "ab", "abc"]
 #println(counting_sort_letters(A,2))
