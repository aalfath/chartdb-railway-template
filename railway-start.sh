#!/bin/sh
# Start ChartDB's nginx on $PORT. Writes the site config, the optional Basic auth file and
# /config.js (ChartDB's runtime settings), then runs nginx in the foreground.
set -eu

PORT="${PORT:-8080}"
CHARTDB_USERNAME="${CHARTDB_USERNAME:-admin}"
CHARTDB_PASSWORD="${CHARTDB_PASSWORD:-}"

case "$PORT" in
  ''|*[!0-9]*) echo "railway-start: PORT must be a number, got '$PORT'" >&2; exit 1 ;;
esac

# Basic auth: on when CHARTDB_PASSWORD is set (the Railway template generates one).
AUTH_CONF=/etc/nginx/chartdb/auth.conf
if [ -n "$CHARTDB_PASSWORD" ]; then
  case "$CHARTDB_USERNAME" in
    *:*|'') echo "railway-start: CHARTDB_USERNAME must be non-empty and must not contain ':'" >&2; exit 1 ;;
  esac
  umask 077
  printf '%s:{PLAIN}%s\n' "$CHARTDB_USERNAME" "$CHARTDB_PASSWORD" > /etc/nginx/chartdb/htpasswd
  chown root:nginx /etc/nginx/chartdb/htpasswd
  chmod 640 /etc/nginx/chartdb/htpasswd
  umask 022
  printf 'auth_basic "ChartDB";\nauth_basic_user_file /etc/nginx/chartdb/htpasswd;\n' > "$AUTH_CONF"
  echo "railway-start: Basic auth is on (user '$CHARTDB_USERNAME')"
else
  : > "$AUTH_CONF"
  echo "railway-start: CHARTDB_PASSWORD is empty, so Basic auth is OFF and anyone with the URL can open ChartDB"
fi

# /config.js: ChartDB reads these settings in the browser. Escape backslashes and double quotes
# so a value can't break out of its JavaScript string.
js() { printf '%s' "${1:-}" | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g' | tr -d '\n\r'; }
cat > /etc/nginx/chartdb/config.js <<JS
window.env = {
    OPENAI_API_KEY: "$(js "${OPENAI_API_KEY:-}")",
    OPENAI_API_ENDPOINT: "$(js "${OPENAI_API_ENDPOINT:-}")",
    LLM_MODEL_NAME: "$(js "${LLM_MODEL_NAME:-}")",
    HIDE_CHARTDB_CLOUD: "$(js "${HIDE_CHARTDB_CLOUD:-}")",
    DISABLE_ANALYTICS: "$(js "${DISABLE_ANALYTICS:-}")"
};
JS
chmod 644 /etc/nginx/chartdb/config.js

PORT="$PORT" envsubst '${PORT}' < /etc/nginx/chartdb/site.conf.template > /etc/nginx/conf.d/default.conf
nginx -t -q
echo "railway-start: ChartDB listening on port $PORT"
exec nginx -g 'daemon off;'
