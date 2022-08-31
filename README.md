# Warning

This branch is unstable to use for prod! This is a work in progress build its not ready what so ever.

Currently working
1) Main Core
2) Nginx
3) OpenResty

# WebContainer
Basic custom made docker web container

## WebContainers Tags
*) `core` - is the main source aka the core for other tags, to make things a bit cleaner
*) `nginx` - Uses Nginx as the web server
*) `openresty` - Uses OpenResty as the web server


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
Link to the Docker Hub https://hub.docker.com/r/vooplv/webcontainer


# Building the Docker images (WIP)

It is pretty straight forward, once you are in the root git repo directory aka the current repo directory when you will beed to build the core using this command
```bash
docker build -t vooplv/webcontainer:core .
```
With the core image tag that will allow nginx or openresty images to be build since it does need the Web container core image, because of the packages and files.