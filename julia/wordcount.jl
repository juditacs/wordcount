customlt(a,b) = (b.second < a.second) ? true : b.second == a.second ? a.first < b.first : false

function main()
    wc = Dict{UTF8String,Int64}()
    for l in eachline(STDIN)
        for w in split(l)
            wc[w]=get(wc, w, 0) + 1
        end
    end

    v = collect(wc)
    sort!(v,lt=customlt)
    for t in v
        @printf("%s\t%d\n",t.first,t.second)
    end
end

main()
