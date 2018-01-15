log_gogs_install:
   local.cmd.run:
     - name: log artifactory install
     - tgt: 'saltmaster*'
     - arg:
       - 'echo "[{{ data['id'] }}}][gogs started] Starting Gogs / mysql and nginx Install on $(date). ({{ tag }})" >> /tmp/salt.reactor.log'

tell_minion_to_install_software:
   local.state.sls:
     - name: tell minion to install software
     - tgt: {{ data['id'] }}
     - arg:
       - install_gogs
