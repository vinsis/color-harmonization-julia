# color-harmonization-julia
This is an implementation of [the paper](https://igl.ethz.ch/projects/color-harmonization/harmonization.pdf) by the same name.

## Setting up
1. Clone the repo and then from the root directory type `] activate .`
2. `] instantiate`

## Demo result
- Perform harmonization on an image according to a given template: `harmonize(image, template)`
![](https://github.com/vinsis/color-harmonization-julia/blob/main/images/demo_result.png)

- Perform harmonization on an image given a reference image according to a given template: 
  - `harmonize(image, reference_image, template)`. 
  - Reference image:
![](https://github.com/vinsis/color-harmonization-julia/blob/main/images/argentina_flag.png)
  - Output for selected templates:
![](https://github.com/vinsis/color-harmonization-julia/blob/main/images/demo_result_argentina_flag.png)

- Results on natural images:
  - Reference image:
![](https://github.com/vinsis/color-harmonization-julia/blob/main/images/autumn.jpg)
  - Output for selected templates:
![](https://github.com/vinsis/color-harmonization-julia/blob/main/images/demo_real_images.png)

## To do
- Solve the issue of nearby pixels getting mapped to far away values
- Experiments:
  - Try to spread out pixels even when they fall within a sector
  - Deal with grey values
