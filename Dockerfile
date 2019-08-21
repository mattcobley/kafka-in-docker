FROM ubuntu:18.04
RUN echo "Europe/London"|tee /etc/timezone

ENV DAEMON_RUN=true
ENV SCALA_VERSION=2.11.12
ENV SCALA_HOME=/usr/share/scala
ENV KAFKA_HOME=/usr/share/kafka

RUN mkdir /kafka-scripts
COPY run-kafka.sh /kafka-scripts 

RUN apt-get update && apt-get install -y gnupg gnupg1 gnupg2 apt-utils

RUN echo "deb https://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823

RUN apt-get update; apt-get install -y wget ca-certificates sbt openjdk-8-jdk nano && \
    cd "/tmp" && \
    wget "https://downloads.lightbend.com/scala/${SCALA_VERSION}/scala-${SCALA_VERSION}.tgz" && \
    tar xzf "scala-${SCALA_VERSION}.tgz" && \
    mkdir "${SCALA_HOME}" && \
    mv "/tmp/scala-${SCALA_VERSION}" "${SCALA_HOME}" && \
    ln -s "${SCALA_HOME}/bin/"* "/usr/bin/" && \
    rm -rf "/tmp/"*
    
RUN cd "/tmp" && \
     wget "http://mirror.ox.ac.uk/sites/rsync.apache.org/kafka/2.1.1/kafka_2.11-2.1.1.tgz" && \
     tar xzf "kafka_2.11-2.1.1.tgz" && \
     mv "/tmp/kafka_2.11-2.1.1" "${KAFKA_HOME}" && \
     ln -s "${KAFKA_HOME}/bin/"* "/usr/bin/" && \
     rm -rf "/tmp/"*

COPY server.properties "${KAFKA_HOME}/config/"

CMD ["/bin/bash", "/kafka-scripts/run-kafka.sh"]
