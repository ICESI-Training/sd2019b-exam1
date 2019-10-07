# install the web server package
apache2:
  pkg.installed:
    - name: apache2
  service.running:
    - enable: true

python:
  pkg.installed:
    - pkgs:
      - python3.6
      - python3-pip


install_flask:
  cmd.run:
    - name: 'pip3 install flask flask_sqlalchemy flask_script flask_migrate psycopg2-binary'


/var/www/html/backend/models.py:
  file.managed:
    - source: salt://web/backend/models.py
    - makedirs: True

/var/www/html/backend/app.py:
  file.managed:
    - source: salt://web/backend/app.py
    - makedirs: True

/var/www/html/backend/manage.py:
  file.managed:
    - source: salt://web/backend/manage.py
    - makedirs: True


db init:
  cmd.run:
    - name: 'sudo python3  /var/www/html/backend/manage.py db init'

db migrate:
  cmd.run:
    - name: 'sudo python3  /var/www/html/backend/manage.py db migrate'

db upgrade:
  cmd.run:
    - name: 'sudo python3  /var/www/html/backend/manage.py db upgrade'

run_server:
  cmd.run:
    - name: 'sudo python3 /var/www/html/backend/app.py'


/var/www/html/templates/front.html:
  file.managed:
    - template: jinja
    - source: salt://web/backend/templates/front.html


/var/www/html/index.html:
  file.managed:
    - template: jinja
    - source: salt://web/conf/index.html

