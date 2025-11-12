# GPU Service Policies

## Namespaces

Each project will be given a namespace which will have an applied quota.

## Kubeconfig

Each project will be assigned a kubeconfig file for access to the service which will allow operation in the assigned namespace and access to exposed service operators, for example the GPU operator.

## Kubernetes Job Names

All Kubernetes Jobs submitted will need to use the `metadata.generateName` field instead of the `metadata.name` field. This is to ensure jobs can be identified for purporses of  maintenance and troubleshooting.

Submitting jobs with `name` only would allow several jobs to have the same name, potentially blocking you from submitting the job until the previous one was deleted. Support would have difficulties troubleshooting as the name remains the same, but execution results can be different each time.

!!! important
    This policy is automated, but users will need to change their job template to use the new field for the submission to work.

## Kubernetes Job Time to Live

All completed Kubernetes jobs will have a Time to Live (TTL) applied via `spec.ttlSecondsAfterFinished` automatically. A completed job (in success or error state) will be deleted from the service once this period has elapsed since execution has completed. This will reduce excessive object accumulation on the service. The default TTL for jobs using the service is one week (604800 seconds). 

!!! important
    This policy is automated and does not require users to change their job specifications.

!!! important
    We recommend setting a lower value, unless you absolutely need the job to remain for debugging. Completed jobs serve no other purpose and can potentially make identifying your workloads more difficult.

## Kubernetes Active Deadline Seconds

All Kubernetes user pods submitted to the service will have an Active Deadline Seconds (ADS) applied via `spec.spec.activeDeadlineSeconds` automatically. A pod will be terminated once this period has elapsed after execution has begun. This will reduce the number of unused pods remaining on the service. The default ADS for pods using the service is five days (432000 seconds). 

!!! important
    This policy is automated and does not require users to change their job or pod specifications.

!!! important
    The preference would be that you lower this number unless you are confident you need the workload to run for the maximum duration. Any configuration or other errors in your code can lead to the container running for the whole duration, but not yielding a result and unnecessarily taking cluster resources away from other users.

## Kueue

All jobs will be managed through the Kueue scheduling system. All pods will be required to be owned by a Kubernetes workload.

Each project will have a local user queue in their namespace. This will provide access to their cluster queue. To enable the use of the queue in your job definitions, the following will need to be added to the job specification file as part of the metadata:

```yaml
   labels:
      kueue.x-k8s.io/queue-name:  <project namespace>-user-queue
```

Workloads without this queue name tag will be rejected.

## PVC Creation

The SHS GPU Cluster users are **not permitted to create their own PersistentVolumeClaims (PVCs)**. PVC creation attempts from user workloads will be denied automatically. All PVCs are provisioned by system administrators on receipt of a ticket from a Research Coordinator asking that access to the SHS GPU Cluster be enabled for a user account. The required information is the project ID and the user account.

## Interacting with Other Users' Containers

To protect workloads and data privacy, users are **not permitted to `exec` into, modify, or delete** containers that belong to other users.

- **Exec Blocking:** The system enforces a policy that denies `kubectl exec` commands if the requesting username does not match the `shsuser` label on the target Pod.
- **Deletion Blocking:** Where possible, the system prevents deletion of other users’ Pods.
- **Code of Conduct:** Even in cases where Kubernetes allows destructive actions (e.g., deleting a Pod in your namespace), users must **never** interfere with another user’s running workloads. This includes not deleting Pods for resource reclamation unless explicitly agreed with the owner or instructed by administrators.

**Expected Behaviour:**

- Only interact with workloads you own.
- Use delete commands **only** on your own resources.
- Report issues to the support team rather than trying to “fix” other users’ workloads yourself.
