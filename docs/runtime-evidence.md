# Runtime Configuration Evidence

## 1. Problem Diagnosis

The original Dockerfile hardcoded `API_KEY` using an `ENV` instruction and misspelled `LOG_LEVEL` as `LOGLEVEL`.

Running the original image without `DATABASE_URL` produced:

```text
Error: DATABASE_URL is undefined
```

The Docker build also warned about the hardcoded API key.

## 2. Corrected Configuration

The corrected Dockerfile does not bake `API_KEY` or `LOG_LEVEL` into the image. Configuration is supplied when the container starts.

## 3. Local Runtime Instructions

Create your local environment file from the example:

```powershell
Copy-Item .env.example .env
```

Edit `.env` to use local demo values for `DATABASE_URL` and `LOG_LEVEL`. Keep `.env` private and ignored by Git.

Build the image:

```powershell
docker build -t envlab .
```

Supply the API key at runtime:

```powershell
$env:API_KEY = "local-demo-key"
```

Start the container:

```powershell
docker run --name app-fixed --env-file .env -e "API_KEY=$env:API_KEY" -p 8080:3000 envlab
```

## 4. Successful Verification

Application logs:

```text
Starting app with log level: info
Server is running on port 3000
```

Environment-variable presence check:

```text
DATABASE_URL: SET
LOG_LEVEL: SET
API_KEY: SET
```

Health endpoint:

```text
status: ok
```

The container was tested locally. No Cloud Run deployment was performed.

## 5. Cloud Run Configuration

Set non-sensitive values at runtime:

```bash
gcloud run services update SERVICE_NAME --region REGION --set-env-vars LOG_LEVEL=info
```

Inject an API key stored in Google Secret Manager:

```bash
gcloud run services update SERVICE_NAME --region REGION --set-secrets API_KEY=API_KEY:latest
```

Replace the example service and region with actual values. Store database credentials in Secret Manager if they are included in `DATABASE_URL`.

## 6. Evidence and Demonstration

Attach the actual before-fix and after-fix screenshots, include the relevant Git commit history, and add the Google Drive link to the 3–6 minute demonstration video once uploaded and verified.
