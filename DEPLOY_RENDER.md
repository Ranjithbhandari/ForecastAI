# ForecastAI deployment on Render

## 1. GitHub
- Upload this folder's contents to a new GitHub repository.
- Do not upload `.env`, `node_modules`, or virtual environments.

## 2. Backend Web Service
- Render > New > Web Service > connect the repository.
- Runtime: Docker.
- Dockerfile path: `./Dockerfile`.
- Add environment variables:
  - `JWT_SECRET`: generate a long random secret (at least 32 characters).
  - `JWT_EXPIRES_IN`: `7d`
  - `FRONTEND_URL`: your deployed frontend origin, e.g. `https://forecastai-ui.onrender.com`.
  - `DATA_DIR`: `/var/data`
  - `PYTHON_BIN`: `python3`
  - `PORT`: `10000` (Render may provide this automatically; app reads `PORT`).
- For durable JSON data, attach a persistent disk mounted at `/var/data` (paid Render service required for persistent disks).
- Health check path: `/api/health`.

## 3. Frontend Static Site
- Render > New > Static Site > connect the same repository.
- Root Directory: `frontend`.
- Build Command: leave empty.
- Publish Directory: `.`.
- Deploy, then copy the frontend `https://...onrender.com` origin.

## 4. Connect frontend to backend
- Edit `frontend/config.js` and replace `https://YOUR-BACKEND-SERVICE.onrender.com` with the backend origin (no trailing slash).
- Commit and push. Render will redeploy the static site.
- Set the backend `FRONTEND_URL` to the exact frontend origin and redeploy the backend.

## 5. Admin
- Set `DEV_ADMIN_PASSWORD` as a secret environment variable before running the seed script.
- Run `npm run seed-admin` in the backend service shell once, if an admin account is not already present.

## Notes
- The app uses JSON-file storage. Use a persistent disk mounted at `/var/data` to retain accounts, datasets, and audit records across deploys/restarts. A free ephemeral instance is suitable only for a temporary demo; its local data can be lost.
- Configure SMTP/Twilio environment variables if you need email/SMS OTP delivery. Do not commit credentials.
