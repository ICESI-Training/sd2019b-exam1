install_postgresql:
  pkg.installed:
    - name: postgresql-server
    - name: postgresql-contrib
pgsql-data-dir:
  postgres_initdb.present:
    - name: /var/lib/pgsql/data
    - auth: password
    - user: postgres
    - password: strong_password
    - encoding: UTF8
    - locale: C
    - runas: postgres
check_db_start:
  service.running:
    - name: postgresql
    - enable: True
    