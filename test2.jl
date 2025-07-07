using Primes


print("using CairoMakie ...")
using CairoMakie
println(" done!")

function count_primes(f::Function,n_max::Int64)
    c = 0
    n_values = Vector{Int64}()
    for n in 1:n_max
        if isprime(f(n))
            push!(n_values, n)
        end
        c+=1
        if c == 1000000
            print("\r$n")
            c = 0
        end
    end
    return n_values
end

function count_primes_big(f::Function,n_max::Int64)
    c = 0
    n_values = Vector{Int64}()
    for n in 1:n_max
        if isprime(f(BigInt(n)))
            push!(n_values, n)
        end
        c+=1
        if c == 1000000
            print("\r$n")
            c = 0
        end
    end
    return n_values
end

function count_primes_soft_big(f::Function,n_max::Int64)
    c = 0
    cp = 0
    n_values = Vector{Int64}()
    c_values = Vector{Int64}()
    for n in 1:n_max
        if isprime(f(BigInt(n)))
            cp += 1
        end
        c+=1
        if c == 10000
            print("\r$n")
            push!(n_values,n)
            push!(c_values,cp)
            c = 0
        end
    end
    return c_values, n_values
end

function count_primes_soft(f::Function,n_max::Int64)
    c = 0
    cp = 0
    n_values = Vector{Int64}()
    c_values = Vector{Int64}()
    for n in 1:n_max
        if isprime(f(n))
            cp += 1
        end
        c+=1
        if c == 100000
            print("\r$n")
            push!(n_values,n)
            push!(c_values,cp)
            c = 0
        end
    end
    return c_values, n_values
end

function makeAs(L)
    n_values = count_primes_big(f6,L)
    open("As_$L.txt","w") do file
        Base.print_array(file,n_values)
    end
end

function read_numbers_under_n(filename::AbstractString,n::Int64)::Vector{Int64}
    lines = readlines(filename)
    nums = map(x -> parse(Int, strip(x)), lines)

    cutoff = findfirst(x -> x >= n, nums)
    return cutoff === nothing ? nums : nums[1:cutoff-1]
end


L = 1_0000_0000
fig = Figure()
ax = Axis(fig[1, 1], xlabel="x", ylabel="y")


# 多項式の定義（整数係数であれば何でもOK）
f1(n::Int64)::Int64 = (n+1)*n + 41
fs="(n+1)*n + 41"

c_values, n_values = count_primes_soft(f1,L)
println("Total number of n such that f1(n) is prime: ", c_values[end])
lines!(ax,n_values ,c_values ,color=:yellowgreen , label=fs)
text!(ax, n_values[end],  c_values[end], text=   "$(c_values[end])", align=(:right,:top))
n_values = Vector{Int}()
GC.gc()

f2(n::Int64)::Int64 = (n+1)*n+247757
fs="(n+1)*n+247757"

c_values, n_values = count_primes_soft(f2,L)
println("Total number of n such that f2(n) is prime: ", c_values[end])
lines!(ax,n_values ,c_values ,color=:gold , label=fs)
text!(ax, n_values[end],  c_values[end], text=   "$(c_values[end])", align=(:right,:top))
n_values = Vector{Int}()
GC.gc()

f3(n::Int64)::Int64 = abs((n+1151)*n-1023163)
f3(n::BigInt)::BigInt = abs((n+1151)*n-1023163)
fs="(n+1151)*n-1023163"

c_values, n_values = count_primes_soft(f3,L)
println("Total number of n such that f3(n) is prime: ", c_values[end])
lines!(ax,n_values ,c_values ,color=:deepskyblue2 , label=fs)
text!(ax, n_values[end],  c_values[end], text=   "$(c_values[end])", align=(:right,:top))
n_values = Vector{Int}()
GC.gc()

f4(n::Int64)::Int64 = 210*n+1
fs="210*n+1"

c_values, n_values = count_primes_soft(f4,L)
println("Total number of n such that f4(n) is prime: ", c_values[end])
lines!(ax,n_values ,c_values ,color=:orangered2 , label=fs)
text!(ax, n_values[end],  c_values[end], text=   "$(c_values[end])", align=(:right,:top))
n_values = Vector{Int}()
GC.gc()

f5(n::Int64)::Int64 = n
fs="n"

c_values, n_values = count_primes_soft(f5,L)
println("Total number of n such that f5(n) is prime: ", c_values[end])
lines!(ax,n_values ,c_values ,color=:darkorange4 , label=fs)
text!(ax, n_values[end],  c_values[end], text=   "$(c_values[end])", align=(:right,:top))
n_values = Vector{Int}()
GC.gc()

f6(n::BigInt)::BigInt = abs((n+1)*n-33251810980696878103150085257129508857312847751498190349983874538507313)
fs="abs((n+1)*n-33251810980696878103150085257129508857312847751498190349983874538507313)"

c_values, n_values = count_primes_soft_big(f6,L)
#open("As.txt","w") do file
#    Base.print_array(file,n_values)
#end
#n_values = read_numbers_under_n("As.txt",L)

println("Total number of n such that f6(n) is prime: ", c_values[end])
lines!(ax,n_values ,c_values ,color=:orangered2 , label=fs)
text!(ax, n_values[end],  c_values[end], text=   "$(c_values[end])", align=(:right,:top))
n_values = Vector{Int}()
GC.gc()

axislegend(ax, position=:lt)
save("prime4.png",fig)







