{% set serial = salt['cmd.run']('date +%Y%m%d%H') %}
@	IN  SOA {{ pillar['env']['dnsserver1'] }}.{{ pillar['env']['domain'] }}. root.{{ pillar['env']['domain'] }}. (
		{{ serial }}        ; serial
		604800     ; refresh (1 week)
		86400      ; retry (1 day)
		2419200    ; expire (4 weeks)
		604800     ; minimum (1 week)
		)


	IN	NS	{{ pillar['env']['dnsserver1'] }}.{{ pillar['env']['domain'] }}.
cluster.{{ pillar['env']['domain'] }}.	IN	A	{{ pillar['env']['clusterip'] }}
{% for server, addrs in salt['mine.get']('*', 'network.ip_addrs').items() %}{{ server }}.  IN      A       {{ addrs[0] }}
{% endfor %}
