java-1.8.0-openjdk:
  pkg.installed

/var/webapp/webapp.jar:
  file.managed:
    - source: http://10.21.40.82:8081/artifactory/example-repo-local/demo-webapp/0.0.1-SNAPSHOT/demo-webapp-0.0.1-SNAPSHOT.jar
    - user: root
    - group: root
    - mode: 755
    - makedirs: True
    - skip_verify: True

/usr/lib/systemd/system/webapp.service:
  file.managed:
    - contents: |
        [Unit]
        Description=webapp
        After=syslog.target

        [Service]
        User=root
        ExecStart=/var/webapp/webapp.jar
        SuccessExitStatus=143
 
        [Install]
        WantedBy=multi-user.target
    - user: root
    - group: root
    - mode: 644

start-service:
   service.running:
      - name: webapp.service
      - enable: True
