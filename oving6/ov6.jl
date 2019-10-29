function cumulative(weights::Array{Int64,2})
    rows, cols = size(weights)
    path_weights = zeros(Int64,rows,cols)
    for j = 1:cols
        path_weights[1,j] = weights[1,j]
    end
    for i = 2:rows
        for j = 1:cols
            if j == 1
                path_weights[i,j] = min( path_weights[i-1, j], path_weights[i-1, j+1] ) + weights[i,j]
            elseif j == cols
                path_weights[i,j] = min( path_weights[i-1, j-1], path_weights[i-1, j] ) + weights[i,j]
            else
                path_weights[i,j] = min( path_weights[i-1, j-1], path_weights[i-1, j], path_weights[i-1, j+1] ) + weights[i,j]
            end
        end
    end
    path_weights
end

function back_track(path_weights::Array{Int64,2})
    rows, cols = size(path_weights)
    path = Array{Tuple{Int64, Int64}, 1}()
    current_col = indexin(minimum(path_weights[rows, 1:cols]), path_weights[rows, 1:cols])[1] #this becomes type Array{Union{Nothing, Int64},0}, thus [1] at end refering to the Int64 value
    push!(path, (rows, current_col))  # index of starting position = [rows, start_col]
    for i = (rows-1):-1:1
        if current_col == 1
            tmp_min = minimum(path_weights[i, (current_col):(current_col+1)])
            tmp_ind = indexin(tmp_min, path_weights[i,(current_col):(current_col+1)])[1] - 1
            current_col += tmp_ind
        elseif current_col == cols
            tmp_min = minimum(path_weights[i, (current_col-1):(current_col)])
            tmp_ind = indexin(tmp_min, path_weights[i,(current_col-1):(current_col)])[1] - 2
            current_col += tmp_ind
        else
            tmp_min = minimum(path_weights[i, (current_col-1):(current_col+1)])
            tmp_ind = indexin(tmp_min, path_weights[i,(current_col-1):(current_col+1)])[1] - 2
            current_col += tmp_ind
        end
        push!(path, (i, current_col))
    end
    path
end

weights = [3  6  8 6 3;
           7  6  5 7 3;
           4  10 4 1 6;
           10 4  3 1 2;
           6  1  7 3 9]

path_w = cumulative(weights)
path = back_track(path_w)
