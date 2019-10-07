nginx_s:
  pkg.installed:
    - name : nginx

check_nginx_start:
  service.running:
    - name : nginx
    - enable: True
haproxy:
  pkg:
    - installed
