log_kube_install:
   local.cmd.run:
     - name: log artifactory install
     - tgt: 'saltmaster*'
     - arg:
       - 'echo "[{{ data['id'] }}}][kube server started] Starting Kube Install on $(date). ({{ tag }})" >> /tmp/salt.reactor.log'

tell_minion_to_install_kube:
   local.state.sls:
     - name: tell minion to install kube
     - tgt: {{ data['id'] }}
     - arg:
       - install_kube
