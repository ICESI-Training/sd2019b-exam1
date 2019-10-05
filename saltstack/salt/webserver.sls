install_apache:
  pkg.installed:
    - name: httpd
  service.running:
    - name: httpd
    - enable: True

install_screen:
  pkg.installed:
    - name: screen

install_python:
  cmd.script:
    - name: python.sh
    - source: salt://python/python.sh

install_flask:
  cmd.script:
    - name: flask.sh
    - source: salt://python/flask.sh

install_db_connection:
  cmd.script:
    - name: db_conn.sh
    - source: salt://python/db_conn.sh

web_project:
  file.recurse:
    - name: /home/vagrant/web
    - source: salt://web
        
Deploy a simple web page:
  file.managed:
    - name: /var/www/html/index.html
    - contents: |
        <!doctype html>
        <html lang="en">
        <head>
        <style>
        body {
        width: 100%; height: 100%; top: 0; left: 0;
        background: url(https://media.licdn.com/dms/image/C561BAQHk032ec5S2uQ/company-background_10000/0?e=2159024400&v=beta&t=2y7J65LrJZAPKuCEiRVc2XmP4Bh6IyWvAK409Y-hDm0) no-repeat center top; position: fixed; z-index: -1;
        -webkit-background-size: cover;
        -moz-background-size: cover;
        -o-background-size: cover;
        background-size: cover;
        }
        div {
            height: 200px;
            width: 400px;
            position: fixed;
            top: 20%;
            left: 50%;
            margin-top: -100px;
            margin-left: -200px;
        }
        </style>
        <meta charset="utf-8">
        <title>Congratulation</title>
        <link rel="icon" href="https://media.glassdoor.com/sqll/1166445/saltstack-squarelogo-1548910587917.png">
        <meta name="description" content="Demo">
        <meta name="author" content="Giandomenico Avelluto">
        </head>
        <body>
        <div align="center" style="display: block; text-align: center; color: crimson;">
        <h1>Hello! My Minion id is: {{ grains['id'] }} and actually my disk occupation is: {{ salt.disk.percent()['/'] }}</h1>
        </div>
        </body>
        </html>

Restart service if configuration changes:
  service.running:
    - name: httpd
    - watch:
      - file: Deploy a simple web page

run app in background:
  cmd.run:
    - name: screen -d -m python3 /home/vagrant/web/app.py