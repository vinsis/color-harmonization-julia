const C360 = 360.0

struct Degree{T<:Real}
    val::T
    Degree{T}(x::Real) where T<:Real = (x = rem(x, C360); x = ifelse(x≥0, x, x+C360); new{typeof(x)}(x))
end
Degree(x::Real) = Degree{typeof(x)}(x)

for op = (:+, :-)
    @eval Base.$op(x::Degree, y::Degree) = Degree($op(x.val, y.val))
    @eval Base.$op(x::Degree, y::Real) = Degree($op(x.val, y))
    @eval Base.$op(y::Real, x::Degree) = $op(x,y)
    @eval Base.$op(x::Degree) = Degree($op(x.val))
end

Base.:*(x::Degree, y::Real) = Degree(x.val * y)
Base.:*(y::Real, x::Degree) = x*y
Base.:/(x::Degree, y::Real) = Degree(x.val / y)

struct Sector{T}
    from::Degree{T}
    to::Degree{T}
end
Sector(x::Real, y::Real) = Sector(Degree(x), Degree(y))

for op = (:+, :-)
    @eval Base.$op(s::Sector, y::Union{Degree, Real}) = Sector($op(s.from,y), $op(s.to,y))
end
Base.:-(s::Sector) = s + 180.0
Base.in(d::Degree, s::Sector) = (d - s.from).val ≤ (s.to - s.from).val

function distance(d::Degree, s::Sector{T})::T where T
    d in s ? 0.0 : min((s.from-d).val, (d-s.to).val)
end

function center_of_sector(s::Sector{T})::Degree{T} where T
    s.from + (s.to - s.from)/2
end

function width_of_sector(s::Sector{T})::Degree{T} where T
    s.to - s.from
end

distance(d::Degree, sectors::Array{<:Sector}) = minimum(distance(d,s) for s in sectors)