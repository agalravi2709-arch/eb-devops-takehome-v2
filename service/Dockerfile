
# Stage 1: Build
FROM python:3.12-slim AS builder

WORKDIR /app
COPY app.py /app/app.py

# Stage 2: Runtime
FROM python:3.12-slim

WORKDIR /app

RUN groupadd --system appgroup && \
    useradd --system --gid appgroup --no-create-home appuser

COPY --from=builder --chown=appuser:appgroup /app/app.py /app/app.py

USER appuser

EXPOSE 8080

CMD ["python", "app.py"]
