
----------


#sd2019b-exam1 - Distributed Systems
Universidad ICESI

**Integrantes:**

- Andres Zapata
- William Chávez
- Daniel Quintero


----------

###Primeros pasos

1. Clonar el repositorio
  
	git clone https://github.com/gaearaz/sd2019b-exam1.git
  
2. Ingresar a la carpeta raíz del proyecto
  
	cd sd2019b-exam1

3. Instalar guest-additions para Vagrant

	vagrant plugin install vagrant-vbguest

4. Crear las máquinas virtuales

	vagrant up

----------

**Procedimiento para el aprovisionamiento del balanceador**

Con las máquinas virtuales corriendo, en con una consola en la carpeta raíz del proyecto:

1. `vagrant ssh master`
2. `sudo su`
3. `salt 'loadBalancer' state.apply`

![El output debe ser algo parecido a esto:](https://i.imgur.com/ObN7NhF.png)

----------

**Procedimiento para el aprovisionamiento de los servidores web**

1. `vagrant ssh master`
2. `sudo su`
3. `salt 'webserver1' state.apply`
4. `salt 'webserver2' state.apply`

![](https://i.imgur.com/JDZRKnn.png)
![Outputs similares a esto](https://i.imgur.com/7ntxlkI.png)

----------

**Procedimiento para el aprovisionamiento de la base de datos**

1. `vagrant ssh master`
2. `sudo su`
3. `salt 'database' state.apply`

![Outputs similares a esto](https://i.imgur.com/8aOqpRv.jpg)

----------

**Documentación de las tareas de integración**

-Se definió un archivo .env para hacer la conexión con la base de datos. Este archivo se encuentra en 

![](https://i.imgur.com/Rzm80ds.jpg)
![](https://i.imgur.com/Kl2bYRd.jpg)

-Se hizo una configuración de la conexiones con las máquinas en el Vagrantfile:

![pequeña captura vagrantfile](https://i.imgur.com/fFdPTlM.png)

-Se modificó el archivo haproxy.cfg dentro de la máquina virtual por medio de estados de salt para el balanceamiento y redireccionamiento de peticiones al webserver 1 y 2

![](https://i.imgur.com/SohRCiM.png)

----------

**Algunos problemas encontrados y las acciones efectuadas para su solución al aprovisionar la infraestructura y aplicaciones**

-Hubo un imprevisto al tener levantados los dos webservers, debido a que se quería modificar el index.html que generaba el nginx luego de ser instalado. Lo que se propuso como solución más práctica fue un script de bash que se encargó de sobreescribir ese index.html en los webserver por el que diseñó el grupo de trabajo; este script se ejecuta dentro de un .sls.

-Se percibieron imprevistos a la hora de modificar el haproxy.cfg debido a que no se escribía en el archivo con los espacios y tabulaciones deseados, así que se diseñó el propio archivo y luego se sobreescribió por medio de salt states.

-Hubo inconvenientes para instalar packages en las máquinas, en algunos casos por desconocimiento de la síntaxis correcta para hacerlo o porque los repositorios por defecto no tenían los paquetes. Lo primero se resolvió por medio de investigación, y lo segundo se terminó por elegir la opción de instalar en las máquinas ciertos paquetes por medio de scripts de bash
