postgresql:
  pkg.installed:
    - name: postgresql-server

run-init-postgresql:
  cmd.run:
    - cwd: /
    - user: root 
    - names:
      - postgresql-setup initdb
    - unless: stat /var/lib/pgsql/9.1/data/postgresql.conf
    - require:
      - pkg: postgresql-server

check_db_start:
  service.running:
    - name: postgresql
    - enable: True

connection_config:
  file.managed:
    - name: /etc/salt/minion
    - source: salt://database/connection_config

create_user:
  cmd.script:
    - name: create_user.sh
    - source: salt://database/create_user.sh