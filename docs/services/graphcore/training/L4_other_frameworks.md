# Other Frameworks

In this tutorial we'll briefly cover running tensorflow and PopART for Machine Learning, and writing IPU programs directly via the PopLibs library in C++. Extra links and resources will be provided for more in-depth information.

## Terminology

Within Graphcore, `Poplar` refers to the tools (e.g. Poplar `Graph Engine` or Poplar `Graph Compiler`) and libraries (`PopLibs`)  for programming on IPUs.

The `Poplar SDK` is a package of software development tools, including

- TensorFlow 1 and 2 for the IPU
- PopTorch (Wrapper around PyTorch for running on IPU)
- PopART (Poplar Advanced Run-Time, provides support for importing, creating, and running ONNX graphs on the IPU)
- Poplar and PopLibs
- PopDist (Poplar Distributed Configuration Library) and PopRun (Command line utility to launch distributed applications)
- Device drivers and command line tools for managing the IPU

For more details see [here](https://docs.graphcore.ai/projects/graphcore-glossary/en/latest/index.html#term-Poplar).

## Other ML frameworks: Tensorflow and PopART

Besides being able to run PyTorch code, as demonstrated in the previous lessons, the Poplar SDK also supports running ML learning applications with tensorflow or PopART.

### Tensorflow

The Poplar SDK includes implementation of TensorFlow and Keras for the IPU.

For more information, refer to [Targeting the IPU from TensorFlow 2](https://docs.graphcore.ai/projects/tensorflow-user-guide/en/latest/index.html) and [TensorFlow 2 Quick Start](https://docs.graphcore.ai/projects/tensorflow2-quick-start/en/latest/index.html).

These are available from the image `graphcore/tensorflow:2`.

For a quick example, we will run an example script from <https://github.com/graphcore/examples/tree/master/tutorials/simple_applications/tensorflow2/mnist>. To get started, save the following yaml and run `kubectl create -f <yaml-file>` to create the IPUJob:

``` yaml
apiVersion: graphcore.ai/v1alpha1
kind: IPUJob
metadata:
  generateName: tensorflow-example-
spec:
  jobInstances: 1
  ipusPerJobInstance: "1"
  workers:
    template:
      spec:
        containers:
        - name: tensorflow-example
          image: graphcore/tensorflow:2
          command: [/bin/bash, -c, --]
          args:
            - |
              apt update;
              apt upgrade -y;
              apt install git -y;
              cd;
              mkdir build;
              cd build;
              git clone https://github.com/graphcore/examples.git;
              cd examples/tutorials/simple_applications/tensorflow2/mnist;
              python -m pip install -r requirements.txt;
              python mnist_code_only.py --epochs 1
          resources:
            limits:
              cpu: 32
              memory: 200Gi
          securityContext:
            capabilities:
              add:
              - IPC_LOCK
          volumeMounts:
          - mountPath: /dev/shm
            name: devshm
        restartPolicy: Never
        hostIPC: true
        volumes:
        - emptyDir:
            medium: Memory
            sizeLimit: 10Gi
          name: devshm
```

Running `kubectl logs <pod>` should show the results similar to the following

``` bash
...
2023-10-25 13:21:40.263823: I tensorflow/compiler/plugin/poplar/driver/poplar_platform.cc:43] Poplar version: 3.2.0 (1513789a51) Poplar package: b82480c629
2023-10-25 13:21:42.203515: I tensorflow/compiler/plugin/poplar/driver/poplar_executor.cc:1619] TensorFlow device /device:IPU:0 attached to 1 IPU with Poplar device ID: 0
Downloading data from https://storage.googleapis.com/tensorflow/tf-keras-datasets/mnist.npz
11493376/11490434 [==============================] - 0s 0us/step
11501568/11490434 [==============================] - 0s 0us/step
2023-10-25 13:21:43.789573: I tensorflow/compiler/mlir/mlir_graph_optimization_pass.cc:185] None of the MLIR Optimization Passes are enabled (registered 2)
2023-10-25 13:21:44.164207: I tensorflow/compiler/mlir/tensorflow/utils/dump_mlir_util.cc:210] disabling MLIR crash reproducer, set env var `MLIR_CRASH_REPRODUCER_DIRECTORY` to enable.
2023-10-25 13:21:57.935339: I tensorflow/compiler/jit/xla_compilation_cache.cc:376] Compiled cluster using XLA!  This line is logged at most once for the lifetime of the process.
Epoch 1/4
2000/2000 [==============================] - 17s 8ms/step - loss: 0.6188
Epoch 2/4
2000/2000 [==============================] - 1s 427us/step - loss: 0.3330
Epoch 3/4
2000/2000 [==============================] - 1s 371us/step - loss: 0.2857
Epoch 4/4
2000/2000 [==============================] - 1s 439us/step - loss: 0.2568
```

### PopART

The Poplar Advanced Run Time (PopART) enables importing and constructing ONNX graphs, and running graphs in inference, evaluation or training modes. PopART provides both a C++ and Python API.

For more information, see the [PopART User Guide](https://docs.graphcore.ai/projects/popart-user-guide/en/latest/intro.html)

PopART is available from the image `graphcore/popart`.

For a quick example, we will run an example script from <https://github.com/graphcore/tutorials/tree/sdk-release-3.1/simple_applications/popart/mnist>. To get started, save the following yaml and run `kubectl create -f <yaml-file>` to create the IPUJob:

``` yaml
apiVersion: graphcore.ai/v1alpha1
kind: IPUJob
metadata:
  generateName: popart-example-
spec:
  jobInstances: 1
  ipusPerJobInstance: "1"
  workers:
    template:
      spec:
        containers:
        - name: popart-example
          image: graphcore/popart:3.3.0
          command: [/bin/bash, -c, --]
          args:
            - |
              cd ;
              mkdir build;
              cd build ;
              git clone https://github.com/graphcore/tutorials.git;
              cd tutorials;
              git checkout sdk-release-3.1;
              cd simple_applications/popart/mnist;
              python3 -m pip install -r requirements.txt;
              ./get_data.sh;
              python3 popart_mnist.py --epochs 1
          resources:
            limits:
              cpu: 32
              memory: 200Gi
          securityContext:
            capabilities:
              add:
              - IPC_LOCK
          volumeMounts:
          - mountPath: /dev/shm
            name: devshm
        restartPolicy: Never
        hostIPC: true
        volumes:
        - emptyDir:
            medium: Memory
            sizeLimit: 10Gi
          name: devshm
```

Running `kubectl logs <pod>` should show the results similar to the following

``` bash
...
Creating ONNX model.
Compiling the training graph.
Compiling the validation graph.
Running training loop.
Epoch #1
   Loss=16.2605
   Accuracy=88.88%
```

## Writing IPU programs directly with PopLibs

The Poplar libraries are a set of C++ libraries consisting of the Poplar graph library and the open-source PopLibs libraries.

The Poplar graph library provides direct access to the IPU by code written in C++. You can write complete programs using Poplar, or use it to write functions to be called from your application written in a higher-level framework such as TensorFlow.

The PopLibs libraries are a set of application libraries that implement operations commonly required by machine learning applications, such as linear algebra operations, element-wise tensor operations, non-linearities and reductions. These provide a fast and easy way to create programs that run efficiently using the parallelism of the IPU.

For more information, see [Poplar Quick Start](https://docs.graphcore.ai/projects/poplar-quick-start/en/latest/index.html) and [Poplar and PopLibs User Guide](https://docs.graphcore.ai/projects/poplar-user-guide/en/latest/index.html).

These are available from the image `graphcore/poplar`.

When using the PopLibs libraries, you will have to include the include files in the `include/popops` directory, e.g.

``` c++
#include <include/popops/ElementWise.hpp>
```

and to link the relevant PopLibs libraries, in addition to the Poplar library, e.g.

``` bash
g++ -std=c++11 my-program.cpp -lpoplar -lpopops
```

For a quick example, we will run an example from <https://github.com/graphcore/examples/tree/master/tutorials/simple_applications/poplar/mnist>. To get started, save the following yaml and run `kubectl create -f <yaml-file>` to create the IPUJob:

``` yaml
apiVersion: graphcore.ai/v1alpha1
kind: IPUJob
metadata:
  generateName: poplib-example-
spec:
  jobInstances: 1
  ipusPerJobInstance: "1"
  workers:
    template:
      spec:
        containers:
        - name: poplib-example
          image: graphcore/poplar:3.3.0
          command: ["bash"]
          args: ["-c", "cd && mkdir build && cd build && git clone https://github.com/graphcore/examples.git && cd examples/tutorials/simple_applications/poplar/mnist/ && ./get_data.sh && make &&  ./regression-demo -IPU 1 50"]
          resources:
            limits:
              cpu: 32
              memory: 200Gi
          securityContext:
            capabilities:
              add:
              - IPC_LOCK
          volumeMounts:
          - mountPath: /dev/shm
            name: devshm
        restartPolicy: Never
        hostIPC: true
        volumes:
        - emptyDir:
            medium: Memory
            sizeLimit: 10Gi
          name: devshm
```

Running `kubectl logs <pod>` should show the results similar to the following

``` bash
...
Using the IPU
Trying to attach to IPU
Attached to IPU 0
Target:
  Number of IPUs:         1
  Tiles per IPU:          1,472
  Total Tiles:            1,472
  Memory Per-Tile:        624.0 kB
  Total Memory:           897.0 MB
  Clock Speed (approx):   1,850.0 MHz
  Number of Replicas:     1
  IPUs per Replica:       1
  Tiles per Replica:      1,472
  Memory per Replica:     897.0 MB

Graph:
  Number of vertices:            5,466
  Number of edges:              16,256
  Number of variables:          41,059
  Number of compute sets:           20

...

Epoch 1 (99%), accuracy 76%
```
