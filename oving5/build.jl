struct Node
    children::Dict{Char, Node} #er en oppslagstabell med alle nodebarna til noden (noder direkte underlagt noden du står i). Den angir kobling mellom bokstav og node
    posi::Array{Int} #er en liste over indeksene hvor ordet begynner i tekststrengen.
end
Node() = Node(Dict(), [])

function parse_string(sentence::String)
    # Returns an array of tuples (String,Int) containing all words and index position of input sentence string
    output = Array{Tuple{String, Int64}, 1}()
    splits = split(sentence)
    index = 1
    for word in splits#i = 1:length(splits)
        push!(output, (word, index))
        index += length(word) + 1
    end
    return output
end

function build(list_of_words::Array{Tuple{String, Int64}, 1})
    root = Node()
    for key in list_of_words
		current = root
        for char in key[1]
            if !haskey(current.children, char) # evt. !(char in keys(parent.children))
                current.children[char] =  Node()
            end
            current = current.children[char]
        end
        push!(current.posi, key[2])
    end
	return root
end

function positions(word::String, node::Node, i=1)
	if i == length(word)+1
		return node.posi
	elseif word[i] == '?'
		ret = []
		for next in values(node.children)
			append!(ret, positions(word, next, i+1))
		end
		return ret
	elseif haskey(node.children, word[i])
		return positions(word, node.children[word[i]], i+1)
	else
		return []
	end
end



A = "ha ha mons har en hund med moms hun er en hunn"
B = parse_string(A)
build(B)
