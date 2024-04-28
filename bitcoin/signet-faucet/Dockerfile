FROM node:20-alpine AS build

WORKDIR /tmp

RUN apk add --no-cache \
    git \
 && git clone --branch resurrection https://github.com/1ma/bitcoin-faucet

WORKDIR /tmp/bitcoin-faucet

RUN cp src/config.example.ts src/config.ts \
 && npm install \
 && ./node_modules/typescript/bin/tsc


FROM node:20-alpine

ENV BITCOIND_COOKIE   ""
ENV BITCOIND_HOST     ""
ENV BITCOIND_PASS     ""
ENV BITCOIND_RPCPORT  ""
ENV BITCOIND_USER     ""
ENV EXPLORER_URL      ""
ENV FAUCET_DAY_MAX    ""
ENV FAUCET_HOUR_MAX   ""
ENV FAUCET_HOUR_SPLIT ""
ENV FAUCET_MIN        ""
ENV FAUCET_NAME       ""
ENV FAUCET_PASSWRD    ""
ENV FAUCET_WEEK_MAX   ""
ENV MONGODB_HOST      ""

COPY --from=build /tmp/bitcoin-faucet/html         /srv/faucet/html
COPY --from=build /tmp/bitcoin-faucet/built        /srv/faucet/app
COPY --from=build /tmp/bitcoin-faucet/node_modules /srv/faucet/node_modules

WORKDIR /srv/faucet/app

EXPOSE 8123

CMD ["node", "index.js"]
