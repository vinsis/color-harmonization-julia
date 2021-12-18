struct Radian{T<:Real}
    val::T
    function Radian{T}(x::Real) where T<:Real
        x = rem(x, 2π); 
        new{typeof(x)}(x)
    end
end
Radian(x::Real) = Radian{typeof(x)}(x)
@eval Base.:+(x::Radian, y::Radian) = Radian(x.val + y.val)
@eval Base.:+(x::Radian, y::Real) = Radian(x.val + y)
@eval Base.:+(y::Real, x::Radian) = x+y

counter_clockwise_angle(r_from::Radian, r_to::Radian) = Radian(r_to.val + 2π - r_from.val).val

struct Sector{T}
    from::Radian{T}
    to::Radian{T}
end
Sector(x::T, y::T) where T<:Real = Sector(Radian(x), Radian(y))
@eval Base.:+(s::Sector, r::Union{Radian, Real}) = Sector(s.from+r, s.to+r)
@eval Base.:+(r::Union{Radian, Real}, s::Sector) = s+r

# angular distance is always non-negative so its values can be used
# we could also define define ≤ for Radians but it doesn't make sense
Base.in(r::Radian, s::Sector) = counter_clockwise_angle(s.from, r) ≤ counter_clockwise_angle(s.from, s.to)

function distance(r::Radian{T}, s::Sector{T})::T where T
    r in s ? 0.0 : min(counter_clockwise_angle(r, s.from), counter_clockwise_angle(s.to, r))
end

function width_of_sector(s::Sector{T})::Real where T
    counter_clockwise_angle(s.from, s.to)
end

function distance(r::Radian{T}, sectors::Array{<:Sector{T}})::T where T
    minimum(distance(r,s) for s in sectors)
end