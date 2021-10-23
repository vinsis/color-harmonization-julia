include("sector.jl")

templates = [
        (name="i", template=[ Sector(0.0,18) ]),
        (name="V", template=[ Sector(0.0,93.6) ]),
        (name="L", template=[ Sector(-39.6,39.6), Sector(81.0,99.0) ]),
        (name="I", template=[ Sector(-9.0,9.0), Sector(171.0,189.0) ]),
        (name="T", template=[ Sector(0.0,180.0) ]),
        (name="Y", template=[ Sector(-9.0,9.0), Sector(133.2,226.8) ]),
        (name="X", template=[ Sector(-46.6,46.6), Sector(133.2,226.8) ])
    ]

import Statistics: mean
const Template = Array{S,1} where S<:Sector
mean_distance(degrees::Array{<:Degree}, t::Template, weights::Array{<:Real}) = mean([distance(d,t) for d in degrees] .* weights)

# find the angle by which sectors in a template must be rotated to get the minimum mean distance
get_min_mean_dist_and_angle(degrees::Array{<:Degree}, t::Template, weights::Array{<:Real}) = findmin([mean_distance(degrees, t .+ d, weights) for d=0:359])
