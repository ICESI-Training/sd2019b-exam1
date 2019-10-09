### Equipo de trabajo:
* Johnatan Garzón - A00333960
* Cristian Alejandro Morales - A00328064
* Juan Esteban Quinayás - A00027548

---

### Examen 1 - Enunciado
**Universidad Icesi**
**Curso:** Sistemas Distribuidos  
**Docente:** Daniel Barragán C.  
**Tema:** Automatización de infraestructura  
**Correo:** daniel.barragan@correo.icesi.edu.co

### Objetivos
* Realizar de forma autónoma el aprovisionamiento automático de infraestructura
* Diagnosticar y ejecutar de forma autónoma las acciones necesarias para lograr infraestructuras estables

### Tecnlogías sugeridas para el desarrollo del examen
* Vagrant
* Box del sistema operativo CentOS7
* Repositorio Github
* Saltstack

### Descripción
Deberá desplegar una plataforma que cumpla con los siguientes requerimientos:

* Debe tener un repositorio de Github que corresponda a un fork del repositorio **sd2019b-exam1**.
* El repositorio debe tener un Vagrantfile que permita el despliegue de cuatro máquinas virtuales que cumpliran las siguientes funciones:
  1. CentOS7 Load Balancer
  2. CentOS7 Webserver 1
  3. CentOS7 Webserver 2
  4. CentOS7 Database
* El aprovisionamiento se deberá realizar empleando la herramienta Saltstack de forma remota sobre las máquinas virtuales ya desplegadas con vagrant.
* El usuario desde la consola o navegador web realiza peticiones al balanceador **CentOS7 Load Balancer**
* El **CentOS7 Load Balancer** deberá redireccionar las peticiones entrantes hacia uno de los servidores web **CentOS7 Webserver 1** y **CentOS7 Webserver 2**. Incluir un mensaje que indique el servidor que responde la petición.
* Los servidores web deberán realizar peticiones para obtener información almacenada en la base de datos **CentOS7 Database**
* Solo existe un servidor de base de datos **CentOS7 Database**. Solo es necesario realizar consultas.
* Emplee tecnologías para frontend y backend diferentes a las empleadas en clase.

![Alt text](images/01_diagrama_despliegue.png?raw=true "")

### Actividades
1. Documento README.md en formato markdown:  
  * Formato markdown (5%).
  * Nombre y código del estudiante (5%).
  * Ortografía y redacción (5%).
2. Documentación del procedimiento para el aprovisionamiento del balanceador (10%). Evidencias del funcionamiento (5%).
3. Documentación del procedimiento para el aprovisionamiento de los servidores web (10%). Evidencias del funcionamiento (5%).
4. Documentación del procedimiento para el aprovisionamiento de la base de datos (10%). Evidencias del funcionamiento (5%).
5. Documentación de las tareas de integración (10%). Evidencias de la integración (10%).
6. El informe debe publicarse en un repositorio de github el cual debe ser un fork de https://github.com/ICESI-Training/sd2019b-exam1 y para la entrega deberá hacer un Pull Request (PR) al upstream (10%). Tenga en cuenta que el repositorio debe contener todos los archivos necesarios para el aprovisionamiento.
7. Documente algunos de los problemas encontrados y las acciones efectuadas para su solución al aprovisionar la infraestructura y aplicaciones (10%).

### Referencias
* https://docs.saltstack.com/en/latest/
* https://docs.saltstack.com/en/latest/ref/states/all/index.html

---

### Examen 1 - Desarrollo

[Introducción a formato Markdown][2]
[Guía de formato Markdown (Inglés)][3]
[Guía de formato Markdown (Español)][4]
[2]: https://www.genbeta.com/guia-de-inicio/que-es-markdown-para-que-sirve-y-como-usarlo
[3]: http://daringfireball.net/projects/markdown/syntax
[4]: http://joedicastro.com/pages/markdown.html

---

**1. Instalar Vagrant.**

Ingresmos al siguiente link:

https://www.vagrantup.com/docs/installation/

En la esquina superior derecha, seleccionamos la opción Download y después seleccionamos el instalador o paquete apropiado para nuestro sistema operativo (en este caso es Lubuntu 19.04).

Para validar la correcta instalación utilizamos el comando:

~~~
vagrant -v
~~~

**Nota:** Es muy importante que nos aseguremos que tenemos la última versión de vagrant, de lo contrario, traerá problemas más adelante.

