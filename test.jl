function th3(q::BigFloat,n::Int64)::BigFloat
    s = zero(BigFloat)
    for i in 1:n
        s += q^(i^2)
    end
    return s*2+1
end

function eps_to_q(eps::BigFloat,n::Int)::BigFloat
    q = zero(BigFloat)
    for i in 1:n
        q = eps_q_for_n(eps,q,i)
    end
    return q
end

function eps_q_for_n(eps::BigFloat,q::BigFloat,n::Int)::BigFloat
    if iseven(n)
        r = eps + 2*q^4*eps
        for i in 4:2:n
            r += (-1)*q^((i-1)^2) + 2*q^(i^2)*eps
        end
    else
        r = eps
        for i in 3:2:n
            r += 2*q^((i-1)^2)*eps - q^(i^2)
        end
    end
    return r
end

#=
q=e + 2q^4e - q^9 + 2q^16e - q^25
0=     - q        - q^9          - q^25
   + e     +2q^4e       + 2q^16e
=#

function sigm(q::BigFloat,ll::Int64)::BigFloat
    s = zero(BigFloat)
    for i in 1:ll
        s += (q^(i<<1))/((1-q^(i<<1))^2)
    end
    return s
end

function yK(k::BigFloat,ll::Int64;is_k_ = false)::BigFloat
    if k^2 >= 0.5 && !is_k_
        return yK_(k,ll; is_k_ = true)
    end

    if !is_k_
        k_ = sqrt(1-k^2)
    else
        k_ = k
    end

    eps = -(1/2)+1/(1+sqrt(k_))

    q = eps_to_q(eps,ll)

    return (pi/2)*(th3(q,ll))^2
end

function yK_(k::BigFloat,ll::Int64;is_k_ = false)::BigFloat
    if k^2 >= 0.5 && !is_k_
        return yK(k,ll; is_k_ = true)
    end

    if !is_k_
        k_ = sqrt(1-k^2)
    else
        k_ = k
    end   

    eps = -(1/2)+1/(1+sqrt(k_))

    q = eps_to_q(eps,ll)

    return (-log(q)/2)*(th3(q,ll))^2
end

function yE(k::BigFloat,ll::Int64;is_k_ = false)::BigFloat
    if k^2 >= 0.5 && !is_k_
        return yE_(sqrt(1-k^2),ll)
    end

    if !is_k_
        k_ = sqrt(1-k^2)
    else
        k_ = k
    end  

    eps = -(1/2)+1/(1+sqrt(k_))

    q = eps_to_q(eps,ll)

    t = th3(q,ll)

    s = sigm(q,1000)


    return pi*( (1/t^2)*(1/BigFloat(6)-4*s) + t^2*((2-k^2)/BigFloat(6)) )
end

function yE_(k::BigFloat,ll::Int64;is_k_ = false)::BigFloat
    if k^2 >= 0.5 && !is_k_
        return yE(k,ll, is_k_ = true)
    end

    if k <= big"4.5e-154" && !is_k_
        return 1
    end

    if !is_k_
        k_ = sqrt(1-k^2)
    else
        k_ = k
    end  

    eps = -(1/2)+1/(1+sqrt(k_))

    q = eps_to_q(eps,ll)

    t = th3(q,ll)

    s = sigm(q,1000)

    lnq = log(q)

    return -t^2*lnq*((1+k^2)/BigFloat(6)) + (1/t^2)*(lnq*(1/BigFloat(6)-4*s)+1)
end


function th4(q::BigFloat,n::Int64)::BigFloat
    s = zero(BigFloat)
    for i in 1:n
        s += q^(i^2)*(-1)^i
    end
    return s*2+1
end

function q_to_sqrtk_(q::BigFloat)::BigFloat
    return th4(q,10000)/th3(q,10000)
end

function error_in_sqrtk_(k::BigFloat, ll::Int64)::BigFloat
    # 真の sqrt(k_) を求める
    sqrt_k_ = sqrt(1 - k^2)

    # eps を定義して、そこから q を得る
    eps = -(1/2) + 1 / (1 + sqrt_k_)
    q = eps_to_q(eps, ll)

    # q から逆変換された sqrt(k_) の近似値
    approx_sqrt_k_ = q_to_sqrtk_(q)

    # 誤差（絶対値）
    return -log10(abs(sqrt_k_ - approx_sqrt_k_))
end


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

