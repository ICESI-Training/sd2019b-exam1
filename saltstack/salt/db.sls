wget:
  pkg:
    - installed
install_mysql:
  cmd.script:
    - name: mysql.sh
    - source: salt://mysql/mysql.sh
create_table:
  cmd.script:
    - name: createtable.sh
    - source: salt://mysql/createtable.sh
