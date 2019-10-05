# install the web server package
apache2:
  pkg.installed:
    - name: apache2
    - name: python3.6
    - name: libapache2-mod-wsgi-py3
    - name: python-dev
    - name: python-pip
    - name: python3-pip
  service.running:
    - enable: true
django:
  pip.installed:
    - name: django >= 1.6, <= 1.7
    - require:
      - pkg: python-pip
/var/www/html/index.html:
  file.managed:
    - template: jinja
    - source: salt://web1/conf/index.html
#/var/www/html/index.json:
#  file.managed:
#    - template: jinja
#    - source: salt://web/conf/index.json
