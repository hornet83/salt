##### install_bind.sls #####

include:
   - common
   - manage_bind

install bind rpms:
   pkg.installed:
     - pkgs:
       - bind
       - bind-utils

start-service:
   service.running:
      - name: named.service
      - enable: True

/etc/named.conf:
  file.managed:
    - source: salt://files/named.conf.pyt
    - template: jinja
    - user: root
    - group: root
    - mode: 644

/etc/named/named.conf.local:
  file.managed:
    - source: salt://files/named.conf.local.pyt
    - template: jinja
    - user: root
    - group: root
    - mode: 644
