sudo wget -O mysql80-community-release-el7-1.noarch.rpm https://repo.mysql.com/mysql80-community-release-el7-1.noarch.rpm  --header "Referer: www.mysql.com";
ls -la;
sudo rpm -ivh mysql80-community-release-el7-1.noarch.rpm;
sudo yum update;
sudo yum install -y mysql-server;
sudo systemctl start mysqld;
sudo systemctl status mysqld;