
# Cloud Run Mapping

## Configuration Variables

- `DATABASE_URL`: Set using `--set-env-vars` for non-sensitive local/demo configuration. If it contains database credentials, store it in Secret Manager instead.
- `LOG_LEVEL`: Set using `--set-env-vars`, for example `LOG_LEVEL=info`.

## Secrets

- `API_KEY`: Store in Google Secret Manager and expose at runtime using `--set-secrets`.
- Database credentials, if present in `DATABASE_URL`: Store securely in Secret Manager rather than writing credentials into the Dockerfile or a committed file.

## Example Commands

Set non-secret configuration:

```bash
gcloud run services update SERVICE_NAME \
  --region REGION \
  --set-env-vars LOG_LEVEL=info
```

Inject an API key from Secret Manager:

```bash
gcloud run services update SERVICE_NAME \
  --region REGION \
  --set-secrets API_KEY=API_KEY:latest
```

Replace `SERVICE_NAME` and `REGION` with the appropriate values. The secret must exist in Secret Manager, and the Cloud Run service identity must have permission to access it.

## Validation

- `.env` is excluded from Git.
- `.env.example` contains placeholders only.
- No secrets are hardcoded in the Dockerfile.
- Runtime configuration is verified using Docker logs and environment-variable presence checks.

Documentation only. No Cloud Run deployment was performed.
