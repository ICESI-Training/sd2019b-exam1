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

![][1]
[1]: images/01_diagrama_despliegue.png
**Figura 1**. Diagrama de Despliegue

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

1. Instalar Vagrant.

Hay que ingresar al siguiente link:
https://www.vagrantup.com/docs/installation/

En la esquina superior derecha seleccionamos la opción Download y después seleccionamos el instalador o paquete apropiado para nuestro sistema operativo, que en este caso es Lubuntu 19.04.

<imagen>

Para validar la correcta instalación utilizamos el comando:

~~~
vagrant -v
~~~

**Nota:** Es muy importante que nos aseguremos que tenemos la última versión de vagrant, de lo contrario, traerá problemas más adelante.

Los computadores de la sala de redes tenían vagrant 2.2.3. Tocó desintalarlo e instalar vagrant 2.2.5.

---

2. Instalar VirtualBox.

https://vitux.com/how-to-install-virtualbox-on-ubuntu/

~~~
sudo add-apt-repository multiverse && sudo apt-get update
~~~

Ahora instalamos VirtualBox con el comando

~~~
sudo apt install virtualbox
~~~

Para abrirlo directamente desde la terminal se escribe

~~~
virtualbox
~~~

---

3. Instalar Saltstack

Como base se va a clonar el repositorio salt-vagrant-demo con el siguiente comando:

~~~
git clone https://github.com/UtahDave/salt-vagrant-demo
~~~

---

4. Configuración Inicial

Ingresamos en el Vagrantfile y seleccionamos como sistema operativo para las máquinas virtuales bento/ubuntu-18.04. En un comienzo lo íbamos a hacer con centos/7, pero se nos demoraba entre 1 y 2 horas en aprovisionar. Mientras que con bento/ubuntu-18.04 se demora aproximadamente 20 minutos.

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

Si aparece el nombre del minion y seguido de True, todo salió bien :).

---

5. Configuración inicial de los minions

En nuestra arquitectura tenemos cuatro máquinas virtuales:
* Load Balancer - master - como el nombre lo indica cumplirá el rol de master y a su vez de balanceador de carga. No hicimos el master por separado para ahorrarnos una máquina virtual. **IP:** 192.168.50.10. **RAM:** 512
* Webserver 1 - minionws1 - minion encargado de tener el Webserver 1. **IP:** 192.168.50.110. **RAM:** 512
* Webserver 2 - minionws2 - minion encargado de tener el Webserver 1. **IP:** 192.168.50.120. **RAM:** 512
* Database - miniondb - minion encargo de tener la base de datos. **IP:** 192.168.50.130. **RAM:** 512

El archivo salt-vagrant-demo que copiamos venía con master, minion1 y minion2. Cada uno de ellos adicionalmente tenía un id con el mismo nombre y unas keys (pem y pub). Todas las referencias de minion1 se reemplazaron por minionws1 y las referencias de minion2 se reemplazaron por minionws2.

Para miniondb se copió la configuración de uno de los otros minions existentes y se reemplazaron las referencias por miniondb.

Para las keys, se aplicó por la terminal el comando:

~~~
ssh-keygen rsa
~~~

Sin embargo, a la hora de hacer el intercambio de keys entre el master y los minions, se producía un error. Como alternativa, un poco chambona, se nos ocurrió copiar el contenido de las keys de minionws2 y ponerlas en miniondb.pem y miniondb.pub según correspondiera, ¡así nos funcionó!

---

6. Webserver 1 y 2

Ubicarse en la carpeta *salt*, acceder a al archivo *top.sls* y agregar lo siguiente:

~~~
'minionws*':
  - web
~~~

El archivo *top.sls* queda de la siguiente manera:

~~~
base:
  '*':
    - common
  'minionws*':
    - web
~~~

Dentro de *top.sls* crear la carpeta *web*.

Nos ubicamos en *web* y creamos el archivo *init.sls* con el contenido:

~~~
apache2:
  pkg.installed:
    - name: apache2
  service.running:
    - enable: true

/var/www/html/index.html:
  file.managed:
    - template: jinja
    - source: salt://web/conf/index.html
~~~

Dentro de la carpeta *web*, creamos la carpeta *conf* y dentro de ella, creamos el archivo index.html con el contenido:

~~~
<html>
  <body>
    <h1>Server Up and Running!</h1>
  </body>
</html>
~~~

