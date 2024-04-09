# Distributed training on multiple IPUs

In this tutorial, we will cover how to run larger models, including examples provided by Graphcore on <https://github.com/graphcore/examples>. These may require distributed training on multiple IPUs.

The number of IPUs requested must be in powers of two, i.e. 1, 2, 4, 8, 16, 32, or 64.

## First example

As an example, we will use 4 IPUs to perform the pre-training step of BERT, an NLP transformer model. The code is available from <https://github.com/graphcore/examples/tree/master/nlp/bert/pytorch>.

To get started, save and create an IPUJob with the following `.yaml` file:

``` yaml
apiVersion: graphcore.ai/v1alpha1
kind: IPUJob
metadata:
  generateName: bert-training-multi-ipu-
spec:
  jobInstances: 1
  ipusPerJobInstance: "4"
  workers:
    template:
      spec:
        containers:
        - name: bert-training-multi-ipu
          image: graphcore/pytorch:3.3.0
          command: [/bin/bash, -c, --]
          args:
            - |
              cd ;
              mkdir build;
              cd build ;
              git clone https://github.com/graphcore/examples.git;
              cd examples/nlp/bert/pytorch;
              apt update ;
              apt upgrade -y;
              DEBIAN_FRONTEND=noninteractive TZ='Europe/London' apt install $(< required_apt_packages.txt) -y ;
              pip3 install -r requirements.txt ;
              python3 run_pretraining.py --dataset generated --config pretrain_base_128_pod4 --training-steps 1
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

Running the above IPUJob and querying the log via `kubectl logs pod/bert-training-multi-ipu-<random string>-worker-0` should give:

``` bash
...
Data loaded in 8.559805537108332 secs
-----------------------------------------------------------
-------------------- Device Allocation --------------------
Embedding  --> IPU 0
Encoder 0  --> IPU 1
Encoder 1  --> IPU 1
Encoder 2  --> IPU 1
Encoder 3  --> IPU 1
Encoder 4  --> IPU 2
Encoder 5  --> IPU 2
Encoder 6  --> IPU 2
Encoder 7  --> IPU 2
Encoder 8  --> IPU 3
Encoder 9  --> IPU 3
Encoder 10 --> IPU 3
Encoder 11 --> IPU 3
Pooler     --> IPU 0
Classifier --> IPU 0
-----------------------------------------------------------
---------- Compilation/Loading from Cache Started ---------

...

Graph compilation: 100%|██████████| 100/100 [08:02<00:00]
Compiled/Loaded model in 500.756152929971 secs
-----------------------------------------------------------
--------------------- Training Started --------------------
Step: 0 / 0 - LR: 0.00e+00 - total loss: 10.817 - mlm_loss: 10.386 - nsp_loss: 0.432 - mlm_acc: 0.000 % - nsp_acc: 1.000 %:   0%|          | 0/1 [00:16<?, ?it/s, throughput: 4035.0 samples/sec]
-----------------------------------------------------------
-------------------- Training Metrics ---------------------
global_batch_size: 65536
device_iterations: 1
training_steps: 1
Training time: 16.245 secs
-----------------------------------------------------------
```

## Details

In this example, we have requested 4 IPUs:

``` yaml
ipusPerJobInstance: "4"
```

The python flag `--config pretrain_base_128_pod4` uses one of the preset configurations for this model with 4 IPUs. Here we also use the `--datset generated` flag to generate data rather than download the required dataset.

To provided sufficient shm for the IPU pod, it may be necessary to mount `/dev/shm` as follows:

``` yaml
          volumeMounts:
          - mountPath: /dev/shm
            name: devshm
        volumes:
        - emptyDir:
            medium: Memory
            sizeLimit: 10Gi
          name: devshm
```

It is also required to set `spec.hostIPC` to `true`:

``` yaml
  hostIPC: true
```

and add a `securityContext` to the container definition than enables the `IPC_LOCK` capability:

``` yaml
    securityContext:
      capabilities:
        add:
        - IPC_LOCK
