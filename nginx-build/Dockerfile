FROM vooplv/webcontainer:core
ENV DEBIAN_FRONTEND noninteractive
MAINTAINER voop@voop.lv

EXPOSE 80
EXPOSE 443

COPY ../core_files/scripts scripts
COPY ../install install
COPY config config

COPY /init.sh /init.sh

RUN apt-get install nginx -y
RUN cp -r -f /scripts/systemd-replacer/systemctl3.py /usr/bin/systemctl

CMD bash /init.sh