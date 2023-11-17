# Graphcore FAQ

## Graphcore Questions

### How do I delete a running/terminated pod?

`IPUJobs` manages the launcher and worker `pods`, therefore the pods will be deleted when the `IPUJob` is deleted, using `kubectl delete ipujobs <IPUJob-name>`. If only the `pod` is deleted via `kubectl delete pod`, the `IPUJob` may respawn the `pod`.

To see running or terminated `IPUJobs`, run `kubectl get ipujobs`.

### My IPUJob died with a message: `'poptorch_cpp_error': Failed to acquire X IPU(s)`. Why?

This error may appear when the IPUJob name is too long.

We have identified that for IPUJobs with `metadata:name` length over 36 characters, this error may appear. A solution is to reduce the name to under 36 characters.
