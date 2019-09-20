Install apache and make sure the apache service is running, and start in the boot:
  pkg.installed:
    - name: apache
  service.running:
    - name: apache
    - enable: True
