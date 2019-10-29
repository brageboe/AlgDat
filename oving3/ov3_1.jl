function bisect_left(A, p, r, v)
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

list = rand(-100:100, 20)
v = 2

println(list)
println( bisect_left(list, 1, length(list)+1, v) )
#println( bisect_right(list, 1, length(list)+1, v) )





function bisect(A, p, r, v)
    if p <= r
        q = floor(Int, (p+r)/2)
        if v == A[q]
            return q
        elseif v < A[q]
            return bisect(A, p, q-1, v)
        else
            return bisect(A, q+1, r, v)
        end
    else
        return nothing
    end
end
