# GPU Service Policies

## Namespaces

Each project will be given a namespace which will have an applied quota.

Default Quota:

- CPU: 100 Cores
- Memory: 1TiB
- GPU: 12

## Kubeconfig

Each project will be assigned a kubeconfig file for access to the service which will allow operation in the assigned namespace and access to exposed service operators, for example the GPU and CephRBD operators.

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

## Kubernetes Active Deadline Seconds

All Kubernetes User Pods submitted to the service will have an Active Deadline Seconds (ADS) applied via `spec.spec.activeDeadlineSeconds` automatically. The default ADS for pods using the service will be 5 days (432000 seconds). A pod will be terminated 5 days after execution has begun. This will reduce the number of unused pods remaining on the service.

!!! important
    This policy is automated and does not require users to change their job or pod specifications.
    
!!! important
    The preference would be, that you lower this number unless you are confident you need the workload to run for the maximum duration. Any configuration errors in your code can lead to the container running for the whole duration, but not yielding a result and taking cluster resources away from other users.

## Kueue

All jobs will be managed through the Kueue scheduling system. All pods will be required to be owned by a Kubernetes workload.

Each project will have a local user queue in their namespace. This will provide access to their cluster queue. To enable the use of the queue in your job definitions, the following will need to be added to the job specification file as part of the metadata:

```yaml
   labels:
      kueue.x-k8s.io/queue-name:  <project namespace>-user-queue
```

Workloads without this queue name tag will be rejected.