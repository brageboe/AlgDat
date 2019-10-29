function parse_string(sentence::String)
    output = Array{Tuple{String, Int64}, 1}()
    splits = split(sentence)
    index = 1
    for i = 1:length(splits)
        push!(output, (splits[i], index))
        index += length(splits[i]) + 1
    end
    return output
end
