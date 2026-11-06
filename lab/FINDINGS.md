# DevOps Lab Findings

## Fixes Implemented

1. Migration Job: Changed restartPolicy from Always to Never.
2. Container security: Added numeric runAsUser 65532 for non-root execution.
3. Worker: Added an emptyDir volume for the writable cache directory.
4. Application ports: Set PORT=8080 to match Kubernetes services and probes.
5. Gateway: Corrected BACKEND_URL to http://backend.debug-lab.svc:8080.
6. Metrics: Reduced CPU limit to comply with namespace LimitRange.
7. Reporter RBAC: Corrected RoleBinding to reference the reporter ServiceAccount.

## Verification

The last confirmed verification result was 8/11 checks passing.

Backend, gateway, worker and metrics were ready, and the migration Job completed. The gateway /status endpoint independently returned backend=ok.

## Remaining Issues

Reporter readiness remains 0/1. The /report endpoint returns HTTP 503 with:
parse pod list: unexpected end of JSON input

Reporter ServiceAccount authorization was confirmed, and a diagnostic pod successfully retrieved Kubernetes PodList JSON using that ServiceAccount.

The gateway verification check also failed despite successful independent in-cluster and port-forward tests.

## AI Assistance Disclosure

AI assistance was used for troubleshooting suggestions, Kubernetes configuration guidance, and documentation. Commands and observed results were checked against the local environment.
