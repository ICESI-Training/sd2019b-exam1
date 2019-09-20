Install mysql and make sure the mysql service is running, and start in the boot:
  pkg.installed:
    - name: mysql
  service.running:
    - name: mysql
    - enable: True
    