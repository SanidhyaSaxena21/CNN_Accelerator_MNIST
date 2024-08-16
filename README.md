# CNN_Accelerator_MNIST
Hardware CNN Accelerator for Digit recognition on FPGA

This repository contains the implementation of a Convolutional Neural Network (CNN) accelerator on an FPGA. The project is designed to optimize the execution of CNNs for tasks like image classification and object detection by leveraging the parallel processing capabilities of FPGAs.

## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Project Structure](#project-structure)
- [Design Overview](#design-overview)
  - [Architecture](#architecture)
  - [Data Flow](#data-flow)
  - [Optimization Techniques](#optimization-techniques)


## Introduction

The CNN Accelerator on FPGA project aims to accelerate the execution of CNN models by offloading the computationally intensive tasks to an FPGA. By using custom hardware design, this accelerator provides high throughput and low latency, making it suitable for real-time applications.

## Features

- **High Performance:** Accelerates CNN operations like convolution, pooling, and activation functions.
- **Configurable Architecture:** Supports various CNN models with different layer configurations.
- **Parallel Processing:** Leverages the parallel nature of FPGAs to handle multiple data points simultaneously.
- **Low Latency:** Optimized for minimal data transfer and processing delays.
- **Resource Efficiency:** Designed to make efficient use of FPGA resources, such as DSP slices and BRAM.

## Project Structure

```plaintext
├── src/                # Source code for the FPGA design (HDL files)
├── ip/                 # Custom IP cores used in the project
├── sim/                # Simulation files and testbenches
├── scripts/            # Scripts for synthesis, implementation, and bitstream generation
├── docs/               # Documentation and design specifications
└── README.md           # This file
```

## design-overview
### Architecture
The accelerator consists of several key modules:

1) Convolution Engine: Handles convolution operations with multiple parallel processing elements (PEs).
2) Pooling Unit: Performs max pooling or average pooling operations.
3) Activation Module: Implements ReLU, Sigmoid, or other activation functions.

### Data flow
Data flows through the accelerator in a pipelined manner, with each module processing data as it becomes available from the previous stage.

### Optimization techniques
1) **Loop Unrolling**: Increases parallelism by unrolling loops in the HDL code.
2) **Pipelining**: Reduces latency by overlapping the execution of different stages.


