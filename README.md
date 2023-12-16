# VGA Image Generation Project

## High-Level Description
This project showcases the development of a Verilog-based system for generating and displaying images on a VGA monitor using the DE2-115 board. It involves two primary modules: `image_generator.v` and `VGA_gen.v`. The `image_generator.v` module is designed to create a radial gradient image, where users can interactively modify the RGB signals using input switches on the DE2-115 board. Meanwhile, `VGA_gen.v` manages the VGA signal generation and synchronization.

## Background Information
VGA (Video Graphics Array) is a standard technology for computer monitor image display. This project dives into the application of Verilog, a hardware description language, for controlling VGA signals in a precise manner, specifically utilizing the capabilities of the DE2-115 board. It's an insightful journey into digital design and computer engineering, demonstrating how hardware programming can be used to manipulate image displays.

## Design Description
- **image_generator.v**: Central to the image generation process, this module outputs a radial gradient, the colors of which can be dynamically changed using input switches on the DE2-115 board. It generates VGA-compatible RGB signals and dictates the primary logic for image creation.
- **VGA_gen.v**: Adapted from Peter Jamieson's design, this module is responsible for generating accurate VGA signals for image display on a monitor, ensuring proper synchronization.

## Complexity of the Design
The complexity of this design lies in its ability to intricately control the VGA signal generation process and effectively manage the image rendering on the VGA monitor. The implementation requires a deep understanding of digital signal processing, timing constraints, and the integration of hardware inputs (switches) for real-time interaction. Managing the synchronization of RGB signals to produce a coherent image, especially one that can be interactively altered, showcases the sophisticated nature of the project. This complexity not only reflects the technical skill required but also the innovative approach to hardware-based image generation.

## Results and Metrics
- The project is successful in dynamically generating and displaying a customizable radial gradient on a VGA monitor. The use of switches on the DE2-115 board to interactively alter the image illustrates the effective integration of hardware programming with visual output.

## Conclusion
This project exemplifies the practical application of Verilog in digital image processing and VGA signal manipulation, particularly highlighting the capabilities of the DE2-115 board. It serves as a foundational exploration into VGA technology and opens new possibilities for hardware-based image generation and interaction.

## Media and Demonstrations
- ![DE2-115 Board Demonstration](https://github.com/smithcn9/ECE287FinalProject/assets/150873409/d3cd949b-5953-4fcf-b4cc-dde2b7dd8087)
- This image demonstrates how each switch controls the color of the inside color by picking an RGB color from the switches. Switch 0 controls the red input, switch 1 controls the green input, and switch 2 controls the blue input, going from right to left.

- [Project Demo Video](https://youtu.be/bxhqV72B3H4)

## Citations and Acknowledgements
- The VGA signal generation module is based on a design by Peter Jamieson, providing a solid basis for this project.

## Contributors
- Carter Smith
