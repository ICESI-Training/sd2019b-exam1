# Parcial 2019

## Integrantes
- Sandra Mishale Niño Arbeláez- A00022220
- Johan Camilo Diaz - 
- Sebastian Calero - A00065884

Este repositorio contiene la implementación de una infraestructura que corresponde a:
- Un balanceador de carga.
- Dos servidores web
- Una base de datos

Para mayor claridad se muestran a continuación las tecnologías e instrucciones utilizados para lograr esta implementacion.

## 1. Vagrant
Esta herramienta nos permite desplegar arquitecturas completas, a través del uso de un lenguaje declarativo, mediante el cual especificamos requerimientos de hardware y software que queremos en nuestro sistema.
## 2. Salt-Stack
Esta herramienta nos permite realizar múltiples operaciones de gestión y orquestación en sistemas on-premises, híbridos, en la nube y sistemas IoT. Para este ejercicio se utilizó esta herramienta para el aprovisionamiento de las máquinas que hacen parte de esta infraestructura, de manera automática en cada uno.
## 3. Vagrantfile

En la figura 1 se muestra la configuración básica del entorno Vagrant, que contiene lo siguiente:

- **Sistema Operativo:** Se define la plataforma que se va a instalar en cada una de las máquinas que estarán presentes en este entorno. En este caso es Ubuntu 18.04.
- **Dirección IP:** Esta es la dirección IP que se va a manejar en el entorno virtual.
- **Máquinas:** Aquí se especifican los parámetros de hardware de las máquinas que harán parte de este sistema:
   - Dirección IP
   - CPU
   - Memoria RAM
_imagen_


Puesto que en esta infraestructura se utilizó el protocolo maestro esclavo, donde el servidor maestro se encarga de distribuir la información a sus esclavos. En la figura 2 se muestra la configuración del servidor maestro:
_imagen_

Para la configuración de los esclavos (minions), se tiene el siguiente fragmento establecido en el Vagrant File como se muestra en la Figura 3. Como primer paso se configura el hardware que va a tener cada uno de los minions de esta infraestructura, lo siguiente es indicar a los minions el sistema operativo, su nombre de host y una dirección IP que hace parte de la red que se estableció para este entorno. Por último, se establece el punto de partida para el aprovisionamiento de los minions a traves Salt-Stack, una aplicacion que se describira en la sección siguiente de este documento.
_imagen_

## 4. Aprovisionamiento del balanceador de carga
La tecnología a utilizar para el balanceador de carga fue haproxy. Haproxy es un proxy inverso que distribuye el tráfico de red o de una aplicación a varios servidores.
Para el aprovisionamiento del balanceador de cargas se tuvo en cuenta lo siguiente:
- Se instala el paquete haproxy.
- Se añade al final del archivo haproxy.cfg la configuración del balanceador de carga, que consiste en definir en el **frontend** el puerto por el cual el el balanceador de cargas recibirá las peticiones y definir en el **backend** los servidores a los cuales se van a redireccionar las peticiones. 
- Finalmente se reinicia el servicio de haproxy para que se cargue la configuración.
_imagen_

## 5. Aprovisionamiento de los servidores web
Las tecnologías que se utilizaron en la aplicación realizada para los servidores web fueron Node.js y npm. Node.js es es un entorno JavaScript de lado de servidor que utiliza un modelo asíncrono y dirigido por eventos. Npm es un manejador de paquetes. 

La aplicación que se realizó en Nodejs se utilizaron las siguientes dependencias:  
- body-parser
- dotenv
- ejs
- express
- pg
- os

Para el aprovisionamiento de los servidores web se tuvo en cuenta lo siguiente:

