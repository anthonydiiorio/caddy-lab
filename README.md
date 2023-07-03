Caddy server with the modules I need.

[Caddy Modules](https://caddyserver.com/download)

- Cloudflare https://github.com/caddy-dns/cloudflare

### Docker Compose

```yaml
version: "3.8"

services:
  caddy:
    image: ghcr.io/anthonydiiorio/caddy-lab:latest
    container_name: caddy
    restart: always
    environment:
      - CLOUDFLARE_EMAIL="email"
      - CLOUDFLARE_API_TOKEN=token
      - ACME_AGREE=true
    ports:
      - "80:80"
      - "443:443"
      - "443:443/udp"
      #- "2015:2015" # Metrics
    
    volumes:
      - /home/user/caddy/Caddyfile:/etc/caddy/Caddyfile
      - /home/user/caddy/caddy_security.conf:/etc/caddy/caddy_security.conf
      - /home/user/caddy/sites:/srv
      - /home/user/caddy/data:/data
      - /home/user/caddy/config:/config
```

### Caddyfile

```
tls {$CLOUDFLARE_EMAIL} { 
  dns cloudflare {$CLOUDFLARE_API_TOKEN}
}
```
