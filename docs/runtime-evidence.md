## Before the fix: Docker validation

The original image contained a hardcoded `API_KEY` and used the incorrect variable name `LOGLEVEL`. Running the application without supplying `DATABASE_URL` caused it to fail.

**Command:**
```powershell
docker logs app-before
```

**Actual output:**
```text
Error: DATABASE_URL is undefined
```

The original Docker build also produced this warning:

```text
SecretsUsedInArgOrEnv: Do not use ARG or ENV instructions for sensitive data (ENV "API_KEY")
```

## After the fix: Docker validation

The corrected Dockerfile no longer hardcodes application environment variables. Configuration is supplied when the container starts.

**Command:**
```powershell
docker logs app-fixed
```

**Actual output:**
```text
> env-config-lab@1.0.0 start
> node server.js

Starting app with log level: info
Server is running on port 3000
```

**Command:**
```powershell
docker exec app-fixed printenv
```

**Relevant output:**
```text
DATABASE_URL=postgres://localhost:5432/envlab
LOG_LEVEL=info
API_KEY=local-demo-key
```

The API key above is a local demonstration value, not a production secret.

**Environment-variable presence check:**
```text
DATABASE_URL: SET
LOG_LEVEL: SET
API_KEY: SET
```

**Health check:**
```text
Invoke-RestMethod http://localhost:8080/health

status
------
ok
```

## Cloud Run configuration

- Supply `LOG_LEVEL` using Cloud Run environment-variable configuration.
- Supply `API_KEY` using Secret Manager and Cloud Run secret configuration.
- Do not commit real credentials or bake secrets into the Docker image.
- No Cloud Run deployment was performed for this validation.

## Evidence limitations

The output above records the results of the local Docker validation. Screenshots and a video walkthrough must be attached or linked separately so the reviewer can inspect the evidence directly.


### Before-fix validation — actual Docker output

**Command:**
```powershell
docker exec app-before-env printenv
```

**Output:**
```text
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
HOSTNAME=e52aed852812
NODE_VERSION=18.20.8
YARN_VERSION=1.22.22
API_KEY=super-secret-key
LOGLEVEL=info
HOME=/root
```

This confirms that the original image contained a hardcoded `API_KEY` and used `LOGLEVEL` instead of the application's expected `LOG_LEVEL`.

**Command:**
```powershell
docker logs app-before-logs
```

**Output:**
```text
> env-config-lab@1.0.0 start
> node server.js

Error: DATABASE_URL is undefined
```

The application exits because `DATABASE_URL` was not provided at runtime. The original image also exposes a hardcoded secret, which must be removed from the Dockerfile.

### After-fix validation — actual Docker output

**Start the container with runtime configuration:**
```powershell
$env:API_KEY = "local-demo-key"
docker run --name app-fixed --env-file .env -e "API_KEY=$env:API_KEY" -p 8080:3000 envlab
```

**Command:**
```powershell
docker logs app-fixed
```

**Output:**
```text
> env-config-lab@1.0.0 start
> node server.js

Starting app with log level: info
Server is running on port 3000
```

**Command:**
```powershell
docker exec app-fixed printenv
```

**Relevant actual output:**
```text
DATABASE_URL=postgres://localhost:5432/envlab
LOG_LEVEL=info
API_KEY=local-demo-key
```

**Health-check command:**
```powershell
Invoke-RestMethod http://localhost:8080/health
```

**Output:**
```text
status
------
ok
```

**Conclusion:** The application starts successfully when its required configuration is injected at runtime. The corrected Dockerfile no longer hardcodes the API key or the log level.
