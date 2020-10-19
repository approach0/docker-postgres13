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
RUN unzip pgweb_linux_amd64.zip && mv pgweb_linux_amd64 /usr/local/bin/pgweb

## setup postgres
RUN mkdir /postgres
RUN chown postgres /postgres
USER postgres
RUN echo postgres > /tmp/pass
RUN /usr/lib/postgresql/13/bin/initdb -D /postgres -U postgres --pwfile=/tmp/pass
RUN rm /tmp/pass
RUN sed -i '/port =/c port = 5432' /postgres/postgresql.conf
RUN sed -i "/listen_addresses =/c listen_addresses = '*'" /postgres/postgresql.conf
CMD /usr/lib/postgresql/13/bin/postgres -D /postgres
