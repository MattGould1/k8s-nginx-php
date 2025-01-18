# K8s NGINX ingress to nginx web server

This is a working example of how to setup NGINX ingress controller and cert manager and pass traffic to a pod running NGINX on port 80.

This was built for WordPress (a PHP application). It is useful for any PHP application that serves static files alongside their PHP scripts.

If your PHP application does not serve static files, you should strongly consider using https://kubernetes.github.io/ingress-nginx/user-guide/fcgi-services/. You will be able to pass traffic directly from your NGINX ingress controller to your FastCGI server.

### WordPress only consideration

This setup acts as a reverse proxy, where NGINX ingress handles the SSL termination and passes the traffic an NGINX web server without SSL.

See: https://developer.wordpress.org/advanced-administration/security/https/#using-a-reverse-proxy

If you do not add this snippet to WordPress, you will encounter a redirect loop.

```php
define('FORCE_SSL_ADMIN', true);
if (strpos($_SERVER['HTTP_X_FORWARDED_PROTO'], 'https') !== false)
    $_SERVER['HTTPS'] = 'on';
```

## Usage

Before running `./scripts/buildAndPublish.sh`

- Go to `./cert-issuer.yaml` and change `your-email@domain.com` to your email address
- Go to `./ingress_nginx_svc.yaml` and change `example.domain` to your domain
- Go to `./scripts/buildAndPublish.sh` and remove `mattsws` (my public docker hub) and replace it with your registry
- Run `cp .env.example .env && ./scripts/secrets.sh`

## Secrets

Secrets are managed in `secret.yaml`. You can generate secrets from an `.env` file by running.

- `cp .env.example .env && ./scripts/secrets.sh`

Copy the output of this into `secret.yaml`. (you probably want to automate this).

## Limitations

All files are stored in the docker image. This is for simplicities sake, you may wish to use a persistent volume to store your code, which may make updates simpler rather than rebuilding docker images each time. Additionally, if you do choose to use docker images, you need to consider using a private repository.

This is not setup to use minikube locally. Simple run `docker-compose up --build` instead.
