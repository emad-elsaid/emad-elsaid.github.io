> "Extended Neural GPU" (eNGPU) is a neural network architecture
> 
> The eNGPU architecture is designed to efficiently compute parallel tensor contractions, which are a common operation in many neural network models. It uses a set of simple computational units called "cells" that are connected in a 1D or 2D grid, with each cell processing a subset of the input and output tensors. The cells perform a series of matrix multiplications and activations to compute the output tensor.
> 
> The eNGPU architecture is inspired by the parallelism of graphics processing units (GPUs), and is designed to exploit the full computational power of modern hardware. The authors demonstrate that eNGPU can achieve faster training times than traditional neural network architectures, and can scale efficiently to large models and datasets.
> 
> While eNGPU was primarily developed for efficient parallel computation of tensor contractions, it has also been applied to other tasks such as machine translation and speech recognition, and has shown promising results in these domains as well.