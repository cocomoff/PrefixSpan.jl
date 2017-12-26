module PrefixSpan

# Data Structure
export Transaction, Pairdata, clear
const Transaction = Tuple{UInt, Vector{UInt}}

type Pairdata
    database::Vector{Transaction}
    indices::Vector{UInt}
end

clear() = Pairdata(Vector{Transaction}(),
                   Vector{UInt}())

# Algorithm (entry point)

export run, display
function run(filename, min_sup, num_pat)
    pd = clear()
    read(filename, pd)
    display(pd)
    project(pd)
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
            push!(pd.indices, 0)
            id += 1
        end
    end
end

function project(pd::Pairdata)
end


# end of module
end
