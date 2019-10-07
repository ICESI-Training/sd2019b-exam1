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
            server web1 192.168.50.221:4000
            server web2 192.168.50.222:4000

haproxy:
  cmd.run:
    - name: sudo systemctl restart haproxy