##### manage_bind.sls ######

{% set octets = pillar['env']['subnet'].split('.') %}
/etc/named/zones/db.{{ octets[2] }}.{{ octets[1] }}.{{ octets[0] }}:
  file.managed:
    - source: salt://files/db.subnet.pyt
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - makedirs: True

/etc/named/zones/db.{{ pillar['env']['domain'] }}:
  file.managed:
    - source: salt://files/db.salt.example.com.pyt
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - makedirs: True

bind_reload:
  service.running:
    - name: named
    - watch:
        - file: /etc/named/zones/db.{{ pillar['env']['domain'] }}
