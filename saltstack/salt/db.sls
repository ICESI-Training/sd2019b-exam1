wget:
  pkg:
   - installed
install_mysql:
  cmd.script:
    - name: mysql.sh
    - source: salt://mysql/mysql.sh
copy_my_files:
  file.managed:
    - name: /home/vagrant/resetpassword.sh
    - source: salt://resetpassword.sh
    - makedirs: True
    - force: True
reset_password:
  cmd.script:
    - name: runb.sh
    - source: salt://mysql/runb.sh
create_table:
  cmd.script:
    - name: createtable.sh
    - source: salt://mysql/createtable.sh
