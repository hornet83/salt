log_webapp_install:
   local.cmd.run:
     - name: log artifactory install
     - tgt: 'saltmaster*'
     - arg:
       - 'echo "[{{ data['id'] }}}][app server started] Starting Webapp Install on $(date). ({{ tag }})" >> /tmp/salt.reactor.log'

tell_minion_to_install_webapp:
   local.state.sls:
     - name: tell minion to install webapp
     - tgt: {{ data['id'] }}
     - arg:
       - install_webapp
