node:
  pkg.installed:
    - pkgs:
      - nodejs
      - npm

copy webpage:
  file.recurse:
    - source: salt://DSMidterm
    - name: /home/vagrant/DSMidterm

Run myscript:
  cmd.run:
    - name: cd /home/vagrant/DSMidterm && npm install && screen -d -m nodejs index.js
