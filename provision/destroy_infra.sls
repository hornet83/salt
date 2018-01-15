#### destroy_infra.sls ####
{% if grains['host'] == 'saltmaster' %}
 {% if pillar['infra'] is defined %}
  {% for minion, fileargs in pillar['infra'].iteritems() %}
   {% set miniondir = "/var/cache/salt/master/minions/" + minion + "." + pillar['env']['domain']%}

infra destroy {{ minion }}:
   {% if salt['file.directory_exists'](miniondir) %}
   cmd.run:
      - name: |
         /srv/restapi/deletevm_v2.py {{ minion }}
         salt-key -y -d {{ minion }}*
   {% else %}
   cmd.run:
      - name: echo "server {{ minion }} doesnt exists -> nothing to delete!"
   {% endif %}
  {% endfor %}
 {% endif %}
{% else %}
wrong server:
   cmd.run:
      - name: |
         echo "destroy can only be ran on saltmaster.. you tried it on {{ grains['host'] }}!"
         echo "execute as: salt 'saltmaster.nutanix.local' state.sls destroy_infra saltenv=provision"
{% endif %}
