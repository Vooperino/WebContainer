ARG BASE_IMAGE=vooplv/webcontainer:core-dev
#FROM ${BASE_IMAGE}
FROM vooplv/webcontainer:core-dev

ENV DEBIAN_FRONTEND=noninteractive

EXPOSE 80
EXPOSE 443

COPY config /temp_config
COPY /init.sh /init.sh
COPY /install.sh /install.sh

RUN apt-get install nginx -y
RUN bash /install.sh
RUN rm /install.sh
RUN rm -rf /temp_config

HEALTHCHECK --interval=30s --timeout=10s --start-period=20s --retries=3 CMD health_check

CMD bash /init.sh