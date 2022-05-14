FROM debian:bullseye-slim
ENV DEBIAN_FRONTEND noninteractive
MAINTAINER voop@voop.lv

EXPOSE 80
EXPOSE 443

COPY scripts scripts
COPY install install
COPY config config

COPY init.sh init.sh

RUN bash /install/install.sh
RUN bash /install/cleanConfig.sh
RUN rm -rf /install
RUN cp -r -f /scripts/systemd-replacer/systemctl3.py /usr/bin/systemctl

CMD bash /init.sh
