module PrefixSpan

# Data Structure
export Transaction, Pairdata
const Transaction = Tuple{UInt, Vector{UInt}}

type Pairdata
    database::Vector{Transaction}
    indices::Vector{UInt}
end

init() = Pairdata(Vector{Transaction}(),
                  Vector{UInt}())

# Algorithm (entry point)

export run, display
function run(filename, min_sup::Int, num_pat::Int)
    pd = init()
    read(filename, pd)
    # display(pd)
    pattern = Vector{UInt}()
    project(pd, min_sup, num_pat, pattern)
end

function display(pd::Pairdata)
    N = length(pd.database)
    for i=1:N
        ts = pd.database[i]
        print(ts[1])
        print(":")
        for ui in ts[2]
            print("$ui ")
        end
        println()
    end
end


function read(filename::String, pd::Pairdata)
    println("reading: $filename")
    open(filename) do f
        id = 0
        lines = readlines(f)
        for line in lines
            itemset = Vector{UInt}()
            for item in split(strip(line))
                iitem = parse(UInt, item)
                push!(itemset, iitem)
            end
            trans = (id, itemset)
            push!(pd.database, trans)
            push!(pd.indices, 1)
            id += 1
        end
    end
end

function print_pattern(projected::Pairdata, pattern::Vector{UInt})
    for item in pattern
        print("$item ")
    end
    print("\n(")
    for trans in projected.database
         print("$(trans[1]) ")
    end
    println("): $(length(projected.database))")
end

function project(projected::Pairdata,
                 min_sup::Int, num_pat::Int,
                 pattern::Vector{UInt})
    if length(projected.database) < min_sup
        return
    end

    print_pattern(projected, pattern)

    # maximum size constraint
    if num_pat != 0 && length(pattern) == num_pat
        return
    end
        
    # processing 1: count occurrences after indeces
    map_item = Dict{UInt, UInt}()
    database = copy(projected.database)
    for i=1:length(database)
        itemset = database[i][2]
        for iter=projected.indices[i]:length(itemset)
            v = get(map_item, itemset[iter], 0) + 1
            map_item[itemset[iter]] = v
        end
    end

    # debug
    if false
        for key in map_item
            println(key[1], "->", key[2])
        end
    end

    # processing 2: make projected database
    keylist = sort(collect(keys(map_item)))
    for key in keylist
        pd = init()
        new_database = pd.database
        new_indices = pd.indices
        for i=1:length(database)
            itemset = copy(database[i][2])
            for iter=projected.indices[i]:length(itemset)
                if itemset[iter] == key[1]
                    push!(new_database, database[i])
                    push!(new_indices, iter + 1)
                end
            end
        end
        new_pattern = copy(pattern)
        push!(new_pattern, key[1])
        project(pd, min_sup, num_pat, new_pattern)
    end
end


# end of module
end