Los computadores de la sala de redes tenían vagrant 2.2.3. Tocó desintalarlo e instalar vagrant 2.2.5.

---

**2. Instalar VirtualBox.**

Ingresamos al siguiente link:

https://vitux.com/how-to-install-virtualbox-on-ubuntu/

Agregamos un repositorio fuente y actualizamos el sistema.

~~~
sudo add-apt-repository multiverse && sudo apt-get update
~~~

Ahora instalamos VirtualBox con el comando.

~~~
sudo apt install virtualbox
~~~

Para abrirlo directamente desde la terminal se escribe:

~~~
virtualbox
~~~

---

**3. Instalar Saltstack**

Como base para el montaje con Saltstalk vamos a clonar el repositorio salt-vagrant-demo con el siguiente comando:

~~~
git clone https://github.com/UtahDave/salt-vagrant-demo
~~~

---

**4. Configuración Inicial**

Ingresamos en el Vagrantfile y seleccionamos como sistema operativo para las máquinas virtuales bento/ubuntu-18.04.

**Nota:** En un comienzo lo íbamos a hacer con centos/7, pero se nos demoraba entre 1 y 2 horas en aprovisionar. Mientras que con bento/ubuntu-18.04 se demora aproximadamente 20 minutos.

Para levantar las máquinas virtuales, se utiliza el siguiente comando:

~~~
vagrant up --provision
~~~

A veces sale un error que se puede solucionar con el siguiente comando:

~~~
vagrant plugin install vagrant-vbguest
~~~

Para comprobar que todos los minions están esuchando, ingresamos al master:

~~~
vagrant ssh master
sudo su
~~~

En el comando anterior el *master* es opcional, ya que por defecto se accede al master.

Ahora hacemos ping a los minions:

~~~
salt '*' test.ping
~~~

El resultado del comando se puede apreciar a continuación:

![Alt text](images/ssh_master_test_ping.PNG?raw=true "")

---

**5. Configuración inicial de los minions**

En nuestra arquitectura tenemos 5 máquinas virtuales:
* **Master** - *master* - como el nombre lo indica cumplirá el rol de master y a su vez de balanceador de carga. No hicimos el master por separado para ahorrarnos una máquina virtual. **IP:** 192.168.50.10. **RAM:** 512
* **Webserver 1** - *minionws1* - minion encargado de tener el Webserver 1. **IP:** 192.168.50.110. **RAM:** 512
* **Webserver 2** - *minionws2* - minion encargado de tener el Webserver 1. **IP:** 192.168.50.120. **RAM:** 512
* **Database** - *miniondb* - minion encargo de tener la base de datos. **IP:** 192.168.50.130. **RAM:** 512
* **Load Balancer** - *miniondb* - minion encargo de hacer las veces de balanceador de carga con los Webservers. **IP:** 192.168.50.140. **RAM:** 512

El archivo salt-vagrant-demo que copiamos venía con master, minion1 y minion2. Cada uno de ellos adicionalmente tenía un id con el mismo nombre y unas keys (pem y pub). Todas las referencias de minion1 se reemplazaron por minionws1 y las referencias de minion2 se reemplazaron por minionws2.

Para miniondb se copió la configuración de uno de los otros minions existentes y se reemplazaron las referencias por miniondb.

Para minionlb se copió la configuración de uno de los otros minions existentes y se reemplazaron las referencias por minionlb.

Para las keys, se aplicó por la terminal el comando:

~~~
ssh-keygen rsa
~~~

Sin embargo, a la hora de hacer el intercambio de keys entre el master y los minions, se producía un error. Como alternativa, un poco chambona, se nos ocurrió copiar el contenido de las keys de minionws2 y ponerlas en miniondb.pem y miniondb.pub según correspondiera, ¡así nos funcionó!

---

**6. Webserver 1 y 2**

Nos ubicamos en la carpeta *salt*, accedemos a al archivo *top.sls* y agregamos lo siguiente:

~~~
  'minionws1':
    - web
  'minionws2':
    - web2
~~~

El archivo *top.sls* queda de la siguiente manera:

~~~
base:
  'minionws1':
    - web
  'minionws2':
    - web2
~~~

Dentro de *top.sls* crear la carpeta *web*.

Nos ubicamos en *web* y creamos dos carpetas: *backend* y *conf*.

Nos ubicamos en *conf*.

