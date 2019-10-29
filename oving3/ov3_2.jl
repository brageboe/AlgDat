function merge_(A::Array{Int64,1}, p::Int64, q::Int64, r::Int64)
    n1 = q-p+1
    n2 = r-q
    L = Array{Int64,1}(undef, n1+1)  #Array{Union{Int64,Float64}}
    R = Array{Int64,1}(undef, n2+1)
    for i = 1:n1    # copy first half of A to L
        L[i] = A[p+i-1]
    end
    for i = 1:n2    # copy last half of A to R
        R[i] = A[q+i]
    end
    L[n1+1] = typemax(Int)
    R[n2+1] = typemax(Int)
    i=1
    j=1
    for k = p:r
        if L[i] <= R[j]
            A[k] = L[i]
            i = i+1
        else
            A[k] = R[j]
            j = j+1
        end
    end
end

function merge_sort(A::Array{Int64,1}, p::Int64, r::Int64)
    if p<r
        q = convert(Int64, floor((p+r)/2))
        merge_sort(A, p, q)
        merge_sort(A, q+1, r)
        merge_(A, p, q, r)
    end
end

function bisect_left(A::Array{Int64,1}, p::Int64, r::Int64, v::Int64)
    i = p
    if p < r
       q = floor(Int, (p+r)/2)  # floor() er en innebygd funksjon som runder ned. ceil() runder opp.
       if v <= A[q]
           i = bisect_left(A, p, q, v)
       else
           i = bisect_left(A, q+1, r, v)
       end
    end
    return i
end
function bisect_right(A, p, r, v)
    i = p
    if p < r
       q = floor(Int, (p+r)/2)  # floor() er en innebygd funksjon som runder ned. ceil() runder opp.
       if v >= A[q]
           i = bisect_right(A, q+1, r, v)
       else
           i = bisect_right(A, p, q, v)
       end
    end
    return i
end

function algdat_sort!(A)
    merge_sort(A,1,length(A))
end

function find_median(A, lower, upper)
    lower_index = bisect_left(A, 1, length(A), lower)
    if upper >= A[length(A)]
        upper_index = bisect_right(A, 1, length(A), upper)
    else
        upper_index = bisect_right(A, 1, length(A), upper) - 1
    end
    println("low: ", lower_index, ". high: ", upper_index)
    q = (lower_index+upper_index)/2
    println("q: ", q)
    isOdd = convert(Bool, mod(upper_index-lower_index+1,2))
    println("isOdd: ", isOdd)
    if isOdd # if sublist has odd number of entries
        return  A[floor(Int, q)]
    else    #elseif sublist has even number of entries
        return (A[floor(Int, q)] + A[ceil(Int, q)])/2
    end
end

#v = 5
#list = rand(-100:100, 20)
#println("initialized list: ", list)
#algdat_sort!(list)
#println("post sort list: ", list)
A=[0, 0, 0, 3, 5, 10, 11, 13, 15, 19, 21, 21, 26, 26, 27]

println( "median: ", find_median(A, 0,50))
