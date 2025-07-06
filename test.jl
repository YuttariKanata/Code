"""
    pochhammer(x, n)

Compute the Pochhammer symbol, also known as the rising factorial:  
``x₍ₙ₎= x * (x + 1) * (x + 2) * ... * (x + n - 1)``.


# Arguments

- `x`: A number (can be an integer, floating-point, complex, etc.).
- `n`: A positive integer specifying how many terms to multiply.

# Examples

```jldoctest
julia> pochhammer(3, 4)
360

julia> pochhammer(5.0, 1)
5.0
```
"""
function pochhammer(x::BigInt, n::BigInt)::BigInt
    if n <= 0
        throw(DomainError(n, "pochhammer(x, n) is undefined for n ≤ 0"))
    end
    result = one(BigInt)
    for i in 0:BigInt(n - 1)
        result *= x + i
    end
    return result
end

