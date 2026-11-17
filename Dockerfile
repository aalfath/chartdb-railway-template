# ChartDB for Railway: the official image, pinned by version and digest, plus a small nginx wrapper.
FROM ghcr.io/chartdb/chartdb:1.21.0@sha256:88664866464034f3fb3f6840f149e5beb6cc40d1b1665dbd787ab54b876d751c

# Our nginx site (listens on PORT, open /healthz, optional Basic auth, caching) and start script.
COPY nginx.conf.template /etc/nginx/chartdb/site.conf.template
COPY railway-start.sh /usr/local/bin/railway-start.sh
RUN chmod 755 /usr/local/bin/railway-start.sh \
 && rm -f /etc/nginx/conf.d/default.conf.template

# Defaults for a self-hosted instance. Override any of them in the service's variables.
#   DISABLE_ANALYTICS=true   no Fathom analytics script from upstream's hosted site
#   HIDE_CHARTDB_CLOUD=true  no "star us" pop-up in the editor
ENV PORT=8080 \
    CHARTDB_USERNAME=admin \
    DISABLE_ANALYTICS=true \
    HIDE_CHARTDB_CLOUD=true

EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/railway-start.sh"]
