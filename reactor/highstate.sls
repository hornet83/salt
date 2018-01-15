log_high_state:
   local.cmd.run:
     - name: log high state
     - tgt: 'saltmaster*'
     - arg:
       - 'echo "[{{ data['id'] }}}][server started] applying highstate $(date). ({{ tag }})" >> /tmp/salt.reactor.log'

apply highstate:
   local.state.apply:
      - tgt: {{ data['id'] }} 
