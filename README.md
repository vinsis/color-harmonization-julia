# color-harmonization-julia
This is an implementation of [the paper](https://igl.ethz.ch/projects/color-harmonization/harmonization.pdf) by the same name.

## Setting up
1. Clone the repo and then from the root directory type `] activate .`
2. `] instantiate`

## Demo result
- Perform harmonization on an image according to a given template: `harmonize(image, template)`
![](https://github.com/vinsis/color-harmonization-julia/blob/main/images/demo_result.png)

- Perform harmonization on an image given a refernece image according to a given template: `harmonize(image, reference_image, template)`. In the result below, leftmost is the reference image, center one is the input and rightmost one is the output.
![](https://github.com/vinsis/color-harmonization-julia/blob/main/images/result_reference_image.png)

## To do
- Solve the issue of nearby pixels getting mapped to far away values
- Experiments:
  - Try to spread out pixels even when they fall within a sector
  - Deal with grey values
