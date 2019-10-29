tic()
	
A = [5,3,2,6,1,7,4,25,0,1000,42,12,4,3,66,124,9]

function insertionSort(A)
	# A is an array of numbers to be sorted
	for i in 2:length(A) 
		key = A[i]
		j = i-1
		while j>0 && A[j]>key
			A[j+1] = A[j]
			j=j-1
		end
		A[j+1] = key
	end
end

println(A)

insertionSort(A)

println(A)

toc()