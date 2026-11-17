# ChartDB on Railway

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/chartdb-2?utm_medium=integration&utm_source=button&utm_campaign=chartdb)

Railway template for [ChartDB](https://github.com/chartdb/chartdb), an open-source database diagram editor. Run one "smart query" against PostgreSQL, MySQL, MariaDB, SQL Server, SQLite, CockroachDB or ClickHouse, paste the JSON result, and ChartDB draws the schema as an editable diagram that you can export as SQL, DBML or an image.

## What it deploys

One service, **ChartDB**, built from this repo's `Dockerfile`:

- ChartDB **1.21.0**, the official image pinned by digest: `ghcr.io/chartdb/chartdb:1.21.0@sha256:88664866464034f3fb3f6840f149e5beb6cc40d1b1665dbd787ab54b876d751c`.
- nginx listening on `PORT` (8080), with a Railway domain, the health check `/healthz` and restart on failure, set in the Railway template (this repo has no `railway.json`).
- HTTP Basic auth in front of the whole app, with a password the template generates. The health check stays open.
- Upstream's Fathom analytics script and "star us" pop-up are turned off by default.

## Where your diagrams are stored

ChartDB keeps every diagram in **your browser's IndexedDB**, not on the server. The server only serves the app, so it has no database and no volume, and a redeploy or restart loses nothing. The flip side: diagrams don't sync between browsers or devices, and clearing site data in the browser deletes them. Use **Export** (JSON, SQL, DBML or image) to back up or share a diagram, and **Import** to load it elsewhere.

## Logging in

Open the Railway URL. The browser asks for a login: the user is `admin` (`CHARTDB_USERNAME`) and the password is `CHARTDB_PASSWORD` in the service's **Variables** tab.

## Variables

| Variable | Default | Description |
|---|---|---|
| `PORT` | `8080` | Port nginx listens on; the Railway domain points to it |
| `CHARTDB_USERNAME` | `admin` | Basic auth user |
| `CHARTDB_PASSWORD` | generated, 24 characters | Basic auth password. Delete the variable to make the app public (see below) |

Optional, add them to the service if you want them:

| Variable | Example | Description |
|---|---|---|
| `OPENAI_API_KEY` | `sk-...` | Turns on the AI export ("export SQL to another database dialect") through OpenAI |
| `OPENAI_API_ENDPOINT` | `https://YOUR-LLM-HOST/v1` | An OpenAI-compatible server instead of OpenAI; set together with `LLM_MODEL_NAME` |
| `LLM_MODEL_NAME` | `gpt-4o-mini` | Model for the AI export |
| `DISABLE_ANALYTICS` | `true` | Set to `false` to load upstream's Fathom analytics script |
| `HIDE_CHARTDB_CLOUD` | `true` | Set to `false` to show upstream's "star us" pop-up |

**The AI key is sent to the browser.** ChartDB calls the LLM from the browser, so anyone who can open the app can read `OPENAI_API_KEY` from `/config.js`. Keep Basic auth on when you set it, and use a key with a spending limit.

## Updates

Projects deployed from the template build from this repo's `main` branch. When a new ChartDB version is merged to `main`, Railway shows those projects an "update available" notice, and each owner chooses when to apply it. Every version is listed in [CHANGELOG.md](CHANGELOG.md), with breaking changes first. Diagrams live in the browser, so an update never touches them.

## Licence

ChartDB is licensed under the [GNU AGPL v3.0](https://github.com/chartdb/chartdb/blob/main/LICENSE). This repo only wraps the official image.
