wget:
  pkg:
   - installed
install_mysql:
  cmd.script:
    - name: mysql.sh
    - source: salt://mysql/mysql.sh
