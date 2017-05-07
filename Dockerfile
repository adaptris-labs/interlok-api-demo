FROM adaptris/interlok:snapshot-alpine

EXPOSE 8080

WORKDIR /opt/interlok
ADD ant /opt/interlok/ant
ADD config /opt/interlok/config

RUN cd ant && \
    ant deploy && \
    rm -rf /root/.ivy2/cache/com.adaptris.ui && \
    rm -rf /opt/interlok/ant 


ENTRYPOINT ["/docker-entrypoint.sh"]
