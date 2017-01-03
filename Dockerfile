FROM ubuntu:trusty
MAINTAINER Yubo Zhao <zhao.yubo@hotmail.com>

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

ARG GRAFANA_VERSION=4.0.2-1481203731
ENV GRAFANA 4.0.2-1481203731

RUN apt-get -y update && apt-get -y --force-yes install wget curl apt-transport-https supervisor build-essential libtool git autoconf automake check 

#install grafana
RUN wget https://grafanarel.s3.amazonaws.com/builds/grafana_${GRAFANA_VERSION}_amd64.deb && \
    apt-get install -y adduser libfontconfig && \
    dpkg -i grafana_${GRAFANA_VERSION}_amd64.deb 
ADD grafana/grafana.ini /etc/grafana/grafana.ini
RUN chown grafana:grafana /etc/grafana/grafana.ini

#ADD grafan/run.sh /etc/my_init.d/04_run_grafana.sh
RUN update-rc.d grafana-server defaults 95 10

#install influxdb 
RUN curl -sL https://repos.influxdata.com/influxdb.key | sudo apt-key add - &&\ 
    source /etc/lsb-release && \
    echo "deb https://repos.influxdata.com/ubuntu trusty stable" | tee /etc/apt/sources.list.d/influxdb.list  && \
    apt-get update && apt-get install influxdb
ADD influxdb/influxdb.conf /etc/influxdb/influxdb.conf
RUN chown influxdb:influxdb /etc/influxdb/influxdb.conf


#install statsite
RUN cd /var/tmp && wget https://github.com/statsite/statsite/archive/v0.8.0.tar.gz &&  tar -xvf v0.8.0.tar.gz && cd /var/tmp/statsite-0.8.0 && ./bootstrap.sh && ./configure && make && mv ./src/statsite /bin/statsite
ADD statsite/statsite.ini /etc/statsite.ini
RUN mkdir -p /etc/statsite/conf.d
ADD statsite/influxdb.ini /etc/statsite/conf.d/influxdb.ini
RUN cp /var/tmp/statsite-0.8.0/sinks/influxdb.py /etc/statsite/conf.d/influxdb.py

ADD supervisord/grafana.conf /etc/supervisor/conf.d/grafana.conf
ADD supervisord/influxdb.conf /etc/supervisor/conf.d/influxdb.conf
ADD supervisord/statsite.conf /etc/supervisor/conf.d/statsite.conf

CMD ["supervisord", "-n"]
