install_node:
  cmd.script:
    - name: installNode.sh
    - source: salt://installNode.sh

nginx_s:
  pkg.installed:
    - name : nginx

check_nginx_start:
  service.running:
    - name : nginx
    - enable: True

/usr/share/nginx/html/index.html:
  file.managed:
    - source: salt://index2.html
    - makedirs: True
    - force: True

/home/vagrant/NodeServer:
  file.recurse:
    - source: salt://Node1-WebServer-Express
    - include_empty: True