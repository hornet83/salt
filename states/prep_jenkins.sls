#### prep_jenkins.sls ####

include:
   - common

java-1.8.0-openjdk:
  pkg.installed

jenkins/install/base:
   event.send:
     - name: jenkins/install/base
