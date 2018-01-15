#### common.sls ####
mine.send:
   module.run:
     - func: network.ip_addrs
     - kwargs:
         interface: eth0

/etc/yum.repos.d/tartare-netdata-epel-7.repo:
   file.managed:
     - source: salt://files/tartare-netdata-epel-7.repo
     - user: root
     - group: root
     - mode: 644

/etc/yum.repos.d/saltstack.repo:
   file.managed:
     - source: salt://files/saltstack.repo
     - user: root
     - group: root
     - mode: 644

install some basic rpms:
   pkg.installed:
     - pkgs:
       - telnet
       - ntp
       - net-tools
       - zip
       - unzip
       - net-tools
       - bind-utils
       - epel-release
       - wget

install rpms required for netdata:
   pkg.installed:
     - sources:
       - http-parser: https://kojipkgs.fedoraproject.org//packages/http-parser/2.7.1/3.el7/x86_64/http-parser-2.7.1-3.el7.x86_64.rpm
       - http-parser-devel: https://kojipkgs.fedoraproject.org//packages/http-parser/2.7.1/3.el7/x86_64/http-parser-devel-2.7.1-3.el7.x86_64.rpm

{% if salt['file.file_exists']('/etc/yum.repos.d/epel.repo') %}
install netdata once epel is installed:
   pkg.installed:
     - skip_verify: True
     - skip_suggestions: True
     - pkgs:
       - nodejs
       - netdata
{% endif %}

update hosts file:
   file.managed:
     - name: /etc/hosts
     - user: root
     - group: root
     - mode: 644
     - contents: |
         127.0.0.1   localhost localhost.localdomain
         {{ salt['network.interfaces']()['eth0']['inet'][0]['address'] }} {{ grains['host'] }}.{{ pillar['env']['domain'] }} {{ grains['host'] }}
{% if grains['host'] != 'saltmaster' %}         {{ pillar['env']['saltmaster'] }} saltmaster.{{ pillar['env']['domain'] }} saltmaster {% endif %}

set-timezone:
   timezone.system:
     - name: Pacific/Auckland
     - utc: True

/etc/resolv.conf:
   file.managed:
     - contents: |
         search {{ pillar['env']['domain'] }}
{% if 'internal_dns' in pillar['env'] %}         nameserver {{ pillar['env']['internal_dns'] }}{% endif %}
{% if 'public_dns' in pillar['env'] %}         nameserver {{ pillar['env']['public_dns'] }}{% endif %}
     - user: root
     - group: root
     - mode: 644
