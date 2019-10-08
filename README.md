# Examen 1 - Sistemas Distribuidos
## Integrantes
- Jesús Paz - A00022240
- Felipe Cortés - A00077528
- Juan David Bolaños - A00077464

### Nota:
  Deben tener agregada la vagrant box llamada "centos/7"

## Direcciones IP de las máquinas (Actualmente fijas)

Máquina | Dirección IP
------- | ------------
Load Balancer | 192.168.50.11
Web Server 1 | 192.168.50.12
Web Server 2 | 192.168.50.13
Data Base | 192.168.50.14

## Configuración inicial

Deben ingresar los siguientes comandos:
1) Para clonar el repositorio:
~~~
  git clone https://github.com/JesusPaz/sd2019b-exam1.git
~~~
2) Entran a la carpeta raíz:
~~~
  cd sd2019b-exam1
~~~
3) Deben instalar:
~~~
  vagrant plugin install vagrant-vbguest
~~~
4) Ya tienen todo listo para iniciar las máquinas:
~~~
  vagrant up
~~~

### Evidencias:

![Alt text](images/VagrantUp.png?raw=true "Vagrant Up")

### Procedimiento:

Al terminar de hacer el vagrant up, deben de ingresar a la máquina master. Esta permite instalar todos los paquetes en el resto que máquinas (minions). Para esto deben ejecutar:
~~~
  vagrant ssh master
~~~
Para ver que todo se generó correctamente y que el master puede alcanzar a los minions deben ejecutar:
~~~
  salt '*' test.ping
~~~
Al entrar en la master deben ejecutar los siguientes comandos para instalar todas las dependencias relacionadas con el Load Balancer e instalar apache en los servidores web:
~~~
  sudo su
  salt-run state.orch apache_orchestration
~~~
Para obtener la dirección ip del Load Balancer ejecutan:
~~~
  salt loadBalancer network.ipaddrs eth1
~~~
Luego ingresan esa dirección a su navegador, recargan para ver la diferencia entre los servidores.

Para ejecutar el state sobre la máquina que posee la base de datos debemos ejecutar:
~~~
  salt 'data*' state.apply
~~~

Al ejecutar todos estos comandos debemos ingresar a la dirección , corresponde a la ip del balanceador de carga, por lo tanto alterna entre los dos servidores disponibles.

### Solución de posibles errores

Si al intentar instalar el plugin de Vagrant *vagrant-vbguest* sale un error relacionado a conflictos entre dependencias, como se puede ver en la siguiente imagen, puede ser debido a la versión de Vagrant, por tanto se debe instalar la versión 2.5.5.

![Alt text](images/error_plugin_vagrant.png?raw=true "Vagrant Up")

Tener en cuenta que el siguiente comando instala la versión adecuada de Vagrant en una máquina con sistema operativo Ubuntu.
~~~
  sudo wget https://releases.hashicorp.com/vagrant/2.2.5/vagrant_2.2.5_x86_64.deb
  sudo dpkg –i vagrant_2.2.5_x86_64.deb
~~~

Error: Minion did not return. [Not connected]

Desde el host correr:
~~~
  vagrant provision
~~~

Si al ejecutar el orchestration sale que la dirección por la que se correrá la app ya está ocupada, se debe matar el proceso en ambos servidores web.
~~~
  vagrant ssh webServer1
  ps -ef | grep SCREEN  | awk '{print "sudo kill -9 " $2}' | bash
  exit
  vagrant ssh webServer2
  ps -ef | grep SCREEN  | awk '{print "sudo kill -9 " $2}' | bash
~~~


##  Aprovisionamiento del balanceador

### Descripción:

Para el balanceador usamos haproxy. Para esto definimos en el balanceador las direcciones de los servidores web y el método de balanceo, que en este caso es **Round-Robin**, el cual consiste en distribuir la carga de manera equitativa en cada uno de los servidores web en el orden definido. Luego, para evidenciar que todo está funcionando tenemos que acceder a la dirección ip del balanceador, debido a que tenemos un identificador en cada web server, al ingresar a la página se muestra a qué servidor fue realizada la petición, podemos observar que cada vez que volvemos a entrar al balanceador, el resultado es un página con un servidor diferente.

### Evidencias:

Al ejecutar el comando 'salt-run state.orch apache_orchestration' dentro del master se aplican los estados necesarios al Load Balancer definidos en **haproxy.sls**.

![Alt text](images/loadbalancer_sls.png?raw=true "Vagrant Up")


## Aprovisionamiento de los servidores web

### Descripción:

