FROM node:25-alpine AS builder

WORKDIR /tmp

RUN apk add --no-cache \
    git \
    rsync

RUN git clone --depth 1 --branch rework-health-audit https://github.com/retropex/mempool

WORKDIR /tmp/mempool

WORKDIR /tmp/mempool/frontend

RUN npm install --omit=dev --omit=optional
RUN cp mempool-frontend-config.sample.json mempool-frontend-config.json
RUN node generate-config.js
RUN ./node_modules/@angular/cli/bin/ng.js build --configuration production
RUN node sync-assets.js 'src/resources/'
RUN rsync -av ./src/resources ./dist/mempool/browser && node sync-assets.js 'dist/mempool/browser/resources/'
RUN ./node_modules/.bin/browserify -p tinyify ./node_modules/@mempool/mempool.js/lib/index.js --standalone mempoolJS > ./dist/mempool/browser/mempool.js
RUN ./node_modules/.bin/browserify -p tinyify ./node_modules/@mempool/mempool.js/lib/index-liquid.js --standalone liquidJS > ./dist/mempool/browser/liquid.js


FROM caddy:alpine

ENV BACKEND_HTTP_HOST=localhost
ENV BACKEND_HTTP_PORT=8999
ENV FRONTEND_HTTP_PORT=8080

ENV ROOT_NETWORK=
ENV MAINNET_ENABLED=true
ENV TESTNET_ENABLED=false
ENV TESTNET_ENABLED=false
ENV SIGNET_ENABLED=false
ENV LIQUID_ENABLED=false
ENV LIQUID_TESTNET_ENABLED=false

ENV NGINX_PROTOCOL=http
ENV NGINX_HOSTNAME=localhost
ENV NGINX_PORT=8999

ENV ITEMS_PER_PAGE=10
ENV MEMPOOL_BLOCKS_AMOUNT=8
ENV KEEP_BLOCKS_AMOUNT=8
ENV HISTORICAL_PRICE=true
ENV ADDITIONAL_CURRENCIES=false

ENV MINING_DASHBOARD=true
ENV STRATUM_ENABLED=false

ENV AUDIT=false
ENV MAINNET_BLOCK_AUDIT_START_HEIGHT=0
ENV TESTNET_BLOCK_AUDIT_START_HEIGHT=0
ENV SIGNET_BLOCK_AUDIT_START_HEIGHT=0

ENV LIGHTNING=false

ENV ACCELERATOR=false
ENV ACCELERATOR_BUTTON=true
ENV PUBLIC_ACCELERATIONS=false
ENV BLOCK_WEIGHT_UNITS=4000000
ENV BASE_MODULE=mempool
ENV MEMPOOL_WEBSITE_URL=https://mempool.guide
ENV LIQUID_WEBSITE_URL=https://liquid.network
ENV SERVICES_API=https://mempool.guide/api/v1/services

COPY --chmod=644 Caddyfile     /etc/caddy/Caddyfile
COPY --chmod=755 entrypoint.sh /usr/local/bin/entrypoint.sh

COPY --from=builder /tmp/mempool/frontend/dist/mempool/browser /srv/browser

RUN apk add --no-cache gettext-envsubst

EXPOSE 8080

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
