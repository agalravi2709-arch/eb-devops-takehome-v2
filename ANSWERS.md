# Part 5 — Gateway API Migration

**Q1. How would you migrate approximately 40 Ingress objects from ingress-nginx to Kubernetes Gateway API without downtime?**

I would follow a phased migration approach rather than migrating all 40 Ingress objects at once.

First, I would inventory the existing Ingress resources, hostnames, TLS certificates, annotations, routing rules, authentication, and rewrite configurations. I would identify ingress-nginx-specific features that may not have direct Gateway API equivalents.

Next, I would select a supported Gateway API controller and install it alongside ingress-nginx. I would configure GatewayClass, Gateway, HTTPRoute, and TLS settings while keeping the existing traffic path unchanged.

I would start with one low-risk application and validate routing, HTTPS, authentication, health checks, and application logs. After successful testing, I would gradually shift traffic using controlled DNS or load-balancer changes, with rollback available.

I would monitor HTTP error rates, latency, traffic distribution, and backend health throughout the migration.

Potential issues include unsupported annotations, path-rewrite differences, TLS misconfiguration, header handling, session affinity, and controller-specific behavior.

If any critical issue occurs, I would direct traffic back to the existing ingress-nginx controller and investigate before continuing.

Once all applications are validated and the rollback window has passed, I would remove the old controller.

My priority would be maintaining availability, validating compatibility, and minimizing migration risk.