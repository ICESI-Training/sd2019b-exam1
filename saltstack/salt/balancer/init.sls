install haproxy:
  pkg.installed:
    - pkgs:
      - haproxy
      
      
/etc/haproxy/haproxy.cfg:
  file.append:
    - text: |
        frontend app_servers
            bind *:80
            default_backend apps

        backend apps
            mode http
            server web1 192.168.50.110:80 check
            server web2 192.168.50.120:80 check
haproxy:
  cmd.run:
    - name: sudo systemctl restart haproxy  
