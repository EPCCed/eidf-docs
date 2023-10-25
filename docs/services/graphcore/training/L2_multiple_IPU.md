# Distributed training on multiple IPUs

Multiple IPUs (in powers of 2) can be requested to perform distributed training.

In this case, the `IPUJob` also spawns a `launcher` , which is a Pod that runs an `mpirun` or `poprun` command. These commands start workloads inside `worker` Pods.

As an example, we will run the same MNIST training tutorial from the previous lesson, but use two IPUs.
