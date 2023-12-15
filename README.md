# VGA Image Generation Project

## High-Level Description
This project is centered around developing a Verilog-based system to generate and display images on a VGA monitor. It primarily utilizes two modules: `image_generator.v` and `VGA_gen.v`. The `image_generator.v` module creates a dynamic radial gradient image, where users can modify the RGB signals using input switches, offering an interactive experience in image generation. The `VGA_gen.v` module, on the other hand, is dedicated to the generation and synchronization of VGA signals for the display.

## Background Information
VGA (Video Graphics Array) is a widely recognized standard for image display on computer monitors. In this project, we dive into the application of Verilog, a hardware description language, to intricately control VGA signals. This venture is a deep dive into digital design and computer engineering, showcasing the manipulation of image display through hardware programming.

## Design Description
- **image_generator.v**: This module is the heart of the image generation process. It produces a radial gradient whose colors can be dynamically altered via input switches. The module outputs VGA-compatible RGB signals, orchestrating the core logic behind the image generation.
- **VGA_gen.v**: Inspired by a design from Peter Jamieson, this module expertly generates the necessary VGA signals. It is responsible for the precise synchronization required for seamless image display on VGA monitors.

## Results and Metrics
- The system successfully demonstrates the capability to generate a customizable radial gradient and display it on a VGA monitor. The interactive nature of using switches to alter the image in real-time exemplifies the project's success in combining hardware programming with visual outputs.

## Conclusion
This project is a testament to the practical applications of Verilog in the realm of digital image processing and VGA signal manipulation. It not only provides insights into the fundamental aspects of VGA technology but also opens avenues for creative exploration in hardware-based image generation.

## Media and Demonstrations
- [Include links or embed images/videos demonstrating the system in action]
- [Add a link to a YouTube demo showcasing the project's functionality]

## Citations and Acknowledgements
- The VGA signal generation module is adapted from a design by Peter Jamieson, offering a robust foundation for this project.

## Contributors
- Carter Smith
