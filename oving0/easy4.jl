function century(ARGS)
	year = ARGS
	if mod(year,100)==0
		return Int64(year/100)
	else
		return Int64(round(year/100)+1)
	end
	println(ans)
end

