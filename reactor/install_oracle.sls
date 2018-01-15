log_oracle_install:
   local.cmd.run:
     - name: log oracle install
     - tgt: 'saltmaster*'
     - arg:
       - 'echo "[{{ data['id'] }}}][oracle started] Starting Oracle Install on $(date). ({{ tag }})" >> /tmp/salt.reactor.log'

tell_minion_to_install_software:
   local.state.sls:
     - name: tell minion to install software
     - tgt: {{ data['id'] }}
     - arg:
       - install_oracle
