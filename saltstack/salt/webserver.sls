install_apache:
  pkg.installed:
    - name: httpd
    - name: php 
    - name: php-pgsql
  service.running:
    - name: httpd
    - enable: True

Deploy a simple web page:
  file.managed:
    - name: /var/www/html/index.php
    - contents: |
        <!doctype html>
        <html lang="en">
        <head>
        <meta charset="utf-8">
        <title>Web Server</title>
        </head>
        <body>
        <div>
        <h1>Hello! My Minion id is: {{ grains['id'] }}</h1>
        </div>
        <?php 
        $host = "192.168.50.14";
        $dbname = "db_distribuidos";
        $dbuser = "postgres";
        $userpass = "postgres";

        $con = pg_connect("host=$host
                          port=5432
                          dbname=$dbname
                          user=$dbuser
                          password=$userpass
                          ");


        if (!$con) {
                die('Could not connect');
        }
        else {
                echo ("Connected to local DB"); }?>

        </body>
        </html>

Restart service if configuration changes:
  service.running:
    - name: httpd
    - watch:
      - file: Deploy a simple web page

enable_db_connection:
  cmd.run:
    - user: root
    - name: setsebool -P httpd_can_network_connect_db 1
