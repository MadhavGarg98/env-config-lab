# Cloud Run Mapping

## Configuration Variables

- `DATABASE_URL`: Inject non-sensitive demo values at runtime. Use Secret Manager for database credentials.
- `LOG_LEVEL`: Inject at runtime, for example `LOG_LEVEL=info`.

## Secrets

- `API_KEY`: Store in Google Secret Manager and inject at runtime.
- Never hardcode secrets in the Dockerfile or commit real secrets.

## Example Commands

Set non-sensitive configuration:

```bash
gcloud run services update SERVICE_NAME --region REGION --set-env-vars LOG_LEVEL=info
```

Inject an API key from Secret Manager:

```bash
gcloud run services update SERVICE_NAME --region REGION --set-secrets API_KEY=API_KEY:latest
```

Replace `SERVICE_NAME` and `REGION` with your actual values. Ensure the secret exists and the Cloud Run service identity has permission to access it.

## Validation

- `.env` is ignored by Git.
- `.env.example` contains placeholders only.
- No secrets are hardcoded in the Dockerfile.
- Docker logs and environment-variable checks verify runtime configuration.

Documentation only. No Cloud Run deployment was performed.