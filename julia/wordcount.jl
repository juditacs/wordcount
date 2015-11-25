function main()
    wc = Dict{AbstractString,Int64}()
    for l in eachline(STDIN)
        for w in split(l)
            wc[w]=get(wc, w, 0) + 1
        end
    end

    for t in sort(collect(wc), by=x -> (-x.second, x.first))
        println(t.first, "\t", t.second)
    end
end

main()
