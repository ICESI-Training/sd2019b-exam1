haproxy:
  pkg:
    - installed

copy_my_files:
  file.managed:
    - name: /etc/haproxy/haproxy.cfg
    - source: salt://haproxy.cfg
    - makedirs: True
    - force: True

restart haproxy:
  cmd.run:
    - name: sudo systemctl restart haproxy