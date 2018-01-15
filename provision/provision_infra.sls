#### provision_infra.sls ####
{% if grains['host'] == 'saltmaster' %}
 {% if pillar['infra'] is defined %}
  {% for minion, fileargs in pillar['infra'].iteritems() %}
   {% set miniondir = "/var/cache/salt/master/minions/" + minion + "." + pillar['env']['domain']%}

infra provision {{ minion }}:
   {% if not salt['file.directory_exists'](miniondir) %}
   cmd.run:
      - name: |
         /srv/restapi/clonevm_withinit_v2.py {{ minion }} infra 
         sleep 10
         /srv/restapi/powerstate_v2.py {{ minion }} ON
   {% else %}
   cmd.run:
      - name: echo "server {{ minion }} already exists!"   
   {% endif %}
  {% endfor %}
 {% endif %}
{% else %}
wrong server:
   cmd.run:
      - name: |
         echo "provisioning can only be ran on saltmaster.. you tried it on {{ grains['host'] }}!"
         echo "execute as: salt 'saltmaster.nutanix.local' state.sls provision_infra saltenv=provision"
{% endif %}

update pillar with dns ip:
   cmd.run:
      - name: |
         sed -i -e "s/internal_dns.*/internal_dns: `/srv/restapi/getdnsip_v2.py`/g" /srv/pillar/env.sls
