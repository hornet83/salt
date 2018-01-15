include:
   - common

/etc/yum.repos.d/gogs.repo:
  file.managed:
    - source: salt://files/gogs.repo

add mysql repo and install mysql server:
   pkg.installed:
     - sources:
       - mysql57-community-release: https://repo.mysql.com//mysql57-community-release-el7-11.noarch.rpm
       - mysql-community-server: https://cdn.mysql.com//Downloads/MySQL-5.7/mysql-community-server-5.7.19-1.el7.x86_64.rpm

gogs:
   pkg.installed:
     - require:
       - file: /etc/yum.repos.d/gogs.repo

nginx:
   pkg.installed:
     - pkgs:
       - nginx

update nginx config:
   file.managed:
     - name: /etc/nginx/conf.d/default.conf
     - user: root
     - group: root
     - mode: 644
     - contents: |
         server {
           listen 80; server_name ${HOSTNAME};
           location / { proxy_pass http://localhost:6000; }
         }

start-gogs:
   service.running:
      - name: gogs.service
      - enable: True

start-nginx:
   service.running:
      - name: nginx.service
      - enable: True