Primero creamos el archivo *ExampleFlask.conf* y le agregamos el siguiente contenido:

~~~
<VirtualHost *:80>
     # Add machine's IP address (use ifconfig command)
     ServerName 192.168.50.110
     # Give an alias to to start your website url with
     WSGIScriptAlias / /var/www/html/backend/app.wsgi
     <Directory /var/www/html/backend/>
                # set permissions as per apache2.conf file
            Options FollowSymLinks
            AllowOverride None
            Require all granted
     </Directory>
     ErrorLog ${APACHE_LOG_DIR}/error.log
     LogLevel warn
     CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
~~~

Este archivo se encarga de:
* Especificar la dirección ip del servidor web.
* Realizar el acoplamiento entre Python y Apache utilizando el módulo wsgi y especificar la dirección de este archivo.
* Especificar los permisos del acceso a la página web.

Después creamos el archivo *app.wsgi* y le agregamos el siguiente contenido:

~~~
#! /usr/bin/python3.6

import logging
import sys
logging.basicConfig(stream=sys.stderr)
sys.path.insert(0, '/var/www/html/backend/')
from app import app as application
application.secret_key = 'ds4ever'
~~~

Este es el archivo del módulo wsgi que permite el acoplamiento entre Python y Apache.

Ahora nos ubicamos en *backend*.

Creamos el archivo *app.py*. El archivo principal del backend realizado con Python.
~~~
from flask import Flask, request, flash, render_template
from models import db
from models import User
from flask_sqlalchemy import SQLAlchemy
app = Flask(__name__)

POSTGRES = {
    'user': 'postgres',
    'pw': 'postgres',
    'db':'ds_database',
    'host': '192.168.50.130',
    'port': '5432',
}

app.config['DEBUG'] = True
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://postgres:postgres@192.168.50.130:5432/ds_database'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False # silence the deprecation warning
app.config['SECRET_KEY'] = 'ds4ever'
db.init_app(app)
api_url = '/api'

@app.route("/")
def home():
    return render_template("front.html")

@app.route(api_url+'/users', methods=['GET'])
def read_user():
       # return User.query.all()[0].name
        return render_template('front.html', users=User.query.all())

@app.route(api_url+'/users', methods=['POST'])
def create_user():
        user=User(request.form['id'], request.form['name'])
        db.session.add(user)
        db.session.commit()
        flash('Record was successfully added')
      #  return 'create one users'
        return render_template('front.html')

if __name__ == "__main__":
    app.run()
~~~

Creamos el archivo *manage.py*.

~~~
from flask_script import Manager
from flask_migrate import Migrate, MigrateCommand
from app import app, db

manager = Manager(app)
migrate = Migrate(app, db)
manager.add_command('db', MigrateCommand)

if __name__ == '__main__':
    manager.run()
~~~

Creamos el archivo *models.py*.

~~~
from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(80), unique=True, nullable=False)

    def __repr__(self):
        return '<User %r>' % self.name

    def __init__(self, id, name):
        self.id = id
        self.name = nam
~~~

Creamos la carpeta *templates* y dentro creamos el archivo *front.html*. Aquí se pone el código necesario para que el backend se pueda evidenciar de forma visual.

~~~
<html>

<head>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
</head>

<body>
    <h1>Distributed Systems Users</h1>
    <h4>Using machine: 192.168.50.110</h4>
<form method="POST" action="/api/users">
  <div class="form-group row">
    <label for="inputEmail3" class="col-sm-2 col-form-label">Id</label>
    <div class="col-sm-10">
      <input type="input" class="form-control" name="id" id="inputEmail3" placeholder="id">
    </div>
  </div>
  <div class="form-group row">
    <label for="inputEmail3" class="col-sm-2 col-form-label">Name</label>
    <div class="col-sm-10">
      <input type="input" class="form-control" name="name" id="inputEmail3" placeholder="Name">
    </div>
  </div>

  </div>
   <div class="form-group row">
    <div class="col-sm-10">
      <button type="submit" class="btn btn-primary">Add</button>
    </div>
  </div>

</form>

<h1>Users:</h1>
  <table class="table">
    <thead>
        <tr>
          <th scope="col">id</th>
          <th scope="col">Name</th>

        </tr>
      </thead>
      <tbody>
          {% for user in users %}
          <tr>
              <td>{{user.id}}</td>
              <td>{{user.name}}</td>
          </tr>
          {% endfor %}
    </tbody>
  </table>
  <form method="GET" action="/api/users">
    <button type="submit" class="btn btn-primary">Show results</button>
  </form>
