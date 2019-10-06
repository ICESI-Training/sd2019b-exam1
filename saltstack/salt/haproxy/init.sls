haproxy:
  pkg:
    - installed
  service.running:
    - watch:
      - pkg: haproxy
      - file: /etc/haproxy/haproxy.cfg

/etc/haproxy/haproxy.cfg:
  file.managed:
   - text:
        global
            log /dev/log local0
            log /dev/log local1 notice
            chroot /var/lib/haproxy
            stats timeout 30s
            user haproxy
            group haproxy
            daemon

          defaults
            log global
            mode http
            option httplog
            option dontlognull
            timeout connect 5000
            timeout client 50000
            timeout server 50000

        frontend app-servers
            bind *:80
            mode http
            default_backend apps
            stats uri /haproxy?stats

        backend apps
            balance roundrobin
                
            server webserver1 192.168.50.12:80 check
            server webserver2 192.168.50.13:80 check




