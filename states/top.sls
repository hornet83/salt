### top.sls ###
base:        
   '*':       
       - common 

   '{{ pillar['env']['dnsserver1'] }}*':
       - manage_bind
