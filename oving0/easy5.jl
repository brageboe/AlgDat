

function predictAge(age_ancestors)

	return Int64(floor(sqrt(sum(age_ancestors.^2))/2))
end

ages = [65, 60, 75, 55, 60, 63, 64, 45]

println(predictAge(ages))	