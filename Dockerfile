FROM ubuntu:24.10

RUN apt-get update -y
RUN apt-get install -y sudo init systemd

EXPOSE 443
