FROM registry.access.redhat.com/ubi7/ubi:latest

LABEL name="openjdk" \
      version="1.8" \
      summary="openjdk 1.8 for building java applications" \
      description="ubi8-based openjdk 1.8 version for building plain java applications" \
      io.k8s.description="ubi8-based openjdk 1.8 version for building plain java applications"

EXPOSE 8080 8443

ENV HOME="/home/ubi"

USER root

# Remediate Image

COPY fix*.sh /

RUN chmod +x /fix*.sh && for i in $(ls /fix*.sh); do sh ${i}; done && rm -rf /fix*.sh
RUN yum update -y && rm -rf /var/cache/yum/ /var/tmp/* /tmp/* /var/tmp/.???* /tmp/.???*

ENV container oci
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Install OpenJDK

RUN set -ex; \
        \
        yum install -y --nogpgcheck java-1.8.0-openjdk && \
        yum -y clean all && [ ! -d /var/cache/yum ] || rm -rf /var/cache/yum
    
RUN java -XshowSettings:properties -version 2>&1 > /dev/null | \
        grep 'java.home' | tr -d '[:space:]' | \
        awk -v tag='export JAVA_HOME=' -F '=' '{print tag $2}'  >> /etc/profile.d/java.sh && \
    java -XshowSettings:properties -version 2>&1 > /dev/null | \
        grep 'java.version' | tr -d '[:space:]' | \
        awk -v tag='export JAVA_VERSION=' -F '=' '{print tag $2}'  >> /etc/profile.d/java.sh && \
    source /etc/profile 

## Create non-privileged user, POSSIBLY NEED TO REMOVE FOR JAVA BASE
#RUN echo 'ubi:x:1001:0:ubi:/home/ubi:/bin/bash' >> /etc/passwd && \
#    cp -r /etc/skel /home/ubi && \
#    chown -R ubi:0 /home/ubi && \
#    chmod -R g=u,o-xw /home/ubi

WORKDIR /home/ubi

USER 1001

HEALTHCHECK --interval=15s --timeout=10s --retries=3 CMD which java
