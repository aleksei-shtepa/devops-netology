FROM elasticsearch:7.17.4

COPY ./elasticsearch.yml /usr/share/elasticsearch/config/elasticsearch.yml
COPY ./jvm.options /usr/share/elasticsearch/config/jvm.options.d/jvm.options

RUN mkdir /var/lib/elastic-7 && chown elasticsearch /var/lib/elastic-7 &&\
    mkdir /var/log/elastic-7 && chown elasticsearch /var/log/elastic-7 &&\
    mkdir /usr/share/elasticsearch/snapshots && chown elasticsearch /usr/share/elasticsearch/snapshots
