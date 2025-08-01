FROM debian:bullseye-slim
ENV DEBIAN_FRONTEND noninteractive
MAINTAINER voop@voop.lv

USER root

COPY /core_files/scripts /scripts
COPY /core_files/config /config
COPY /core_files/supervisord /vl/supervisord
COPY /install /install

RUN bash /install/install.sh
RUN bash /install/cleanConfig.sh
RUN rm -rf /install