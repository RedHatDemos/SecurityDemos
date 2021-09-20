FROM registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift:1.0
COPY spring-boot-angular-ecommerce-0.0.1-SNAPSHOT.jar /deployments/root.jar
ENV JAVA_ARGS /deployments/root.jar
CMD java -jar $JAVA_ARGS
