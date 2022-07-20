# WebContainer
Basic custom made docker web container

Currently includes

* PHP 7.4, 8.0, 8.1 (Including premade nginx scripts)
* Nginx
* Cron
* Python 3 and 2
* PHP Composer
* Systemd replacer (Python) - *Incase if you want to use Pterodactyl, you will need to use it for the service*
* Certbot or LetsEncrypt

When using this docker container its best to use docker-compose

docker-compose example:
```yml
version: "3.3"
services:
  webcontainer:
    image: vooplv/webcontainer-nginx
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
