# Enterprise Bot — DevOps Take-Home Assessment

## Overview

This project contains a Python HTTP service, a multi-stage Dockerfile, a Helm chart, a one-command Kubernetes setup script, and a troubleshooting lab.

## Prerequisites

- Docker Desktop or Docker Engine
- kind
- kubectl
- Helm
- Bash

## Running the Application

From the repository root:

```bash
chmod +x setup.sh
./setup.sh
```

The script is intended to create or reuse the `demo` kind cluster, build and load the application image, install ingress-nginx, and deploy the Helm release into the `demo` namespace.

## Verification

Check the deployment:

```bash
kubectl get pods -n demo
kubectl get svc,ingress -n demo
kubectl rollout status deployment/demo -n demo
```

Test the service through port-forwarding:

```bash
kubectl port-forward -n demo svc/demo 8080:8080
```

In another terminal:

```bash
curl http://localhost:8080/
curl http://localhost:8080/healthz
```

Test the Ingress after confirming its local port mapping:

```bash
curl -H "Host: demo.local" http://localhost/
```

The Ingress command assumes the controller is reachable on local port 80.

## Resource Requests and Limits

Each application replica requests 100m CPU and 64Mi memory, with limits of 250m CPU and 128Mi memory.

These are initial values for a lightweight Python HTTP service. Requests reserve a modest amount of capacity for scheduling, while limits prevent excessive resource consumption. The values should be validated using actual usage metrics.

## Deliberately Skipped or Incomplete

- Load testing has not been performed; resource settings may need adjustment under sustained traffic.
- High availability across separate physical nodes has not been validated because kind runs locally.
- The Docker image, Helm chart, and setup script still require end-to-end testing.

These gaps could affect performance, availability, or deployment reliability.

## Production Improvements

For production, I would add automated CI/CD checks, image vulnerability scanning, TLS configuration, structured logging, centralized monitoring, alerting, and more comprehensive testing.

I would also use immutable image digests, appropriate security contexts, and resource settings based on observed metrics.

## Debugging Lab

The debugging findings and actual diagnostic evidence will be documented in `lab/FINDINGS.md`.

The recorded troubleshooting session will be included as `lab/part4-session.log`.

## How I Used AI

I used ChatGPT to help draft the Python service, Dockerfile, Helm templates, setup script, documentation, and Kubernetes migration answer. I also used it for installation guidance and to identify the case-sensitive Helm chart filename issue.

I tested the Python endpoints locally and corrected the Helm chart filename. The container build, Kubernetes deployment, and debugging lab still require validation.

I will document any further corrections and testing results before submission.