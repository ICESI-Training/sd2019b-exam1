# sd2019b-exam1
###Exam 1 - Examen #1 - Distributed Systems

Teacher: Daniel Barragan

Changes made by: Andres Zapata

###This fork modification contains (Actually):

-Vagrantfile's configuration (CentOS 7, 512 mb ram per machine)

-Keys generated and working for the communication between master and webservers, database and loadBalancer machines

-Salt states configured to install the following:

	-common packages for all machines: htop, strace, nano

	-loadBalancer: haproxy, apache
	-webservers (webserver1 & webserver 2): nodejs, npm, nginx_s
	-database: wget, mysql

To run, follow this steps:
 > 1. Clone this repository 
 > 
 > 2. At CLI,In the root directory, type: 
 > 
 >  - `vagrant up`
 >  
 >  - `vagrant ssh master`
 >  
 >  - `sudo su`
 >  
 >  - `vagrant '*' state.apply`


