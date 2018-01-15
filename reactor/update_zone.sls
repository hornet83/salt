log_zone_update:
   local.cmd.run:
     - name: log zone update
     - tgt: 'saltmaster*'
     - arg:
       - 'echo "[{{ data['id'] }}}][minion started] checking zone files to see if new entry is required $(date). ({{ tag }})" >> /tmp/salt.reactor.log'

tell_dnssever_to_update_zonefiles:
   local.state.sls:
     - name: tell dns server to update zone files
     - tgt: 'dns*'
     - arg:
       - manage_bind
