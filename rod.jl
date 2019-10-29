function rod(A,n)
tmp = 0
for i=1:n
    tmp = max(A[i] + rod(A,n-i))
end
return tmp
end

A = [3,7,12,13]
n = 4

println(rod(A,n))
