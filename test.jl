using SpecialFunctions
libgmp = Base.GMP.libgmp
function divexact(x::BigInt,y::BigInt)::BigInt
    z = BigInt()
    ccall((:__gmpz_divexact, libgmp), Cvoid, (Ref{BigInt}, Ref{BigInt}, Ref{BigInt}), z, x, y)
    z
end

function pochhammer_bigint(x::BigInt, n::BigInt)::BigInt
    if n <= 0
        throw(DomainError(n, "pochhammer(x, n) is undefined for n ≤ 0"))
    end
    result = one(BigInt)
    for i in 0:BigInt(n - 1)
        result *= x + i
    end
    return result
end

function pochhammer_int(x::Int64, n::Int64)::BigInt
    if n <= 0
        throw(DomainError(n, "pochhammer(x, n) is undefined for n ≤ 0"))
    end
    result = one(BigInt)
    for i in 0:(n - 1)
        result *= x + i
    end
    return result
end

function pochhammer_gmp(x::BigInt, n::BigInt)::BigInt
    if n <= 0
        throw(DomainError(n, "pochhammer(x, n) is undefined for n ≤ 0"))
    end
    return divexact(factorial(x+n-1),factorial(x-1))
end

function pochhammer_mpfr(x::BigFloat, n::BigFloat)::BigFloat
    if (isinteger(x) && x<=0) || (isinteger(x+n) && x+n<=0)
        throw(DomainError(n, "pochhammer(x, n) is undefined for x or x+n is a non-positive integer."))
    end
    return div(SpecialFunctions._gamma(x+n),SpecialFunctions._gamma(x))
end




function testing(t::Int64)
    n = t
    x = BigInt(1)
    c = BigInt(n)
    L=10000
    l = x:x+L-1
    v1 = Vector{Float64}(undef,L)
    v2 = Vector{Float64}(undef,L)
    for i in BigInt(1):BigInt(L)
        ts = @timed pochhammer_bigint(BigInt(x),c)
        ts_gmp = @timed pochhammer_gmp(BigInt(x),c)
        # if ts.time < ts_gmp.time
        #     println("\nfin:",x," ",ts.time," ",ts_gmp.time)
        # end
        v1[i]=ts.time
        v2[i]=ts_gmp.time
        print("\r$x")
        x+=1
    end
    
    return l,v1, v2
end

using CairoMakie

t = 14
f = Figure()
x, v1, v2 = testing(200)
#x = 1:length(v1)
ax = Axis(f[1, 1], xlabel="x", ylabel="y")
scatter!(ax,x ,log.(v1),color=:blue,markersize=2)
scatter!(ax,x ,log.(v2),color=:red,markersize=2)

save("result_$t.png",f)

