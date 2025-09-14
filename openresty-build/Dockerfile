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
RUN rm -rf /temp_scripts

CMD bash /init.sh