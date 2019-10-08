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

connection_config:
  file.managed:
    - name: /etc/salt/minion
    - source: salt://database/connection_config

update_postgres_config1:
  file.append:
    - name: /var/lib/pgsql/data/postgresql.conf
    - text: listen_addresses = '*'

update_postgres_config2:
  file.append:
    - name: /var/lib/pgsql/data/pg_hba.conf
    - text: host    all    all    0.0.0.0/0    md5

update_postgres_config3:
  file.append:
    - name: /var/lib/pgsql/data/pg_hba.conf
    - text: host    all    all    ::/0    md5

create_db:
  cmd.script:
    - name: create_db.sh
    - source: salt://database/create_db.sh

create_table:
  cmd.script:
    - name: create_table.sh
    - source: salt://database/create_table.sh

check_db_start:
  service.running:
    - name: postgresql
    - enable: True
