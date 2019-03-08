FROM docker.io/sonarqube:latest
USER 0
VOLUME /opt/sonarqube/extensions/plugins
RUN chown -R 0:0 /opt/sonarqube && chmod -R 770 /opt/sonarqube
RUN chown -R 0:0 /opt/sonarqube/data && chmod -R 770 /opt/sonarqube/data 
USER 1001
