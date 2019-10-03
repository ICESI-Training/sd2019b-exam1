# install the web server package
apache2:
  pkg.installed:
    - name: apache2
  service.running:
    - enable: true

/var/www/html/index.html:
  file.managed:
    - template: jinja
    - source: salt://web/conf/index.html
#/var/www/html/index.json:
#  file.managed:
#    - template: jinja
#    - source: salt://web/conf/index.json
