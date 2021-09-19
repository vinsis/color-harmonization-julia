include("sector.jl")

templates = Dict(
        "i" => [ Sector(0.0,18) ],
        "V" => [ Sector(0.0,93.6) ],
        "L" => [ Sector(-39.6,39.6), Sector(81.0,99.0) ],
        "I" => [ Sector(-9.0,9.0), Sector(171.0,189.0) ],
        "T" => [ Sector(0.0,180.0) ],
        "Y" => [ Sector(-9.0,9.0), Sector(140.4,219.6) ],
        "X" => [ Sector(-39.6,39.6), Sector(140.4,219.6) ]
    )

import Statistics: mean
const Template = Array{S,1} where S<:Sector
mean_distance(degrees::Array{<:Degree}, t::Template) = mean(distance(d,t) for d in degrees)

# find the angle by which sectors in a template must be rotated to get the minimum mean distance
get_min_mean_dist_and_angle(degrees::Array{<:Degree}, t::Template) = findmin([mean_distance(degrees, t .+ d) for d=0:359])
