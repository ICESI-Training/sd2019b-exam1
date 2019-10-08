Install haproxy package:
  pkg.installed:
    - name: haproxy

Configure haproxy:
  file.managed:
    - name: /etc/haproxy/haproxy.cfg
    - contents: |
        global
            log 127.0.0.1 local0 notice
            maxconn 2000
            user haproxy
            group haproxy
        defaults
            log     global
            mode    http
            option  httplog
            option  dontlognull
            retries 3
            option redispatch
            timeout connect  5000
            timeout client  10000
            timeout server  10000
        frontend local
            bind *:80
            mode http
            default_backend servers
        backend servers
            mode http
            stats enable
            stats uri /haproxy?stats
            stats realm Strictly\ Private
            stats auth admin:admin
            balance roundrobin
            option httpclose
            option forwardfor
            {% for server, addr in salt['mine.get']('web*', 'network.ip_addrs').items() %}
            server {{ server }} {{ addr[0] }}:80 check
            {%- endfor %}

Start haproxy service:
  service.running:
    - name: haproxy
    - watch:
      - pkg: Install haproxy package
      - file: Configure haproxy
