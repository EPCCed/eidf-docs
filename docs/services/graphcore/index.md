# Overview

EIDF hosts a Graphcore Bow Pod64 system for AI acceleration.

The specification of the Bow Pod64 is:

- 16x Bow-2000 machines
- 64x Bow IPUs (4 IPUs per Bow-2000)
- 94,208 IPU cores (1472 cores per IPU)
- 57.6GB of In-Processor-Memory (0.9GB per IPU)

For more details about the IPU architecture, see [documentation from Graphcore](https://docs.graphcore.ai/projects/ipu-programmers-guide/en/latest/about_ipu.html#).

The smallest unit of compute resource that can be requested is a single IPU.

Similarly to the EIDF GPU Service, usage of the graphcore is managed using [Kubernetes](https://kubernetes.io).

## Service Access

## Project Quotas

## Graphcore Tutorial

The following tutorial teaches users how to submit tasks to the graphcore system. This tutorial assumes basic familiary with submitting jobs via Kubernetes. For a tutorial on using Kubernetes, see the [GPU service tutorial](../gpuservice/training/L1_getting_started.md). For more in-depth lessons about developing applications for graphcore, see [the general documentation](https://docs.graphcore.ai/en/latest/) and [guide for creating IPU jobs via Kubernetes](https://docs.graphcore.ai/projects/kubernetes-user-guide/en/latest/creating-ipujob.html).

| Lesson                                                                                                   | Objective                                                                                                      |
|-----------------------------------|-------------------------------------|
| [Getting started with IPU jobs](training/L1_getting_started.md)                             | a. How to send an IPUJob.<br>b. Monitoring and Cancelling your IPUJob.  |
| [Multi-IPU Jobs](training/L2_multiple_IPU.md) | a. Using multiple IPUs for distributed training.                                         |
| [Profiling with PopVision](training/L3_profiling.md)                               | a. Enabling profiling in your code.<br>b. Downloading the profile reports. |
| [Other Frameworks](training/L4_other_frameworks.md)                               | a. Using Tensorflow and PopART.<br>b. Writing IPU programs with PopLibs (C++).|

## Further Reading and Help

- The [Graphcore documentation](https://docs.graphcore.ai/en/latest/) provides information about using the Graphcore system.

- The [Graphcore examples repository on github](https://github.com/graphcore/examples/tree/master) provides a catalogue of application examples that have been optimised to run on Graphcore IPUs for both training and inference. It also contains tutorials for using various frameworks.
