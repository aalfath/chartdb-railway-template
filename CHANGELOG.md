# Changelog

Each entry is one version of this Railway template. Breaking changes are listed first.
Read the entry before you apply an update in Railway.

## 1.21.0-1 (2026-11-17)

- First version: ChartDB [1.21.0](https://github.com/chartdb/chartdb/releases/tag/v1.21.0) (`ghcr.io/chartdb/chartdb:1.21.0@sha256:88664866464034f3fb3f6840f149e5beb6cc40d1b1665dbd787ab54b876d751c`).
- nginx on `PORT` (8080) with an open `/healthz` health check, gzip and long-lived caching for the hashed build files.
- HTTP Basic auth on by default (`CHARTDB_USERNAME`, generated `CHARTDB_PASSWORD`).
- Upstream analytics and the "star us" pop-up off by default (`DISABLE_ANALYTICS=true`, `HIDE_CHARTDB_CLOUD=true`).
- Optional AI export settings (`OPENAI_API_KEY`, `OPENAI_API_ENDPOINT`, `LLM_MODEL_NAME`) are read at start, so no rebuild is needed.
- README: Deploy on Railway button (template `chartdb-2`).
