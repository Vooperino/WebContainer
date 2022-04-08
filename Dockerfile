FROM debian:bullseye-slim
ENV DEBIAN_FRONTEND noninteractive

EXPOSE 80
EXPOSE 443

COPY scripts scripts
COPY install install
COPY config config

RUN bash /install/install.sh
RUN cp -r -f /scripts/systemd-replacer/systemctl3.py /usr/bin/systemctl

CMD bash /scripts/init.sh