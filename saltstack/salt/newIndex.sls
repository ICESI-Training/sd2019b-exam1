copy_my_files:
  file.managed:
    - name: /usr/share/nginx/html/index.html
    - source: salt://index.html
    - makedirs: True
    - force: True