```

Note: `IPC_LOCK` allows for the RDMA software stack to use pinned memory — which is particularly useful for PyTorch dataloaders, which can be very memory hungry. This is since all data going to the IPUs go via the network interfaces (via 100Gbps ethernet).

### Memory usage

In general, the graph compilation phase of running large models can require significant memory, and far less during the execution phase.

In the example above, it is possible to explicitly request the memory via:

``` yaml
          resources:
            limits:
              memory: "128Gi"
            requests:
              memory: "128Gi"
```

which will succeed. (The graph compilation fails if only `32Gi` is requested.)

As a general guideline, 128GB memory should be enough for the majority of tasks, and rarely exceed 200GB even for jobs with high IPU count. In the example `.yaml` script, we do not specifically request the memory.

## Scaling up IPU count and using Poprun

In the example above, python is launched directly in the pod. When scaling up the number of IPUs (e.g. above 8 IPUs), it may be possible to run into a CPU bottleneck. This may be observed when the throughput scales sub-linearly with the number of data-parallel replicas (i.e. when doubling the IPU count, the performance does not double). This can also be verified by profiling the application and observing a significant proportion of runtime spent on host CPU workload.

In this case, [Poprun](https://docs.graphcore.ai/projects/poprun-user-guide/en/latest/launching.html) can be used launch multiple instances. As an example, we will save the following .yaml configuratoin and run:

``` yaml
apiVersion: graphcore.ai/v1alpha1
kind: IPUJob
metadata:
  generateName: bert-poprun-64ipus-
spec:
  jobInstances: 1
  modelReplicasPerWorker: "16"
  ipusPerJobInstance: "64"
  workers:
    template:
      spec:
        containers:
        - name: bert-poprun-64ipus
          image: graphcore/pytorch:3.3.0
          command: [/bin/bash, -c, --]
          args:
            - |
              cd ;
              mkdir build;
              cd build ;
              git clone https://github.com/graphcore/examples.git;
              cd examples/nlp/bert/pytorch;
              apt update ;
              apt upgrade -y;
              DEBIAN_FRONTEND=noninteractive TZ='Europe/London' apt install $(< required_apt_packages.txt) -y ;
              pip3 install -r requirements.txt ;
              OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1 OMPI_ALLOW_RUN_AS_ROOT=1 \
              poprun \
              --allow-run-as-root 1 \
              --vv \
              --num-instances 1 \
              --num-replicas 16 \
               --mpi-global-args="--tag-output" \
              --ipus-per-replica 4 \
              python3 run_pretraining.py \
              --config pretrain_large_128_POD64 \
              --dataset generated --training-steps 1
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

Inspecting the log via `kubectl logs <pod-name>` should produce:

