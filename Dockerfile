FROM debian:stretch
MAINTAINER Wazo Maintainers <dev@wazo.community>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -q update && apt-get -q -y install \
    apt-utils \
    gnupg \
    wget
RUN echo "deb http://mirror.wazo.community/debian/ wazo-dev-stretch main" > /etc/apt/sources.list.d/wazo-dist.list
RUN wget http://mirror.wazo.community/wazo_current.key -O - | apt-key add -
RUN apt-get -q update && apt-get -q -y install \
    wazo-libsccp \
    git \
    make \
    gcc \
    g++ \
    asterisk \
    quilt \
    libedit-dev

RUN  apt-get install --assume-yes openssl libxml2-dev libncurses5-dev uuid-dev sqlite3 libsqlite3-dev pkg-config libjansson-dev

RUN apt-get install --assume-yes asterisk-dev wazo-res-amqp-dev librabbitmq-dev

RUN git clone --single-branch --branch WAZO-939-Stasis-Event-Forwarding https://github.com/wazo-pbx/wazo-res-amqp.git
RUN cd wazo-res-amqp && \
    make && \
    make install

RUN git clone --single-branch --branch WAZO-939-Stasis-Event-Forwarding https://github.com/wazo-pbx/wazo-res-stasis-amqp.git
RUN cd wazo-res-stasis-amqp && \
    make && \
    make install DOCDIR=/usr/share/asterisk

EXPOSE 2000 5038 5060/udp

CMD ["asterisk", "-dvf"]