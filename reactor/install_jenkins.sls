log_jenkins_install:
   local.cmd.run:
     - name: log jenkins install
     - tgt: 'saltmaster*'
     - arg:
       - 'echo "[{{ data['id'] }}}][jenkins prep done] Starting Jenkins Install on $(date). ({{ tag }})" >> /tmp/salt.reactor.log'

tell_minion_to_install_software:
   local.state.sls:
     - name: tell minion to install software
     - tgt: {{ data['id'] }}
     - arg:
       - jenkins
