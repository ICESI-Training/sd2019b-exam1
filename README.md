# Examen 1 - Sistemas Distribuidos
## Integrantes
- Jesús Paz - A00022240
- Felipe Cortez - A00077528
- Juan David Bolaños - A00077464

### Nota:
  Deben tener agregada la vagrant box llamada "centos/7"

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

##  Aprovisionamiento del balanceador

### Descripción:

Para el balanceador usamos haproxy. Para esto definimos en el balanceador las direcciones de los servidores web y el método de balanceo, que en este caso es Round-Robin. Luego, para evidenciar que todo está funcionando tenemos que acceder a la dirección ip del balanceador, como tenemos un identificador en cada web server, es decir, dice que servidor es cuando entra a la página, podemos observar que cada vez que entramos al balanceador, el resultado es un página con un servidor diferente.

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

### Solución de errores

Error: Minion did not return. [Not connected]

Desde el host correr:
~~~
  vagrant provision
~~~

Si al ejecutar el orchestration sale que la dirección por la que se correrá la app ya está ocupada, se debe matar el proceso en ambos web server
~~~
  vagrant ssh webServer1
  ps -ef | grep SCREEN  | awk '{print "sudo kill -9 " $2}' | bash
  exit
  vagrant ssh webServer2
  ps -ef | grep SCREEN  | awk '{print "sudo kill -9 " $2}' | bash
~~~


### Evidencias:

Lo primero es hacer un vagrant up para que se creen todas las máquinas virtuales.

![Alt text](images/VagrantUp.png?raw=true "Vagrant Up")



## Aprovisionamiento de los servidores web

### Descripción:

Para el aprovisionamiento de los servidores web se instaló apache, lo que nos permite tener un servidor para responder y procesar peticiones. Sobre este apache, estamos utilizando HTML y PHP, que nos permite procesar las solicitudes hechas por medio de la página web y hacer peticiones a la base de datos.   

### Procedimiento:

El siguiente comando (Ejecutado anteriormente), permite tanto la instalación de haproxy como en cada uno de los servidores web apache, PHP y las librerías de PHP necesarias para ejecutar consultas a una base de datos PostgreSQL. Por lo tanto, después de la ejecución de este comando los servidores quedan listos. Además, en el state, se creó una página con PHP que permite agregar y visualizar los valores en la base de datos.

~~~
  sudo su
  salt-run state.orch apache_orchestration
~~~

### Evidencias:


## Aprovisionamiento de la base de datos

### Descripción:

Para el aprovisionamiento de la base de datos, se creó un state que permite instalar postgresql en la máquina virtual llamada dataBase. Esto permite almacenar diferentes tipos de datos y que los servidores puedan consulta estos.

En ese state, también se ejecutan scripts, estos permiten la creación de la base de datos y de una tabla, en la cual vamos a agregar y a traer datos.

### Procedimiento:

Para ejecutar el state sobre la máquina que posee la base de datos debemos ejecutar:
~~~
  salt 'data*' state.apply
~~~
Este state posee la configuración para que PostgreSQL pueda funcionar, de la misma manera crea la base de datos y una tabla.

### Evidencias:


## Tareas de integración

### Descripción:
El trabajo se distribuyó de la siguiente manera:
  * Creación y despliegue de la infraestructura.
  * Creación de el balanceador de carga.
  * Creación del servidor web.
  * Creación de la base de datos.
  * Integración del servidor web con la base de datos.
 
Por lo tanto, la tarea de integración en este caso fue la conexión del web server con la base de datos. Debido a que los anteriores puntos ya fueron descritos anteriormente en este documento. Esta integración se puede apreciar en el anterior punto, ya que tenemos todo configurado para que desde nuestro servidor web poder acceder a la base de datos.

### Evidencias:

Al ejecutar todos los comandos y acceder a la dirección ip del balanceador obtenemos la siguiente página:

![Alt text](images/FinalPage.png?raw=true "Vagrant Up")

En esta página se puede llenar el formulario para agregar un nuevo dato, mientras en la parte de abajo podemos listar todos los datos que pertenecen a esta tabla.


## Problemas encontrados

  * Fue muy difícil realizar la configuración inicial de la infraestructura, ya que en cada momento se producían errores diferentes, lo que nos llevó a buscar cada uno de los errores que salían y solucionarlo. Por lo tanto, al ser una nueva tecnología para nosotros fue más complicado levantar toda la infraestructura.
 
  * En algunos momentos para realizar el aprovisionamiento, era difícil hacer un state de saltstack, ya que en muchas ocasiones teníamos bastantes errores y las cosas no funcionaban como queríamos.

  * En el momento de replicar la infraestructura en otra máquina diferente a la que se creó, se generaron múltiples problemas, lo que retrasó en gran parte la iniciación de la creación del web server.

