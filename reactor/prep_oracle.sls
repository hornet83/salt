log_new_minion:
   local.cmd.run:
     - name: log new minion
     - tgt: 'saltmaster*'
     - arg:
       - 'echo "[{{ data['id'] }}}][minion started] A new Minion has (re)born on $(date). Say hello to him ({{ tag }})" >> /tmp/salt.reactor.log'


tell_minion_to_install_software:
   local.state.sls:
     - name: tell minion to install software
     - tgt: {{ data['id'] }}
     - arg:
       - prep_oracle
