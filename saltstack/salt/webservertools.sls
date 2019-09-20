install_apache:
  pkg.installed:
    - name: httpd
  service.running:
    - name: httpd
    - enable: True
