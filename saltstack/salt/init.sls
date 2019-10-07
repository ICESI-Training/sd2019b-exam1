haproxy:
  pkg:
    - installed
  service.running:
    - watch:
      - pkg: haproxy
      - file: /etc/haproxy/haproxy.cfg
      - file: /etc/default/haproxy
