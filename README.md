Caddy server with the modules I need.

## Caddy Modules

[Caddy Packages & Modules](https://caddyserver.com/download)

- Cloudflare https://github.com/caddy-dns/cloudflare

### Cloudflare

- Create an API Token https://dash.cloudflare.com/profile/api-tokens
  - Permissions:
    - Zone / Zone / Read
    - Zone / DNS / Edit
  - Zone Resources:
    - Include: Pick the zones you want to use in your Caddyfile

## Docker Compose

```yaml
version: "3.8"

services:
  caddy:
    image: ghcr.io/anthonydiiorio/caddy-lab:latest
    container_name: caddy
    restart: always
    environment:
      - ACME_AGREE=true
      - ACME_EMAIL="email"
      - CLOUDFLARE_API_TOKEN=token
    ports:
      - "80:80"
      - "443:443"
      - "443:443/udp" # HTTP/3
      #- "2015:2015" # Metrics
    
    volumes:
      - ./caddy/Caddyfile:/etc/caddy/Caddyfile
      - ./caddy/site:/srv
      - caddy_data:/data
      - caddy_config:/config

volumes:
  caddy_data:
    external: true
  caddy_config:
```

Create the external volume with `docker volume create caddy_data`

## Caddyfile

### Cloudflare DNS-01 Challenge

To add the DNS Challenge to your site, add the following tls directive to the site block. This is useful for internal sites.

```
tls {$ACME_EMAIL} {
  dns cloudflare {$CLOUDFLARE_API_TOKEN}
}
```

**Example:**
```
example.com {
	reverse_proxy server:80
	
	tls {$ACME_EMAIL} {
    		dns cloudflare {$CLOUDFLARE_API_TOKEN}
	}
}
```

### Caddy Security Headers

```
example.com {
	reverse_proxy server:80
	import /etc/caddy/caddy_security.conf
}
```