1. Como la aplicación está realizada en Nodejs y utiliza npm para sus comandos de ejecución. Se deben instalar los paquetes respectivos: nodejs y npm. 
Lo anterior se logra utilizando el módulo de saltstack **pkg.installed**, que permite instalar los paquetes de la lista llamada **pkgs**.  
_imagen_
2. Ahora se debe copiar el proyecto realizado en Nodejs llamado DSMidterm de nuestro ambiente local a la máquina virtual del servidor web. 
Lo anterior se logra utilizando el módulo de saltstack **file.recurse**, el cual nos solicita la fuente(source) de donde se va a copiar el proyecto, el cual se encuentra en la carpeta de salt del proyecto de saltstack, y a donde lo vamos a pegar en nuestra máquina virtual, en este caso será en la dirección **/home/vagrant/DSMidterm**
_imagen_
3. Luego de que tenemos copiado nuestro proyecto en la máquina virtual debemos instalar las dependencias mencionadas anteriormente que utiliza el proyecto de nodejs, esto se realiza con el comando npm install. Posteriormente debemos ejecutar el comando nodejs index.js el cual permite levantar el servidor y que se escuche por el puerto 4000(definido dentro de la aplicación) para que se ejecute la aplicación como tal. En la sección 8 se describirá por qué se utiliza el comando screen -d -m para ejecutar nodejs index.js 
Todo lo anterior se realiza gracias al módulo de saltstack llamado **cmd.run** el cual permite ejecutar comandos de shell 
_imagen_

Los comandos que se describieron en esta sección están en el archivo **node.sls**, los cuales serán restringidos al aprovisionamiento de los servidores web con el archivo top.sls que será explicado más adelante.

## 6. Aprovisionamiento de la base de datos
La tecnología a utilizar para la base de datos fue postgresql. Postgresql es es un sistema de gestión de bases de datos relacional orientado a objetos y de código abierto.
Para el aprovisionamiento de la base de datos tuvo en cuenta lo siguiente:

1. Se debe instalar la tecnología postgresql en la máquina.  Esto se efectua utilizando el modulo de saltstack llamado **pkg.installed**, el cual instala el paquete de postgresql para poder ser utilizado en la máquina. 
_imagen_
2. Creamos un script que tendrá los comandos para crear la base de datos y la tabla para realizar la creación y consultas a la base de datos. Por ende, debemos copiar el script de nuestro ambiente local al de la máquina virtual. En este caso como es un archivo no utilizamos file.recurse sino **file.managed**. El cual nos solicita la fuente(source) donde se encuentra el archivo y el lugar en la máquina virtual donde se debe copiar, esto es **/home/vagrant/script1.sh**
_imagen_
3. Cuando el archivo ya está copiado en la máquina virtual, ejecutamos el script con el módulo de saltstack **cmd.run.** 
_imagen_
El script1 contiene lo siguiente:

_imagen_
- Todos los comandos ejecutados son con el usuario postgres, el cual es el usuario por defecto cuando se instala postgres, y todos los comandos se ejecutan en el SQL Shell (psql). 
- La línea 3 se encarga de crear la base de datos, la cual se llama pg_ds.
- La línea 5 se encarga de conectarse a la base de datos previamente creada. 
- La línea 7 se encarga de crear la tabla persona en la base de datos previamente creada. 
- La línea 13 es para modificar la contraseña del usuario postgres, puesto que al intentar contraseñas como postgres, password, admin o vacío no coincidían al realizar la conexión desde la aplicación. 

4. Luego por problemas que se presentaron en la prueba de aprovisionamiento, los cuales se especificarán en la sección 8, se deben realizar cambios en archivos de configuración de postgres. En el **postgresql.conf** se debe adicionar la línea de **listen_addresses = '*'**, puesto que por defecto la dirección ip que escucha por default es localhost. 
Lo anterior se realiza con el módulo de saltstack llamado **file.append.** La primera línea hace referencia al archivo que se desea modificar, la segunda línea hace referencia a que se va a adicionar líneas al final del archivo, y lo siguiente hace referencia al texto/líneas que se desean agregar.
_imagen_

