include("sector.jl")

import Statistics: mean
using Roots
using Images
using Distributions: Normal, pdf

function load_image(filepath::String)
    image = load(filepath)
    image = eltype(image) <: RGB ? image : RGB.(image)
    return image
end

templates = Dict([
        (name="i", template=[ Sector(deg2rad.([0.0,18])...) ]),
        (name="V", template=[ Sector(deg2rad.([0.0,93.6])...) ]),
        (name="L", template=[ Sector(deg2rad.([-39.6,39.6])...), Sector(deg2rad.([81.0,99.0])...) ]),
        (name="I", template=[ Sector(deg2rad.([-9.0,9.0])...), Sector(deg2rad.([171.0,189.0])...) ]),
        (name="T", template=[ Sector(deg2rad.([0.0,180.0])...) ]),
        (name="Y", template=[ Sector(deg2rad.([-9.0,9.0])...), Sector(deg2rad.([133.2,226.8])...) ]),
        (name="X", template=[ Sector(deg2rad.([-46.6,46.6])...), Sector(deg2rad.([133.2,226.8])...) ])
    ]);

const normal_dist = Normal()
const Template = Vector{Sector}
Base.in(r::Radian, t::Template) = any(r in s for s in t);
mean_distance(radians::Array{Radian}, t::Template, weights::Array{Float32}) = mean([distance(r,t) for r in radians] .* weights)

# find the angle by which sectors in a template must be rotated to get the minimum mean distance
function find_min_α(hues::Matrix{Radian}, saturations::Matrix{Float32}, template::Template)
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

function get_hue_and_saturation(image::Matrix{<:RGB})
    channels = channelview(HSV.(image));
    hues = @. channels[1,:,:] |> deg2rad |> Radian
    saturations = channels[2,:,:]
    return hues, saturations
end
    
function harmonize(image::Matrix{<:RGB}, template::Template)
    hues, saturations = get_hue_and_saturation(imresize(image, (100,100)))
    α_min, _ = find_min_α(hues, saturations, template)
    template = template .+ α_min
    channels = channelview(HSV.(image))
    hues = @. channels[1,:,:] |> deg2rad |> Radian
    hue_to_new_hue = Dict(hue => shift_hue(hue, template) for hue in unique(hues))
    hues = [rad2deg.(hue_to_new_hue[hue].val) for hue in hues]
    channels[1,:,:] = hues
    return colorview(HSV, channels)
end

image = load_image("./images/dinos.png");
[image harmonize(image, templates["X"]) harmonize(image, templates["Y"]); 
 harmonize(image, templates["i"]) harmonize(image, templates["V"]) harmonize(image, templates["L"])]

