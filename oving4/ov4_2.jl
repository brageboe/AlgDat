function counting_sort_length(A::Array{String,1})
    #k = 1000 # arbitrary large number, max length of strings in A[j] we expect
    k = 0
    for j = 1:length(A)
        if length(A[j]) > k
            k = length(A[j])
        end
    end
    k = k+1 # to account for 0-length strings, placed at C[1].
    C = Array{Int64,1}(undef,k) # C[i+1] = number of strings in A with length i
    B = Array{String,1}(undef,length(A))
    for i = 1:k
        C[i] = 0
    end
    for j = 1:length(A) # count amount of strings with length C[i] and insert into C[i]
        C[length(A[j])+1] = C[length(A[j])+1] + 1   # +1 as 0-length strings shifts the array 1 step to the right
    end
    for i = 2:k
        C[i] = C[i] + C[i-1]    # accumulate C
    end
    for j = length(A):-1:1
        B[C[length(A[j])+1]] = A[j]
        C[length(A[j])+1] = C[length(A[j])+1] - 1
    end
    return B
end

#A=["bbbb", "aa", "aaaa", "ccc", ""]
#println(counting_sort_length(A))
