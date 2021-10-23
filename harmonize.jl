include("template.jl")

using Images
using Plots

function get_hue_and_saturation(filename)
    image = HSV.(load(filename))
    channels = channelview(image)
    hues = channels[1,:,:]
    saturations = channels[2,:,:]
    return hues, saturations
end

hues, saturations = get_hue_and_saturation("/Users/sisovina/Downloads/cat.jpg")

function plot_hues(hues)
    int_hues = floor.(copy(hues))
    f(θ) = sum(int_hues .== floor(rad2deg(θ)))
    plot(f, 0, 2π, proj=:polar, yaxis=false)
end

plot_hues(hues)

index_of_closest_sector(hue::Degree, sectors::Template) = ifelse(length(sectors)==1, 1, argmin([distance(hue, s) for s in sectors]))

function shift_hues(hues::Matrix{<:Degree}, template::Template)
    # also calculate the width of each sector
    indices = [index_of_closest_sector(hue, template) for hue in hues]
    sectors = [template[index] for index in indices]
    centers = center_of_sector.(sectors)
    widths = width_of_sector.(sectors)
    dists = hues .- centers
    # calculate G_{σ}.(dists) where σ = width/2
    # shift the hues, convert to Float and return
    return hues
end

hues_degree = Degree.(hues)
dist_and_angles = [get_min_mean_dist_and_angle(hues_degree, t, saturations) for (_,t) in templates]
index = argmin(first.(dist_and_angles))
angle = dist_and_angles[index][2]
template = templates[index][2] .+ angle

floor.([h.val for h in hues])