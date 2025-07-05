
using CairoMakie

function makepng()
    #k = big"0.01":big"0.01":big"1.0"
    ll = 1:67
    k_err = Vector{BigFloat}()
    c = yK(1/sqrt(big"2.0"),2000)
    for i in 1:67
        push!(k_err,-log10(abs(yK(1/sqrt(big"2.0"),ll[i])-c)))
        print("(",k_err[i],"),")
    end

    f = Figure()
    ax = Axis(f[1, 1], xlabel="k", ylabel="k_err")
    #lines!(ax, k, k_err)
    lines!(ax, ll, k_err)
    save("result4.png",f)
end

