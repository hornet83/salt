zone "{{ pillar['env']['domain'] }}" {
        type master;
        file "/etc/named/zones/db.{{ pillar['env']['domain'] }}";
};

{% set octets = pillar['env']['subnet'].split('.') %}
zone "{{ octets[2] }}.{{ octets[1] }}.{{ octets[0] }}.in-addr.arpa" {
        type master;
        file "/etc/named/zones/db.{{ octets[2] }}.{{ octets[1] }}.{{ octets[0] }}";
};