Para el aprovisionamiento de los servidores web se instaló apache, lo que nos permite tener un servidor para responder y procesar peticiones. Sobre este apache, estamos utilizando HTML y PHP, que nos permite procesar las solicitudes hechas por medio de la página web y hacer peticiones a la base de datos.   

### Procedimiento:

El comando ejecutado anteriormente, permite tanto la instalación de haproxy en el Load Balancr y los paquetes necesarios en cada uno de los servidores web, como lo son Apache, PHP y las librerías de PHP necesarias para ejecutar consultas a una base de datos PostgreSQL. Por lo tanto, después de la ejecución de este comando los servidores quedan listos para ser accedidos y realizar peticiones. Además, en el state llamado **webserver.sls** se crea una página web con PHP que permite agregar y visualizar los valores en la base de datos.

### Evidencias:

Los resultados de la aplicación de los estados a los web servers se puede ver a continuación.

![Alt text](images/webserver_sls1.png?raw=true "Vagrant Up")

![Alt text](images/webserver_sls2.png?raw=true "Vagrant Up")


## Aprovisionamiento de la base de datos

### Descripción:

Para el aprovisionamiento de la base de datos, se creó un state que permite instalar postgresql en la máquina virtual llamada dataBase. Esto permite almacenar diferentes tipos de datos y que los servidores puedan consultar estos.

En ese state, también se ejecutan scripts, estos permiten establecer una configuración inicial, la creación de la base de datos *db_distribuidos* y de una tabla llamada *minions*, en la cual vamos a agregar datos y consultarlos.

CC (PK) | Nombre | Apellido
------- | ------ | --------
VARCHAR(30) | VARCHAR(30) | VARCHAR(30)

### Procedimiento:

Para ejecutar el state sobre la máquina que posee la base de datos debemos ejecutar:
~~~
  salt 'data*' state.apply
~~~

### Evidencias:

![Alt text](images/create_db.png?raw=true "Vagrant Up")

![Alt text](images/create_table.png?raw=true "Vagrant Up")

**Nota:**

> El estado *run-init-postgresql* solo se ejecutará con éxito la primera vez debido a que este se encarga de crear el diccionario de la base de datos y sus 
> archivos de configuración inicial, por tanto, de ahí en adelante cuando el estado se ejecute este fallará, sin embargo, esto no afecta el despliegue.


## Tareas de integración

### Descripción:
El trabajo se distribuyó de la siguiente manera:
  * Creación y despliegue de la infraestructura
    * Creación del Vagrantfile y asignación de las especificaciones de cada máquina
  * Creación de el balanceador de carga
    * Instalación de HAProxy
    * Creación del archivo haproxy.cfg
  * Creación del servidor web
    * Instalación de Apache (HTTP) y PHP
    * Instalación de paquetes que permitan la conexión a PostreSQL
    * Creación de la página web (Front-End)
    * Creación de la página web (Back-End)
  * Creación de la base de datos
    * Instalación y configuración de PostgreSQL
    * Creación de la base de datos y la tabla
    * Configuración del *postgresql.conf* y *pg_hba.conf*
  * Integración del balanceador de carga con los servidores web
  * Integración de los servidores web con la base de datos

 
Por lo tanto, la tarea de integración en este caso fue la configuración y conexión entre nodos. Esta integración se puede apreciar en los anteriores puntos, ya que se tiene todo configurado para que desde el balanceador de carga se distribuyan las peticiones a los servidores web y estos puedan acceder a la base de datos.

### Evidencias:

Al ejecutar todos los comandos y acceder a la dirección ip del balanceador obtenemos la siguiente página:

![Alt text](images/FinalPage.png?raw=true "Vagrant Up")

En esta página se puede llenar el formulario para agregar un nuevo dato, mientras en la parte de abajo podemos listar todos los datos que pertenecen a esta tabla.


## Problemas encontrados

  * Fue muy difícil realizar la configuración inicial de la infraestructura, ya que en cada momento se producían errores diferentes, lo que nos llevó a buscar cada uno de los errores que salían y solucionarlo. Por lo tanto, al ser una nueva tecnología para nosotros fue más complicado levantar toda la infraestructura, pese a que durante el curso se estudiaron herramientas y tecnologías con propósitos similares.
 
  * En algunos momentos para realizar el aprovisionamiento, fue difícil hacer states de saltstack, ya que en muchas ocasiones teníamos bastantes errores y las cosas no funcionaban como queríamos.

  * En el momento de replicar la infraestructura en otra máquina diferente a la que se creó, se generaron múltiples problemas, lo que retrasó en gran parte la iniciación de la creación del web server.

