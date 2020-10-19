# base image
FROM debian:buster
#RUN sed -i s@/deb.debian.org/@/mirrors.aliyun.com/@g /etc/apt/sources.list
RUN apt-get update

## install postgresql 13
RUN apt-get install -y lsb-release wget gnupg2
RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 7FCC7D46ACCC4CF8
RUN apt-get update
RUN apt-get -y install postgresql-13

## install pgweb
RUN apt-get install -y unzip
RUN wget https://github.com/sosedoff/pgweb/releases/download/v0.11.7/pgweb_linux_amd64.zip
RUN unzip pgweb_linux_amd64.zip && mv pgweb_linux_amd64 /usr/local/bin/pgweb && rm pgweb_linux_amd64.zip

## setup entrypoint
RUN mkdir /postgres
RUN chown postgres /postgres
WORKDIR /postgres
ADD ./entrypoint.sh ./entrypoint.sh
RUN chmod +x ./entrypoint.sh

CMD /postgres/entrypoint.sh
