# Warning

This branch is unstable to use for prod! This is a work in progress build its not ready what so ever.

# WebContainer
Basic custom made docker web container

Currently includes

* PHP 7.4, 8.0, 8.1 (Including premade nginx/openresty scripts)
* Nginx or Openresty (Depends what you going to use)
* Cron
* Python 3 and 2
* PHP Composer
* Systemd replacer (Python) - *Incase if you want to use Pterodactyl, you will need to use it for the service*
* Certbot or LetsEncrypt

When using this docker container its best to use docker-compose

docker command example:
```bash
docker run -d -it -p 80:80 -p 443:443 -v ./web/web:/web -v ./web/config:/config -v ./web/scripts:/scripts --restart unless-stopped --mount type=tmpfs,destination=/tmp vooplv/webcontainer:tag
```

docker-compose example:
```yml
version: "3.9"
services:
  webcontainer:
    image: vooplv/webcontainer:tag
    tty: true
    stdin_open: true
    tmpfs:
      - /tmp
    volumes:
      - "./web/web:/web"
      - "./web/config:/config"
      - "./web/scripts:/scripts"
    ports:
      - "80:80"
      - "443:443"
    restart: unless-stopped
```
Link to the Docker Hub https://hub.docker.com/r/vooplv/webcontainer-nginx
