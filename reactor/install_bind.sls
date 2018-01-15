log_bind_install:
   local.cmd.run:
     - name: log bind install
     - tgt: 'saltmaster*'
     - arg:
       - 'echo "[{{ data['id'] }}}][DNS server started] Starting Bind Install and configuration on $(date). ({{ tag }})" >> /tmp/salt.reactor.log'

tell_minion_to_install_software:
   local.state.sls:
     - name: tell minion to install software
     - tgt: {{ data['id'] }}
     - arg:
       - install_bind
