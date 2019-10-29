mutable struct Record
    next::Union{Record,nothing}  # next kan peke på et Record-objekt eller ha verdien nothing.
    value::Int
end

function createlinkedlist(length, valuerange)
    # Lager listen bakfra.
    next = nothing
    record = nothing
    for i in 1:length
        record = Record(next, rand(valuerange))  # valuerange kan f.eks. være 1:1000.
        next = record
    end
    return record
end

function traversemax(record)
	while record === nothing
		println(record)
		record = record.next
	end
end

A = createlinkedlist(1,1)
traversemax(A)
