# SSL/HTTPS Setup for Development

This application supports optional SSL/TLS in development using Let's Encrypt certificates or custom certificates.

## Quick Setup

1. **Copy the override template:**
   ```bash
   cp docker-compose.override.yml.example docker-compose.override.yml
   ```

2. **Edit `docker-compose.override.yml`** and uncomment SSL settings:
   ```yaml
   services:
     lucky:
       environment:
         SSL_ENABLED: "true"
         SSL_CERT_PATH: "/etc/letsencrypt/live/your-domain.com/fullchain.pem"
         SSL_KEY_PATH: "/etc/letsencrypt/live/your-domain.com/privkey.pem"
       volumes:
         - /etc/letsencrypt:/etc/letsencrypt:ro
   ```

3. **Start the server:**
   ```bash
   bin/dev
   ```

   Server will be available at **https://localhost:3000**

## Port Configuration

- **Port 3000** (container) - Always serves the app
  - HTTPS when `SSL_ENABLED=true`
  - HTTP when SSL is disabled or not configured
- **Host port mapping**:
  - Port 3000 (default) - Maps to container port 3000
  - Port 5000 (optional) - Can map to container 3000 for HTTP fallback

## Let's Encrypt / Certbot Certificates

If using Certbot on the host machine:

```yaml
services:
  lucky:
    environment:
      SSL_ENABLED: "true"
      SSL_CERT_PATH: "/etc/letsencrypt/live/your-domain.com/fullchain.pem"
      SSL_KEY_PATH: "/etc/letsencrypt/live/your-domain.com/privkey.pem"
    volumes:
      - /etc/letsencrypt:/etc/letsencrypt:ro  # Mount certs read-only
```

## Custom Certificates

For custom certificates:

```yaml
services:
  lucky:
    environment:
      SSL_ENABLED: "true"
      SSL_CERT_PATH: "/certs/server.crt"
      SSL_KEY_PATH: "/certs/server.key"
    volumes:
      - ./certs:/certs:ro  # Mount your local certs directory
```

## Disabling SSL

Simply don't create `docker-compose.override.yml` or set `SSL_ENABLED: "false"`. The server will run on HTTP port 3000.

## Environment Variables

SSL configuration uses these environment variables (set in docker-compose.override.yml):

- `SSL_ENABLED` - Set to `"true"` to enable SSL/TLS
- `SSL_CERT_PATH` - Path to SSL certificate file (fullchain.pem for Let's Encrypt)
- `SSL_KEY_PATH` - Path to private key file

These can also be set in `.env.development.local` but docker-compose.override.yml takes precedence.

## How It Works

The application uses Crystal's OpenSSL library to bind the server with TLS when SSL is enabled:

```crystal
# src/app_server.cr
def listen
  if ssl_enabled?
    server.bind_tls(host, port, ssl_context, reuse_port: false)
    server.listen
  else
    server.listen(host, port, reuse_port: false)
  end
end
```

The protocol is automatically detected for URL generation throughout the app.

## Troubleshooting

**Certificate permission errors:**
- Ensure Docker can read the certificate files
- Check file permissions: `ls -la /etc/letsencrypt/live/your-domain.com/`
- Let's Encrypt certs are usually owned by root with restricted permissions

**Server won't start:**
- Verify certificate paths are correct inside the container
- Check Docker logs: `docker compose logs lucky`
- Test certificate: `openssl x509 -in /path/to/cert.pem -text -noout`

**Browser certificate warnings:**
- Self-signed certificates will show warnings (this is normal)
- Use Let's Encrypt for valid certificates
- Or add your CA to browser's trusted certificates
