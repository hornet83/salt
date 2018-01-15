#### destroy_prod.sls ####
{% if grains['host'] == 'saltmaster' %}
 {% if pillar['prod'] is defined %}
  {% for minion, fileargs in pillar['prod'].iteritems() %}
   {% set miniondir = "/var/cache/salt/master/minions/" + minion + "." + pillar['env']['domain']%}

prod destroy {{ minion }}:
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
         echo "execute as: salt 'saltmaster.nutanix.local' state.sls destroy_prod saltenv=provision"
{% endif %}
