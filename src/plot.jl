using Plots
using Images
using DataStructures: counter

const RADIANS = range(0, stop=2π, length=360);
const HUE_COLORS = HSV.(1:360,1,1);


image = load("/Users/sisovina/Downloads/cat.jpg");
channels = channelview(HSV.(image));
hues = channels[1,:,:];

function plot_hues(hues::Array{Float32})
    value_count = floor.(hues[hues .> 0.0]) |> counter |> collect;
    max_count = maximum(x -> x[2], value_count);
    value_count = [ [deg2rad(k), v/max_count] for (k,v) in value_count ];
    value_count = transpose(reduce(hcat, value_count));
    value_count = value_count[sortperm(value_count[:,1]), :];
    scatter(RADIANS, ones(360), proj=:polar, lims=(0,1.1), color=HUE_COLORS, markerstrokecolor=HUE_COLORS, markersize=10);
    plot!(value_count[:,1], value_count[:,2], proj=:polar, linecolor=:black, linewidth=2)
end

function plot_template(template::Template)
    θ = range(0, stop=2π, length=360)
    f(θ) = Radian(θ) in template ? 1f0 : 0f0
    scatter(RADIANS, ones(360), proj=:polar, lims=(0,1.1), color=HUE_COLORS, markerstrokecolor=HUE_COLORS, markersize=10);
    plot!(θ, f.(θ), proj=:polar, lims=(0,1.1), linecolor=:black, linewidth=2)
end
