log_new_minion:
   local.cmd.run:
     - name: log new minion
     - tgt: 'saltmaster*'
     - arg:
       - 'echo "[{{ data['id'] }}}][minion started] A new Jenkins Server is (re)born, preparing for Jenkins install! ({{ tag }})" >> /tmp/salt.reactor.log'


tell_minion_to_install_software:
   local.state.sls:
     - name: tell minion to install software
     - tgt: {{ data['id'] }}
     - arg:
       - prep_jenkins
