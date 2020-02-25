FROM 172.30.1.1:5000/myproject/sbt-java11:1.3.8

ENV CMAK_VERSION=3.0.0.1

# Override values in application.conf. Check conf for more...
ENV ZK_HOSTS=localhost:2181

RUN mkdir -p /tmp && \
    cd /tmp && \
    curl -LO https://github.com/yahoo/CMAK/archive/${CMAK_VERSION}.tar.gz && \
    tar xxf ${CMAK_VERSION}.tar.gz && \
    cd /tmp/CMAK-${CMAK_VERSION} && \
    sbt clean dist && \
    unzip -d / ./target/universal/cmak-${CMAK_VERSION}.zip && \
    rm -fr /tmp/${CMAK_VERSION} /tmp/CMAK-${CMAK_VERSION}

COPY application.conf /application.conf

WORKDIR /cmak-${KM_VERSION}

EXPOSE 9000

ENTRYPOINT ["./bin/cmak", "-Dpidfile.path=/dev/null", "-Dconfig.file=/application.conf"]