5. Siguiendo con el punto anterior, el otro archivo de configuración de postgresql que se debe modificar es el **pg_hba.conf.** En este archivo se realiza el mismo procedimiento del anterior, solo que se cambia lo que se va a adicionar al final del archivo.
_imagen_

6. Debido a que hemos realizado dos cambios en los archivos de configuración de postgresql debemos reiniciar (restart) el servicio de postgresql. En Ubuntu se realiza con el comando **sudo systemctl restart postgresql**. Esto es posible gracias al módulo de saltstack llamado **cmd.run**, el cual permite ejecutar el comando mencionado anteriormente. 
_imagen_

Los comandos que se describieron en esta sección están en el archivo **postgres.sls**, los cuales serán restringidos al aprovisionamiento de la base de datos con el archivo top.sls que será explicado más adelante. 


## 7. Integración
En el archivo **top.sls** se definió que estados se iban a aplicar en las diferentes máquinas, en este caso el estado node, que hace referencia a lo que está en el archivo node.sls,  se aplicará sobre las maquinas web-1 y web-2, es decir, los web servers. El estado postgres, que hace referencia a lo que está en el archivo postgres.sls, se aplicará sobre la máquina database, y el estado haproxy, que hace referencia a lo que está en el archivo haproxy.sls, se aplicará en la máquina load-balancer.
_imagen_

A la hora de aplicar los estados desde la máquina master con el comando salt ‘nombre-máquina’ state.apply  se debe aplicar primero sobre la máquina database debido a que si se lanzan primero los servicios web y después database, los servidores web dejan se caen debido a un cambio que se realiza en los archivos de configuración de postgres.

Los comandos que se deben ejecutar para el aprovisionamiento son:
1. Dirigirse a la carpeta sd2019b-exam1 y ejecutar el comando `vagrant up`
_imagen_
2. Ejecutar el comando `vagrant ssh master`
_imagen_
3. Ejecutar el comando `sudo su`, para tener permisos como root 
_imagen_
4. Si se desean listar las llaves de los minions se ejecuta el comando `salt-key --L`
_imagen_
5. Para aceptar las llaves, se ejecuta el comando `salt-key --accept-all`
_imagen_
Si ejecutamos el comando del punto 4, confirmamos que estarán aceptadas.
6. Ejecutamos el comando para aprovisionar la base de datos, `salt 'database' state.apply`
_imagen_
7. Ejecutamos el comando para aprovisionar el balanceador de carga, `salt 'load-balancer' state.apply`
_imagen_
8. Ejecutamos el comando para aprovisionar los servidores web, `salt 'web*' state.apply`
_imagen_
9. Podemos entrar a la dirección en el navegador 192.168.50.220
_imagen_
10. Podemos agregar un registro nuevo llenando todos los campos y dando click en el botón **“Add new register”**. Aparecerá el siguiente mensaje: "The user was succesfully created."
_imagen_
11. Podemos intentar crear un registro con el mismo id del punto anterior y no nos dejará crearlo. Aparecerá el siguiente mensaje: "A user with the given id is already created. Try again!"
_imagen_
12. Ahora podemos buscar el registro con el id que digitamos anteriormente. Damos click en el botón **“Search”**
_imagen_

Podemos recargar la página y veremos como cambian las direcciones IP haciendo referencia a que el balanceador de carga efectivamente funciona :) 


## 8. Problemas encontrados y acciones efectuadas
Los problemas encontrados para la solución de aprovisionar la infraestructura y aplicaciones fue la siguiente:
 