</body>

</html>
~~~

![Alt text](images/webserver1.jpeg?raw=true "")

Nos ubicamos en *web2*.

Creamos el archivo *ExampleFlask.conf*. Esta es una copia del creado en *web* ya que entre los webservers solo cambia la dirección IP.

~~~
<VirtualHost *:80>
     # Add machine's IP address (use ifconfig command)
     ServerName 192.168.50.120
     # Give an alias to to start your website url with
     WSGIScriptAlias / /var/www/html/backend/app.wsgi
     <Directory /var/www/html/backend/>
                # set permissions as per apache2.conf file
            Options FollowSymLinks
            AllowOverride None
            Require all granted
     </Directory>
     ErrorLog ${APACHE_LOG_DIR}/error.log
     LogLevel warn
     CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost
~~~

Creamos el archivo *front.html*. Esta es una copia del creado en *web* ya que entre los webservers solo cambia la dirección IP.

~~~
<html>

<head>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
</head>

<body>
    <h1>Distributed Systems Users</h1>
    <h4>Using machine: 192.168.50.120</h4>
<form method="POST" action="/api/users">
  <div class="form-group row">
    <label for="inputEmail3" class="col-sm-2 col-form-label">Id</label>
    <div class="col-sm-10">
      <input type="input" class="form-control" name="id" id="inputEmail3" placeholder="id">
    </div>
  </div>
  <div class="form-group row">
    <label for="inputEmail3" class="col-sm-2 col-form-label">Name</label>
    <div class="col-sm-10">
      <input type="input" class="form-control" name="name" id="inputEmail3" placeholder="Name">
    </div>
  </div>

  </div>
   <div class="form-group row">
    <div class="col-sm-10">
      <button type="submit" class="btn btn-primary">Add</button>
    </div>
  </div>
</form>

<h1>Users:</h1>
<table class="table">

    <thead>
        <tr>
          <th scope="col">id</th>
          <th scope="col">Name</th>
        </tr>
    </thead>
    <tbody>
          {% for user in users %}
          <tr>
              <td>{{user.id}}</td>
              <td>{{user.name}}</td>
          </tr>
          {% endfor %}
    </tbody>
  </table>

  <form method="GET" action="/api/users">
    <button type="submit" class="btn btn-primary">Show results</button>
  </form>
</body>

</html>
~~~

Creamos el archivo *init.sls*. Aquí instalamos los paquetes Apache2 (el servidor web), y dejamos el servicio funcionando. Después, instalamos las dependencias necesarias para el funcionamiento del backend con Python, para lo cual instalamos Python3.6 y el instalador de paquetes de Python pip para poder instalar el framework Flask. Además se instala el módulo WSGI como complemento de Python3 para la integración de Apache con Python

~~~
# install the web server package
apache2:
  pkg.installed:
    - name: apache2
  service.running:
    - enable: true

python:
  pkg.installed:
    - pkgs:
      - python3.6
      - python3-pip
      - libapache2-mod-wsgi-py3

install_flask:
  cmd.run:
    - name: '/usr/bin/pip3 install flask flask_sqlalchemy flask_script flask_migrate psycopg2-binary'

/var/www/html/backend/models.py:
  file.managed:
    - source: salt://web/backend/models.py
    - makedirs: True

/var/www/html/backend/app.py:
  file.managed:
    - source: salt://web/backend/app.py
    - makedirs: True

/var/www/html/backend/manage.py:
  file.managed:
    - source: salt://web/backend/manage.py
    - makedirs: True

/var/www/html/backend/templates/front.html:
  file.managed:
    #- template: jinja
    - source: salt://web2/front.html
    - makedirs: True

rm migrations:
  cmd.run:
    - name: if [ -d /var/www/html/backend/models/ ] ; then rm -Rf /var/www/html/backend/models ; fi

db init:
  cmd.run:
    - name: 'python3  /var/www/html/backend/manage.py db init --directory /var/www/html/backend/models/migrations'

db migrate:
  cmd.run:
    - name: 'python3  /var/www/html/backend/manage.py db migrate --directory /var/www/html/backend/models/migrations'

db upgrade:
  cmd.run:
    - name: 'python3  /var/www/html/backend/manage.py db upgrade --directory /var/www/html/backend/models/migrations'

