# Graphcore FAQ

## Graphcore Questions

### How do I delete a running/terminated pod?

`IPUJobs` manages the launcher and worker `pods`, therefore the pods will be deleted when the `IPUJob` is deleted, using `kubectl delete ipujobs <IPUJob-name>`. If only the `pod` is deleted via `kubectl delete pod`, the `IPUJob` may respawn the `pod`.

To see running or terminated `IPUJobs`, run `kubectl get ipujobs`.
