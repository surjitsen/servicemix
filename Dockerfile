FROM centos:centos7.1.1503

ENV JAVA_PKG_BUILD_V 7u80-b15
ENV JAVA_PKG_V 7u80-linux-x64

RUN yum -y update

RUN yum clean all

RUN yum -y install wget

RUN yum -y install unzip

WORKDIR /opt

RUN curl -v -j -k -L -H "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/${JAVA_PKG_BUILD_V}/jdk-${JAVA_PKG_V}.rpm > jdk-${JAVA_PKG_V}.rpm

RUN rpm -ivh jdk-${JAVA_PKG_V}.rpm && \
	rm -f jdk-${JAVA_PKG_V}.rpm

WORKDIR /

ENV JAVA_HOME /usr/java/jdk1.7.0_80

ENV SERVICEMIX_VERSION_MAJOR=6
ENV SERVICEMIX_VERSION_MINOR=1
ENV SERVICEMIX_VERSION_PATCH=2
ENV SERVICEMIX_VERSION=${SERVICEMIX_VERSION_MAJOR}.${SERVICEMIX_VERSION_MINOR}.${SERVICEMIX_VERSION_PATCH}

RUN wget http://apache.mirrors.hoobly.com/servicemix/servicemix-${SERVICEMIX_VERSION_MAJOR}/${SERVICEMIX_VERSION}/apache-servicemix-${SERVICEMIX_VERSION}.zip; \
    unzip -d /opt apache-servicemix-${SERVICEMIX_VERSION}.zip; \
    rm -f apache-servicemix-${SERVICEMIX_VERSION}.zip; \
    ln -s /opt/apache-servicemix-${SERVICEMIX_VERSION} /opt/servicemix; \
    mkdir /deploy; \
    sed -i 's/^\(felix\.fileinstall\.dir\s*=\s*\).*$/\1\/deploy/' /opt/servicemix/etc/org.apache.felix.fileinstall-deploy.cfg; \
    useradd -r servicemix -d /opt/servicemix; \
    chown -R servicemix:servicemix /opt/apache-servicemix-${SERVICEMIX_VERSION}

VOLUME ["/deploy"]
USER servicemix
EXPOSE 1099 8101 8181 61616 44444
WORKDIR /opt/servicemix/bin
ENTRYPOINT ["./servicemix"]
