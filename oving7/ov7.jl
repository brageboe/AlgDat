function can_use_greedy(coins::Array{Int64,1})
    n = length(coins)
    for c = 1:(n-1)
        if coins[c] < coins[c+1]
            return error("coins array must be in descending order.")
        end
        if mod(coins[c], coins[c+1]) != 0
            return false
        end
    end
    return true
end

function min_coins_greedy(coins::Array{Int64,1}, value::Int64)
    remainder = value
    amount_coins = 0 # output
    it = 1 # iterator
    while remainder != 0 && it <= length(coins)
        if coins[it] <= remainder
            amount_coins += 1
            remainder -= coins[it]
        else
            it += 1
        end
    end
    return amount_coins
end

function min_coins_dynamic(coins::Array{Int64,1}, value::Int64)
    n = length(coins)
    inf = typemax(Int)
    # table[i] will be storing the minimum number of coins required for i value.
    # so table[value] will have the result.
    table = zeros(Int64, value)   # table[1]=0 base case (if value=0)
    if value == 0
        return 0
    end
    for i = 2:value # initialize table values as inf.
        table[i] = inf
    end

    for i = 1:value # compute min coins required for all values from 1 to value
        for j = 1:n # go through all coins smaller than i
            if coins[j] <= i
                if i == coins[j]
                    table[i] = 1
                    sub_result = inf
                else
                    sub_result = table[i-coins[j]]
                end
                if sub_result != inf && sub_result + 1 < table[i]
                    table[i] = sub_result + 1
                end
            end
        end
    end
    return table[value]
end

function main()
    coins = [1000,500,100,20,5,1]
    value = 8
    if can_use_greedy(coins)
        println(min_coins_greedy(coins, value))
    end
        println(min_coins_dynamic(coins, value))
end

main()