``` bash
...
 ===========================================================================================
|                                      poprun topology                                      |
|===========================================================================================|
10:10:50.154 1 POPRUN [D] Done polling, final state of p-bert-poprun-64ipus-gc-dev-0: PS_ACTIVE
10:10:50.154 1 POPRUN [D] Target options from environment: {}
| hosts     |                                   localhost                                   |
|-----------|-------------------------------------------------------------------------------|
| ILDs      |                                       0                                       |
|-----------|-------------------------------------------------------------------------------|
| instances |                                       0                                       |
|-----------|-------------------------------------------------------------------------------|
| replicas  | 0  | 1  | 2  | 3  | 4  | 5  | 6  | 7  | 8  | 9  | 10 | 11 | 12 | 13 | 14 | 15 |
 -------------------------------------------------------------------------------------------
10:10:50.154 1 POPRUN [D] Target options from V-IPU partition: {"ipuLinkDomainSize":"64","ipuLinkConfiguration":"slidingWindow","ipuLinkTopology":"torus","gatewayMode":"true","instanceSize":"64"}
10:10:50.154 1 POPRUN [D] Using target options: {"ipuLinkDomainSize":"64","ipuLinkConfiguration":"slidingWindow","ipuLinkTopology":"torus","gatewayMode":"true","instanceSize":"64"}
10:10:50.203 1 POPRUN [D] No hosts specified; ignoring host-subnet setting
10:10:50.203 1 POPRUN [D] Default network/RNIC for host communication: None
10:10:50.203 1 POPRUN [I] Running command: /opt/poplar/bin/mpirun '--tag-output' '--bind-to' 'none' '--tag-output'
'--allow-run-as-root' '-np' '1' '-x' 'POPDIST_NUM_TOTAL_REPLICAS=16' '-x' 'POPDIST_NUM_IPUS_PER_REPLICA=4' '-x'
'POPDIST_NUM_LOCAL_REPLICAS=16' '-x' 'POPDIST_UNIFORM_REPLICAS_PER_INSTANCE=1' '-x' 'POPDIST_REPLICA_INDEX_OFFSET=0' '-x'
'POPDIST_LOCAL_INSTANCE_INDEX=0' '-x' 'IPUOF_VIPU_API_HOST=10.21.21.129' '-x' 'IPUOF_VIPU_API_PORT=8090' '-x'
'IPUOF_VIPU_API_PARTITION_ID=p-bert-poprun-64ipus-gc-dev-0' '-x' 'IPUOF_VIPU_API_TIMEOUT=120' '-x' 'IPUOF_VIPU_API_GCD_ID=0'
'-x' 'IPUOF_LOG_LEVEL=WARN' '-x' 'PATH' '-x' 'LD_LIBRARY_PATH' '-x' 'PYTHONPATH' '-x' 'POPLAR_TARGET_OPTIONS=
{"ipuLinkDomainSize":"64","ipuLinkConfiguration":"slidingWindow","ipuLinkTopology":"torus","gatewayMode":"true",
"instanceSize":"64"}' 'python3' 'run_pretraining.py' '--config' 'pretrain_large_128_POD64' '--dataset' 'generated' '--training-steps' '1'
10:10:50.204 1 POPRUN [I] Waiting for mpirun (PID 4346)
[1,0]<stderr>:    Registered metric hook: total_compiling_time with object: <function get_results_for_compile_time at 0x7fe0a6e8af70>
[1,0]<stderr>:Using config: pretrain_large_128_POD64
...
Graph compilation: 100%|██████████| 100/100 [10:11<00:00][1,0]<stderr>:
[1,0]<stderr>:Compiled/Loaded model in 683.6591004971415 secs
[1,0]<stderr>:-----------------------------------------------------------
[1,0]<stderr>:--------------------- Training Started --------------------
Step: 0 / 0 - LR: 0.00e+00 - total loss: 11.260 - mlm_loss: 10.397 - nsp_loss: 0.863 - mlm_acc: 0.000 % - nsp_acc: 0.052 %:   0%|          | 0/1 [00:03<?, ?itStep: 0 / 0 - LR: 0.00e+00 - total loss: 11.260 - mlm_loss: 10.397 - nsp_loss: 0.863 - mlm_acc: 0.000 % - nsp_acc: 0.052 %:   0%|          | 0/1 [00:03<?, ?itStep: 0 / 0 - LR: 0.00e+00 - total loss: 11.260 - mlm_loss: 10.397 - nsp_loss: 0.863 - mlm_acc: 0.000 % - nsp_acc: 0.052 %:   0%|          | 0/1 [00:03<?, ?it/s, throughput: 17692.1 samples/sec][1,0]<stderr>:
[1,0]<stderr>:-----------------------------------------------------------
[1,0]<stderr>:-------------------- Training Metrics ---------------------
[1,0]<stderr>:global_batch_size: 65536
[1,0]<stderr>:device_iterations: 1
[1,0]<stderr>:training_steps: 1
[1,0]<stderr>:Training time: 3.718 secs
[1,0]<stderr>:-----------------------------------------------------------
```

## Notes on using the examples respository

Graphcore provides examples of a variety of models on Github <https://github.com/graphcore/examples>. When following the instructions, note that since we are using a container within a Kubernetes pod, there is no need to enable the Poplar/PopART SDK, set up a virtual python environment, or install the PopTorch wheel.
