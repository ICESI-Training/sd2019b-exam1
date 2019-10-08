postgresql:
  pkg.installed: 
    - pkg: postgresql

copy file:
  file.managed:
    - name: /home/vagrant/script1.sh
    - source: salt://script1.sh

Run myscript:
  cmd.run:
    - name: sudo sh /home/vagrant/script1.sh

/etc/postgresql/10/main/postgresql.conf:
  file.append:
    - text: |
        listen_addresses = '*'   

/etc/postgresql/10/main/pg_hba.conf:
  file.append:
    - text: |
        host    all             all             0.0.0.0/0               md5
        host    all             all             ::/0                    md5

restart postgres:
  cmd.run:
    - name: sudo systemctl restart postgresql
       