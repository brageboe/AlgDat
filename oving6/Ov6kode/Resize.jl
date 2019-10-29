

module Resize

using Images, ImageFiltering

export reduce_width

function path_weights(weights)
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

function back_track(path_weights)
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

function gradiant(image)
    kernel = [1 0 -1; 2 0 -2;1 0 -1]
    sobel_x = imfilter(image, centered(kernel))
    grad = imfilter(sobel_x, centered(kernel'))
end

function absolute_gradiant(image)
    height, width = size(image)
    grad = gradiant(image)
    reshape([abs(pixel.r)+abs(pixel.g)+abs(pixel.b) for pixel in grad],height,width)
end

function reduce_width(image_url, reduction)
    image = load(image_url)

    for i in 1:reduction
        h, w = size(image)

        #=
        Det finnes mange måter å gi hver piksel en vekt.
        Her brukes summen av absoluttverdiene avgradientene,
        men det kan endres om man vil.
        =#
        weights = absolute_gradiant(image)
        cumulative_weights = path_weights(weights)

        #=
        Her bruker vi stien vi finner med back_track til å lage en boolsk
        matrise der cellene vi ønsker å fjerne fra bildet har verdien false
        =#
        crop_matrix = ones(Bool,h,w)
        for (i,j) in back_track(cumulative_weights)
            crop_matrix[i,j] = false
        end

        #=
        Et boolsk oppslag i matrisen vår fjerner alle celler der den boolske
        matrisen er false. Fordi resultatet av et slikt oppslag er en 1-dimensjonell
        matrise så bruker vi reshape for å få originalformen tilbake, minus den ene
        pikselen vi har fjernet i bredden.
        =#
        image = reshape(image'[crop_matrix'],w-1,h)'
    end

    image
end

function main()
    reduce_width("tower.jpg",200)
end

end
