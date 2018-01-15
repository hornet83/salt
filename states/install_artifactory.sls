include:
   - common

java-1.8.0-openjdk:
  pkg.installed

/etc/yum.repos.d/artifactory.repo:
  file.managed:
    - source: salt://files/jfrog-artifactory.repo

jfrog-artifactory-oss-5.4.6:
  pkg.installed:
     - require:
       - file: /etc/yum.repos.d/artifactory.repo
     - fromrepo: bintray--jfrog-artifactory-rpms

start-service:
   service.running:
      - name: artifactory.service
      - enable: True
