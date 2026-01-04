FROM node:25-alpine AS builder

WORKDIR /tmp

RUN apk add --no-cache \
    build-base \
    curl \
    git

RUN curl -s https://sh.rustup.rs | sh -s -- -y --profile minimal --default-toolchain none \
 && git clone --depth 1 --branch rework-health-audit https://github.com/retropex/mempool

WORKDIR /tmp/mempool/backend

RUN . "$HOME/.cargo/env" && npm install --omit=dev --omit=optional
RUN npm run build


FROM node:25-alpine AS final

ENV MEMPOOL_NETWORK=mainnet
ENV MEMPOOL_HTTP_PORT=8999
ENV MEMPOOL_CACHE_ENABLED=true

ENV CORE_RPC_HOST=127.0.0.1
ENV CORE_RPC_PORT=8332
ENV CORE_RPC_USERNAME=mempool
ENV CORE_RPC_PASSWORD=mempool
ENV CORE_RPC_COOKIE=false
ENV CORE_RPC_COOKIE_PATH=/path/to/bitcoin/.cookie

ENV ELECTRUM_HOST=127.0.0.1
ENV ELECTRUM_PORT=50002
ENV ELECTRUM_TLS_ENABLED=true

ENV DATABASE_HOST=127.0.0.1
ENV DATABASE_DATABASE=mempool
ENV DATABASE_PASSWORD=mempool
ENV DATABASE_USERNAME=mempool

ENV REDIS_ENABLED=false
ENV REDIS_UNIX_SOCKET_PATH=/tmp/redis.sock

WORKDIR /app

COPY --from=builder /tmp/mempool/backend/dist                       /app/dist
COPY --from=builder /tmp/mempool/backend/mempool-config.sample.json /app/mempool-config.sample.json
COPY --from=builder /tmp/mempool/backend/node_modules               /app/node_modules
COPY --from=builder /tmp/mempool/backend/package.json               /app/package.json
COPY --from=builder /tmp/mempool/backend/rust-gbt                   /app/rust-gbt

COPY --chmod=644 config-generator.js /app/config-generator.js
COPY --chmod=755 entrypoint.sh       /usr/local/bin/entrypoint.sh

EXPOSE 8999

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["npm", "run", "start"]
