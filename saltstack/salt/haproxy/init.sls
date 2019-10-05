haproxy:
  pkg:
    - installed
  service.running:
    - watch:
      - pkg: haproxy
      - file: /etc/haproxy/haproxy.cfg

/etc/haproxy/haproxy.cfg:
  file.append:
   - text:

        frontend app-servers
            bind *:80
            default_backend apps

        backend apps
            server webserver1 192.168.50.12
            server webserver2 192.168.50.13

            backend apps
                server webserver1 192.168.50.12:80
                server webserver2 192.168.50.13:80

