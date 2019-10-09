postgresql:
  pkg.installed:
    - pkgs:
      - postgresql
      - postgresql-contrib
      - libpq-dev

#Make sure the mysql service is running and enable it to start at boot:
  service.running:
    - name: postgresql
    - enable: True





remove db if exists:
  cmd.run:
    - name: sudo -u postgres -H -i sh -c "psql -c 'DROP DATABASE IF EXISTS ds_database;'"



create db:
  cmd.run:
    - name: sudo -u postgres -H -i sh -c "psql -c 'CREATE DATABASE ds_database OWNER=postgres;'"



grant all privileges db:
  cmd.run:
    - name: sudo -u postgres -H -i sh -c "psql -c 'GRANT ALL PRIVILEGES ON DATABASE ds_database TO postgres;'"


change password pguser:
  cmd.run:
    - name: sudo -u postgres -H -i sh -c "psql -c 'ALTER USER ds_user PASSWORD '\'postgres\'';'"


append pg.conf:
  file.append:
    - name: /etc/postgresql/10/main/postgresql.conf
    - text: listen_addresses = '*'


append pg_hba.conf:
  file.append:
    - name: /etc/postgresql/10/main/pg_hba.conf
    - text: |
        host    all             all              0.0.0.0/0                       md5
        host    all             all              ::/0                            md5
        
restart pg service:
  cmd.run:
    - name: sudo /etc/init.d/postgresql restart