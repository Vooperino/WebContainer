> [!CAUTION]
> This branch contains new reworks of the container logic and structure, it is not recommended to use this branch for production use. No guarantees that it will work as expected, it is still in development and testing phase. Expect some bugs and issues or failed compiled images.

> [!IMPORTANT]  
> Details below are outdated, expect changes in the future!

# WebContainer
Basic custom made docker web container

## WebContainers Tags
* `core` - is the main source aka the core for other tags, to make things a bit cleaner
* `nginx` - Uses Nginx as the web server
* `openresty` - Uses OpenResty as the web server


Currently includes

* PHP 7.4, 8.0, 8.1, 8.2, 8.3 (Including premade nginx/openresty scripts)
* Nginx or Openresty (Depends what you going to use)
* Cron
* Python 3 and 2
* PHP Composer
* Systemd replacer (Python) - *Incase if you want to use Pterodactyl or Pelican, you will need to use it for the service*
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

## If you want to stop the auto package update on the container start up then you will need to an environment variables
`Docker Command`
```
-e UPDATE_ON_LAUNCH=true
```

`Docker Compose`
```yml
environment:
    UPDATE_ON_LAUNCH: true
```


# Building the Docker images (WIP)

It is pretty straight forward, once you are in the root git repo directory aka the current repo directory when you will beed to build the core using this command
```bash
docker build -t vooplv/webcontainer:core .
```
or run the build.sh file
The core image tag will allow nginx or openresty images to be built since it does need the Web container core image, because of the packages and files.


`Made in Latvia :)`