# Profiling with PopVision

Graphcore provides various tools for profiling, debugging, and instrumenting programs run on IPUs. In this tutorial we will briefly demonstrate an example using the PopVision Graph Analyser. For more information, see [Profiling and Debugging](https://docs.graphcore.ai/en/latest/child-pages/profiling-debugging.html#profiling-debugging) and [PopVision Graph Analyser User Guide](https://docs.graphcore.ai/en/latest/child-pages/profiling-debugging.html#profiling-debugging).

We will reuse the same PyTorch MNIST example from [lesson 1](./L1_getting_started.md) (from <https://github.com/graphcore/examples/tree/master/tutorials/simple_applications/pytorch/mnist>).

To enable profiling and [create IPU reports](https://docs.graphcore.ai/projects/graph-analyser-userguide/en/latest/capturing-ipu-reports.html), we need to add the following line to the training script `mnist_poptorch_code_only.py` :

``` python
training_opts = training_opts.enableProfiling()
```

(for details the API, see [API reference](https://docs.graphcore.ai/projects/poptorch-user-guide/en/latest/reference.html#poptorch.Options))

Save and run `kubectl create -f <yaml-file>` on the following:

``` yaml
apiVersion: graphcore.ai/v1alpha1
kind: IPUJob
metadata:
  name: mnist-training-profiling
spec:
  # jobInstances defines the number of job instances.
  # More than 1 job instance is usually useful for inference jobs only.
  jobInstances: 1
  # ipusPerJobInstance refers to the number of IPUs required per job instance.
  # A separate IPU partition of this size will be created by the IPU Operator
  # for each job instance.
  ipusPerJobInstance: "1"
  workers:
    template:
      spec:
        containers:
        - name: mnist-training-profiling
          image: graphcore/pytorch:3.3.0
          command: ["bash"]
          args: ["-c", "cd && mkdir build && cd build && git clone https://github.com/graphcore/examples.git && cd examples/tutorials/simple_applications/pytorch/mnist && python -m pip install -r requirements.txt &&  sed -i '131i training_opts = training_opts.enableProfiling()' mnist_poptorch_code_only.py && python mnist_poptorch_code_only.py --epochs 1 && echo 'RUNNING ls ./training' && ls training"]
        restartPolicy: Never
```

After completion, using `kubectl logs <pod-name>`, we can see the following result

``` bash
...
Accuracy on test set: 96.69%
RUNNING ls ./training
archive.a
profile.pop
```

We can see that the training has created two Poplar report files: `archive.a` which is an archive of the ELF executable files, one for each tile; and `profile.pop`, the poplar profile, which contains compile-time and execution information about the Poplar graph.

## Downloading the profile reports

To download the traing profiles to your local environment, you can use `kubectl cp`. For example, run

``` bash
kubectl cp <pod-name>:/root/build/examples/tutorials/simple_applications/pytorch/mnist/training .
```

Once you have downloaded the profile report files, you can view the contents locally using the PopVision Graph Analyser tool, which is available for download here <https://www.graphcore.ai/developer/popvision-tools>.

From the Graph Analyser, you can analyse information including memory usage, execution trace and more.