#run_server:
 # cmd.run:
 #   - name: 'python3 /var/www/html/backend/app.py '

#flask-apache
/var/www/html/backend/app.wsgi:
  file.managed:
    - template: jinja
    - source: salt://web/conf/app.wsgi

/etc/apache2/sites-available/ExampleFlask.conf:
  file.managed:
    - template: jinja
    - source: salt://web2/ExampleFlask.conf

enable site:
  cmd.run:
    - name: sudo a2ensite ExampleFlask.conf

apache2 restart:
  cmd.run:
    - name: sudo systemctl restart apache2
~~~

A continuación se muestra el correcto funcionamiento del webserver2.

![Alt text](images/webserver2.jpeg?raw=true "")

*Nota:* Salió un error al aprovisionar ambos webserver. Al subir el webserver1 se hace unas migraciones, es decir, se crea la tabla de los usuarios donde se va a guardar toda la información, y cuando se subía el webserver2 esas migraciones ya estaban hechas y por eso fallaba. Se hizo la modificación para que al aprovisionar el webserver2 no se volviera a hacer la migración.

**7. Load Balancer**

En el montaje del balanceador de carga se implementó el software de código abierto *haproxy*.

Nos ubicamos en la carpeta *salt*, accedemos a al archivo *top.sls* y agregamos lo siguiente:

~~~
  'minionlb':
    - balancer
~~~

El archivo *top.sls* queda de la siguiente manera:

~~~
base:
  'minionws1':
    - web
  'minionws2':
    - web2
  'minionlb':
    - balancer
~~~

Nos ubicamos en la carpeta *balancer* y creamos el archivo *init.sls* con el siguiente contenido:

~~~
install haproxy:
  pkg.installed:
    - pkgs:
      - haproxy
/etc/haproxy/haproxy.cfg:
  file.append:
    - text: |
        frontend app_servers
            bind *:80
            default_backend apps

        backend apps
            mode http
            server web1 192.168.50.110:80 check
            server web2 192.168.50.120:80 check
haproxy:
  cmd.run:
    - name: sudo systemctl restart haproxy  

~~~

Este archivo se encarga de instalar el paquete haproxy. Este cuando es instalado crea sus archivos de configuración en la ruta /etc/haproxy/, dentro de esta carpeta se encuentra el archivo de configuración para el balanceador con nombre haproxy.cfg.

En haproxy.cfg es donde se agrega la configuración para el funcionamiento. Aquí se le indica que las peticiones las va a escuchar por el puerto 80. En el módulo backend, se configura el protocolo de las peticiones que va a recibir, en este caso, http. Se especifica las direcciones IP y el puerto de los dos servidores web atenderán las solicitudes web. Finalmente, una vez modificado este archivo para que los cambios tomen efecto se restaura el servicio con el comando “systemctl restart haproxy”.

A continuación podemos apreciar que el balanceador hace referencia al webserver1.

![Alt text](images/loadbalancer2.png?raw=true "")

Y en el momento de refrescar la página, el balanceador hace referencia al webserver2.

![Alt text](images/loadbalancer1.png?raw=true "")

**Nota:** El balanceador de carga funciona ahora correctamente. Anteriormente había un problema porque existía un archivo llamado 000-default.conf que apuntaba también al puerto 80, y haproxy usaba este archivo en vez de ExampleFlask.conf, se solucionó sobreescribiendo el archivo por defecto con los datos que requeríamos para la aplicación desarrollada.

**8. Database**

Nos ubicamos en la carpeta *salt*, accedemos a al archivo *top.sls* y agregamos lo siguiente:

~~~
  'miniondb':
    - balancer
~~~

El archivo *top.sls* queda de la siguiente manera:

~~~
base:
  'minionws1':
    - web
  'minionws2':
    - web2
  'minionlb':
    - balancer
  'miniondb':
    - database
~~~

Como base de datos utilizamos PostgreSQL.

Creamos la carpeta *database*. Dentro, creamos el archivo *init.sls* y le agregamos el contenido:
~~~
include:
  - database.packages
~~~
Luego creamos el archivo *packages.sls*, también dentro de la carpeta *database*, y adicionamos la configuración.

Lo primero que se hace es la instalación de las dependencias que se necesitan.
~~~
postgresql:
  pkg.installed:
    - pkgs:
      - postgresql
      - postgresql-contrib
      - libpq-dev
