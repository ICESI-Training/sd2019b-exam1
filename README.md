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

Para ejecutar el estado sobre la Data Base
~~~
  salt 'data*' state.apply
~~~

Si en la terminal todo les sale correcto, quiere decir que ya todo quedó bien instalado. :)


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

## Aprovisionamiento de los servidores web

### Descripción:

Para el aprovisionamiento de los servidores web se instaló apache, lo que nos permite tener un servidor para responder y procesar peticiones. Sobre este apache, estamos utilizando la tecnología {{{INSERTAR TECNOLOGÍA}}}}}
, que nos permite procesar las solicitudes hechas por medio de la página web y hacer peticiones a la base de datos.   

### Procedimiento:


### Evidencias:


## Aprovisionamiento de la base de datos

### Descripción:

Para el aprovisionamiento de la base de datos, se creó un state que permite instalar postgresql en la máquina virtual llamada dataBase. Esto permite almacenar diferentes tipos de datos y que los servidores puedan consulta estos.

### Procedimiento:


### Evidencias:


## Tareas de integración


### Descripción:
El trabajo se distribuyó de la siguiente manera:
  * Creación y despliegue de la infraestructura.
  * Creación de el balanceador de carga.
  * Creación del servidor web.
  * Creación de la base de datos.
  * Integración del servidor web con la base de datos.
 
Por lo tanto, la tarea de integración en este caso fue la conexión del web server con la base de datos. Debido a que los anteriores puntos ya fueron descritos anteriormente en este documento.

### Evidencias:


## Problemas encontrados

  * Fue muy difícil realizar la configuración inicial de la infraestructura, ya que en cada momento se producían errores diferentes, lo que nos llevó a buscar cada uno de los errores que salían y solucionarlo. Por lo tanto, al ser una nueva tecnología para nosotros fue más complicado levantar toda la infraestructura.
 
  * En algunos momentos para realizar el aprovisionamiento, era difícil hacer un state de saltstack, ya que en muchas ocasiones teníamos bastantes errores y las cosas no funcionaban como queríamos.

  * En el momento de replicar la infraestructura en otra máquina diferente a la que se creó, se generaron múltiples problemas, lo que retrasó en gran parte la iniciación de la creación del web server.
