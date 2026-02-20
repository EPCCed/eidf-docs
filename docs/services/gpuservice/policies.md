# GPU Service Policies

## Namespaces

Each project will be given a namespace which will have an applied quota.

Default Quota:

- CPU: 100 Cores
- Memory: 1TiB
- GPU: 12

## Kubeconfig

Each project will be assigned a kubeconfig file for access to the service which will allow operation in the assigned namespace and access to exposed service operators, for example the GPU, CephRBD, and CephFS operators.

## Kubernetes Job Names

All Kubernetes Jobs submitted will need to use the `metadata.generateName` field instead of the `metadata.name` field. This is to ensure jobs can be identified for purporses of  maintenance and troubleshooting.

Submitting jobs with `name` only would allow several jobs to have the same name, potentially blocking you from submitting the job until the previous one was deleted. Support would have difficulties troubleshooting as the name remains the same, but execution results can be different each time.

!!! important
    This policy is automated, but users will need to change their job template to use the new field for the submission to work.

## Kubernetes Job Time to Live

All Kubernetes Jobs submitted to the service will have a Time to Live (TTL) applied via `spec.ttlSecondsAfterFinished` automatically. The default TTL for jobs using the service will be 1 week (604800 seconds). A completed job (in success or error state) will be deleted from the service once one week has elapsed after execution has completed. This will reduce excessive object accumulation on the service.

!!! important
    This policy is automated and does not require users to change their job specifications.

!!! important
    We recommend setting a lower value, unless you absolutely need the job to remain for debugging. Completed jobs serve no other purpose and can potentially make identifying your workloads more difficult.

## Kueue

All jobs will be managed through the Kueue scheduling system. All pods will be required to be owned by a Kubernetes workload.

Each project will have a local user queue in their namespace. This will provide access to their cluster queue. To enable the use of the queue in your job definitions, the following will need to be added to the job specification file as part of the metadata:

```yaml
   labels:
      kueue.x-k8s.io/queue-name:  <project namespace>-user-queue
```

Workloads without this queue name tag will be rejected.

## Maximum Execution Time (Kueue Workloads))

All Workloads submitted to the service will have a maximum execution time seconds (METS) applied via the label `kueue.x-k8s.io/max-exec-time-seconds` automatically. The default METS for workloads using the service will be 35 days (3024000 seconds). A workload will be terminated at this point. Upon reaching the maximum, all pods for the workload will be deleted.

The maximum runtime is based on what was the default possible under the previous combination Active Deadline Seconds and Job Backoff Limit. This value may be revised.

!!! important
    This policy is automated and does not require users to change their job or pod specifications.

!!! important
    The preference would be, that you lower this number unless you are confident you need the workload to run for the maximum duration. If you do not have a good exit condition or internal code errors will not terminate the workload, a workload could end up running for the entire maximum time, blocking resources and incurring unneeded costs.

To apply a shorter maximum execution time, to ensure you do not consume more resources than was intended, you can apply the label on your workload:

```yaml
   labels:
      kueue.x-k8s.io/queue-name:  <project namespace>-user-queue
      kueue.x-k8s.io/max-exec-time-seconds: 'number of seconds'
```

If your value is at or below the default value, the system will not change it. If it is larger, it will reset it to the default.

If you want to continue using activeDeadlineSeconds, you can but the maximum-exec-time-seconds value will take priority if it is smaller than activeDeadlineSeconds.

## Wait For Pods Ready (Kueue and Pending Pods)

To prevent "Pending" pods from indefinitely stalling project resources, the Wait for Pods Ready Kueue feature is enabled.

Pods can get stuck in a Pending state due to:

- Resource Fragmentation: A project and the service has enough total capacity, but not in the correct node configuration.
- Storage Issues: Persistent Volume Claims (PVCs) failing to mount or not existing.

How it Works

- Timeout: If a pod remains in a Pending state for 20 minutes, the queue manager will terminate it.
- Requeuing: The job will be automatically re-queued. The wait time between retries will incrementally increase up to a maximum of 1 hour.
- Persistence: Jobs will continue to retry indefinitely.

Singleton Pods

Though it is recommended using Jobs or other controllers as a default workload, singleton pods are supported. However, these are handled differently and because singletons lack a parent controller, they will be deleted rather than re-queued once the timeout is reached.

You can inspect why a singleton was deleted for up to 1 hour after the event using:

```bash
kubectl get events --field-selector involvedObject.kind=Pod,involvedObject.name=<pod-name> -n <namespace>
```

To check if your job was affected by this timeout, run:

```bash
kubectl describe job <job-name>
```

If you see an event labeled "Exceeded the PodsReady timeout," your job has been triggered for requeuing.

## Deprecated or Replaced Policies

### Kubernetes Active Deadline Seconds (Deprecated in favour of Maximum Execution Time)
