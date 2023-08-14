FROM caddy:2.7.3-builder AS builder

RUN xcaddy build \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2.7.3

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
COPY ./caddy_security.conf /etc/caddy/caddy_security.conf