~~~
Segundo, nos aseguramos de que el servicio PostgreSQL se esté ejecutando y lo habilitamos para que se inicie al arrancar.
~~~
#Make sure the postgresql service is running and enable it to start at boot:
  service.running:
    - name: postgresql
    - enable: True
~~~
Tercero, validamos si existe o no una base de datos, y en caso de que exista, la borramos.
~~~
remove db if exists:
  cmd.run:
    - name: sudo -u postgres -H -i sh -c "psql -c 'DROP DATABASE IF EXISTS ds_database;'"
~~~
Cuarto, creamos la base de datos y ponemos como dueño al usuario postgres (usuario que se crea por defecto).
~~~
create db:
  cmd.run:
    - name: sudo -u postgres -H -i sh -c "psql -c 'CREATE DATABASE ds_database OWNER=postgres;'"
~~~
Quinto, le damos todos los privilegios al usuario postgres para que pueda hacer "lo que quiera" con la base de datos.
~~~
grant all privileges db:
  cmd.run:
    - name: sudo -u postgres -H -i sh -c "psql -c 'GRANT ALL PRIVILEGES ON DATABASE ds_database TO postgres;'"
~~~
Sexto, cambiamos la contraseña del usuario porque habían unos problemas (acceder desde la aplicación a la base de datos).
~~~
change password pguser:
  cmd.run:
    - name: sudo -u postgres -H -i sh -c "psql -c 'ALTER USER ds_user PASSWORD '\'postgres\'';'"
~~~
Séptimo, brindamos permiso para que la base de datos pueda escuchar todas las direcciones.
~~~
append pg.conf:
  file.append:
    - name: /etc/postgresql/10/main/postgresql.conf
    - text: listen_addresses = '*'
~~~
Octavo, brindamos permiso a todos los host para aceder al puerto 5432 (puerto por default de postgres).
~~~
append pg_hba.conf:
  file.append:
    - name: /etc/postgresql/10/main/pg_hba.conf
    - text: |
        host    all             all              0.0.0.0/0                       md5
        host    all             all              ::/0                            md5
~~~~
Finalmente, reiniciamos el servicio de PostgreSQL para que se apliquen los cambios.
~~~
restart pg service:
  cmd.run:
    - name: sudo /etc/init.d/postgresql restart
~~~

**Nota:** No encontramos módulos de postgres para crear la base de datos, ni cambiar la contraseña. Por tal motivo, recurrimos a usar scripts.

**9. Aprovisionamiento.**

Aquí podemos observar que el aprovisionamiento de cada minion se realizó con éxito.

*minionws1*

![Alt text](images/state_apply_minionws1.jpeg?raw=true "")

*minionws2*

![Alt text](images/state_apply_minionws2.jpeg?raw=true "")

*minionlb*

![Alt text](images/state_apply_minionlb.PNG?raw=true "")

*miniondb*

![Alt text](images/state_apply_miniondb.jpeg?raw=true "")

**10. Tareas de integración**

|         Tarea       | Desarrollador |
| ------------------- | ------------- |
|Instalar Vagrant     | Todos         |
|Instalar VirtualBox  | Todos         |
|Instalar Saltstack   | Todos         |
|Editar Vagrantfile   | Todos         |
|Webservers           | Juan Esteban  |
|Load Balancer        | Cristian      |
|Database             | Johnatan      |

**11. Referencias**

Entre nuestras referencias bibliográficas se encuentran:

https://www.genbeta.com/guia-de-inicio/que-es-markdown-para-que-sirve-y-como-usarlo
http://daringfireball.net/projects/markdown/syntax
http://joedicastro.com/pages/markdown.html
https://www.vagrantup.com/docs/installation/
https://vitux.com/how-to-install-virtualbox-on-ubuntu/
https://github.com/UtahDave/salt-vagrant-demo
https://github.com/saltstack-formulas/apache-formula
https://github.com/salt-formulas/salt-formula-haproxy
https://www.linode.com/docs/applications/configuration-management/configure-apache-with-salt-stack/
https://github.com/salt-formulas/salt-formula-postgresql
http://philipmcclarence.com/setting-up-a-postgres-test-cluster-in-vagrant/
https://www.codementor.io/abhishake/minimal-apache-configuration-for-deploying-a-flask-app-ubuntu-18-04-phu50a7ft
https://galaxydatatech.com/2018/03/31/passing-data-html-page/
