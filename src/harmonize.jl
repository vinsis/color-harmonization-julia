include("sector.jl")

import Statistics: mean
using Roots
using Images
using Distributions: Normal, pdf
using Plots

templates = [
        (name="i", template=[ Sector(deg2rad.([0.0,18])...) ]),
        (name="V", template=[ Sector(deg2rad.([0.0,93.6])...) ]),
        (name="L", template=[ Sector(deg2rad.([-39.6,39.6])...), Sector(deg2rad.([81.0,99.0])...) ]),
        (name="I", template=[ Sector(deg2rad.([-9.0,9.0])...), Sector(deg2rad.([171.0,189.0])...) ]),
        (name="T", template=[ Sector(deg2rad.([0.0,180.0])...) ]),
        (name="Y", template=[ Sector(deg2rad.([-9.0,9.0])...), Sector(deg2rad.([133.2,226.8])...) ]),
        (name="X", template=[ Sector(deg2rad.([-46.6,46.6])...), Sector(deg2rad.([133.2,226.8])...) ])
    ];

const normal_dist = Normal()
const Template{T} = Vector{Sector{T}}
mean_distance(radians::Array{<:Radian}, t::Template, weights::Array{<:Real}) = mean([distance(r,t) for r in radians] .* weights)

# find the angle by which sectors in a template must be rotated to get the minimum mean distance
function find_min_α(hues::Matrix{Radian{T}}, saturations::Matrix{T}, template::Template{T}) where T
    cost(α) = mean_distance(hues, template .+ α, saturations)
    α_min = find_zero(cost, [deg2rad(1), 2π], Roots.Brent())
    return α_min, cost(α_min)
end

function shift_hue(hue::Radian, template::Template)
    dist, index = findmin(distance(hue, s) for s in template)
    if dist == 0.0
        return hue
    end
    s = template[index]
    extra_dist = width_of_sector(s)/2 * pdf(normal_dist, dist)/pdf(normal_dist, 0)
    if counter_clockwise_angle(hue, s.from) < counter_clockwise_angle(s.to, hue)
        return hue + dist + extra_dist
    else
        return hue + (2π - dist - extra_dist)
    end
end
    
function harmonize(image::Matrix{<:RGB}, template::Template)
    channels = channelview(HSV.(image))
    hues = @. channels[1,:,:] |> deg2rad |> Radian
    saturations = convert(Array{Float64}, channels[2,:,:])
    α_min, _ = find_min_α(hues, saturations, template)
    template = template .+ α_min
    hue_to_new_hue = Dict(hue => shift_hue(hue, template) for hue in unique(hues))
    hues = [rad2deg.(hue_to_new_hue[hue].val) for hue in hues]
    channels[1,:,:] = hues
    return colorview(HSV, channels)
end

function plot_hues(hues)
    int_hues = floor.(copy(hues))
    f(θ) = sum(floor(θ) .== int_hues)
    plot(f, 0, 2π, proj=:polar, yaxis=false)
end

image = load("./images/stickers.jpg");
# image = load("~/Downloads/cat.jpg");
channels = channelview(HSV.(image));
hues = channels[1,:,:];
print(size(hues))
plot_hues(hues)

