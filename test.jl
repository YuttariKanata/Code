libgmp = Base.GMP.libgmp

perfect_square(x::BigInt) = Int(ccall((:__gmpz_perfect_square_p, libgmp), Cint, (Ref{BigInt},), x))
