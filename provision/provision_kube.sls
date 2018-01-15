#### provision_kube.sls ####
{% if grains['host'] == 'saltmaster' %}
 {% if pillar['kube'] is defined %}
  {% for minion, fileargs in pillar['kube'].iteritems() %}
   {% set miniondir = "/var/cache/salt/master/minions/" + minion + "." + pillar['env']['domain']%}

kube provision {{ minion }}:
   {% if not salt['file.directory_exists'](miniondir) %}
   cmd.run:
      - name: |
         /srv/restapi/clonevm_withinit_v2.py {{ minion }} kube 
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
         echo "execute as: salt 'saltmaster.nutanix.local' state.sls provision_kube saltenv=provision"
{% endif %}