- Se deben generar llaves para cada minion, por ende se ejecuto el comando
ssh-keygen -t rsa -b 4096 -C “email@example.com”. Sin embargo, cuando se extrajeron los archivos en donde se guardaban el par de llaves (pública y privada) y se asignaban a los dos minions faltantes no se aceptaban las llaves. Por ende, con discusión con el profesor Juan Manuel, se permitió copiar las dos llaves que traía el tutorial de saltstack a los dos minions faltantes. 
- Hubo dificultades para automatizar el comando nodejs index.js, puesto que, de lo contrario, quien fuera a utilizar el proyecto debería hacer por ejemplo,  vagrant ssh web1, pararse en donde está el proyecto DSMidterm y ejecutar el comando nodejs index.js.
Al querer aprovisionar cuando se realizaba salt 'web*' state.apply se quedaba escuchando el primer webserver que ejecutará el comando y el otro no realizaba su aprovisionamiento, por ende, encontramos el comando para abrir una nueva consola donde se pudiera correr los comandos para cada servidor y que ambos se aprovisionaran y quedaran escuchando por el puerto 4000. 
El comando encontrado fue el siguiente **screen -d -m nodejs index.js.** 
- Al realizar la prueba de conexión desde un web server con la base de datos, aparecia el siguiente error:  
could not connect to postgres { [Error: connect ECONNREFUSED] code: 'ECONNREFUSED', errno: 'ECONNREFUSED', syscall: 'connect' }
Por tanto, haciendo una pequeña búsqueda del error, encontramos que se deben realizar cambios en los archivos de configuración de postgresql. 

El primer archivo que se debe cambiar es el de postgresql.conf. En este se debe cambiar las direcciones ip por las que se puede escuchar, puesto que por defecto es localhost. Se realiza con este cambio: listen_addresses = '*' 

El segundo archivo que se debe cambiar es el de pg_hba.conf agregando lo siguiente:  Al final se reinicia el servicio de postgresql para que cojan los cambios. 

host    all             all              0.0.0.0/0           md5
host    all             all              ::/0                md5

	Al final se reinicia el servicio de postgresql para que cojan los cambios. 
- Luego de resolver el error del punto anterior, salía el siguiente error: “Postgresql: password authentication failed for user “postgres””. En este punto se intentaron diversas contraseñas como se mencionó anteriormente para el usuario por defecto que tiene postgresql en su instalación, el cual es el usuario postgres. Por ende, como se tienen permisos de administración en dicho usuario, se procede a modificar la contraseña a una que evidentemente sepamos :).
- En el haproxy se presentó un problema a la hora de definir el frontend, debido a que se estaba utilizando una sintaxis antigua para la configuración que ya no era aceptada. Para solucionarlo se utilizó la forma actual. 


Se dejará el link del documento en drive para visualizar las diferentes capturas que se tomaron como evidencia del funcionamiento del sistema. [Link de drive](https://docs.google.com/document/d/1LxgSrKEVqKMiFNS5MIIWls9BHB3NL0rV4aUWnC7PHxY/edit?usp=sharing)

## Bibliografía
Comando screen: 
https://linux.die.net/man/1/screen

Para restart el servicio de postgres después de hacer los cambios en los archivos de configuración:
https://dba.stackexchange.com/questions/196931/how-to-restart-postgresql-server-under-centos-7

Comandos de postgresql importantes:
http://www.postgresqltutorial.com/psql-commands/

Los cambios que se tiene que hacer en los archivos  de configuración de postgresql:
https://stackoverflow.com/questions/29712228/node-postgres-get-error-connect-econnrefused/29726530#29726530

Las opciones para comandos psql:
http://www.codebind.com/postgresql/psql-cheat-sheet/

Comandos como psql:
https://stackoverflow.com/questions/33896687/salt-execute-custom-sql-after-creating-a-postgres-user

Terminal abierto:
https://askubuntu.com/questions/46627/how-can-i-make-a-script-that-opens-terminal-windows-and-executes-commands-in-the

Formato markdown
https://github.com/aigora/punto_inicio/wiki/ANEXO:-C%C3%B3mo-dar-formato-al-texto-del-archivo-README.md.-Markdown

Formato markdown
https://geekytheory.com/que-es-markdown-y-como-utilizarlo
