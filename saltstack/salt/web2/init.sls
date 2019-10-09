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
      - libapache2-mod-wsgi-py3



install_flask:
  cmd.run:
    - name: '/usr/bin/pip3 install flask flask_sqlalchemy flask_script flask_migrate psycopg2-binary'







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


/var/www/html/backend/templates/front.html:
  file.managed:
    #- template: jinja
    - source: salt://web2/front.html
    - makedirs: True







#rm migrations:
 # cmd.run:
  #  - name: if [ -d /var/www/html/backend/models/ ] ; then rm -Rf /var/www/html/backend/models ; fi


#db init:
 # cmd.run:
  #  - name: 'python3  /var/www/html/backend/manage.py db init --directory /var/www/html/backend/models/migrations'

#db migrate:
#  cmd.run:
 #   - name: 'python3  /var/www/html/backend/manage.py db migrate --directory /var/www/html/backend/models/migrations'

#db upgrade:
#  cmd.run:
 #   - name: 'python3  /var/www/html/backend/manage.py db upgrade --directory /var/www/html/backend/models/migrations'


#flask-apache
/var/www/html/backend/app.wsgi:
  file.managed:
    - template: jinja
    - source: salt://web/conf/app.wsgi


/etc/apache2/sites-available/000-default.conf:
  file.managed:
    - template: jinja
    - source: salt://web2/ExampleFlask.conf


enable site:
  cmd.run:
    - name: sudo a2ensite ExampleFlask.conf

apache2 restart:
  cmd.run:
    - name: sudo systemctl restart apache2

