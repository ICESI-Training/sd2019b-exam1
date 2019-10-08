installNode:
  cmd.script:
    - name: installNode.sh
    - source: salt://installNode.sh

npm:
  pkg:
    - installed

nginx_s:
  pkg.installed:
    - name : nginx

check_nginx_start:
  service.running:
    - name : nginx
    - enable: True

copy_my_files:
  file.managed:
    - name: /usr/share/nginx/html/index.html
    - source: salt://index2.html
    - makedirs: True
    - force: True

/home/vagrant:
 files.recurse:
	- source: salt://Node1-WebServer-Express
    - include_empty: True
	
runService:
  cmd.script:
    - name: runService.sh
    - source: salt://runService.sh
	
