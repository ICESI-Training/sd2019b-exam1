install_apache:
  pkg.installed:
    - name: httpd
    #- name: php 
    #- name: php-pgsql
  service.running:
    - name: httpd
    - enable: True

install_php:
  cmd.script:
    - name: installphp.sh
    - source: salt://web/installphp.sh

Deploy a simple web page:
  file.managed:
    - name: /var/www/html/index.php
    - contents: |
        <!doctype html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="ie=edge">
            <title>Web Server</title>
        </head>

        <body>
        <div>
          <h1>Hello! My Minion id is: {{ grains['id'] }}</h1>
        </div>
        <div>
          <form action="insertdb.php" method="post">

              ID: <input type="text" name="cedula"><br>
              Name: <input type="text" name="nombre"><br>
              Last Name: <input type="text" name="apellido"><br>
              <input type="submit" name="button" value="Submit">
          </form>
        </div>
        <br>
        <div>
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
                            ") or die ("Could not connect to server\n");

          $query = "SELECT * FROM minions"; 
          echo "<table>";
          $rs = pg_query($con, $query) or die("Cannot execute query: $query\n");
          echo "<tr> <td> <strong> ID  </strong></td>  <td> <strong> Name </strong> </td>  <td> <strong> Last Name </strong> </td> </tr>";
          while ($row = pg_fetch_assoc($rs)) {
              echo "<tr>";
              echo "<td>".$row['cc'] ."</td> <td>".$row['nombre']."</td> <td>".$row['apellido']."</td>";
              echo "</tr>"; }
          echo "</table>";
          pg_close($con);?>
        </div>
        </body>
        </html>


Deploy insert php:
  file.managed:
    - name: /var/www/html/insertdb.php
    - contents: |
        <?php 
          $button="";
          $id="";
          $name="";
          $lastname="";

          if(isset($_POST['button'])){
              $button=$_POST['button'];
              $id=$_POST['cedula'];
              $name=$_POST['nombre'];
              $lastname=$_POST['apellido'];
          }
        
          if($button){
              $host = "192.168.50.14";
              $dbname = "db_distribuidos";
              $dbuser = "postgres";
              $userpass = "postgres";

              $con = pg_connect("host=$host
                                port=5432
                                dbname=$dbname
                                user=$dbuser
                                password=$userpass
                                ") or die ("Could not connect to server\n");

              $query = "INSERT INTO minions (cc, nombre, apellido) VALUES ('".$id."', '".$name."', '".$lastname."');"; 
              $rs = pg_query($con, $query) or die("Cannot execute query: $query\n");
                  
              pg_close($con);
              header("Location: index.php");
          }
        ?>


Restart service if configuration changes:
  service.running:
    - name: httpd
    - watch:
      - file: Deploy a simple web page
      - file: Deploy insert php

enable_db_connection:
  cmd.run:
    - user: root
    - name: setsebool -P httpd_can_network_connect_db 1
