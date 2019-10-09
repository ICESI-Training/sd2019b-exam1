sudo yum remove -y nodejs npm;
sudo yum install -y gcc-c++ make;
curl -sL https://rpm.nodesource.com/setup_10.x | sudo -E bash -;
sudo yum clean all;
sudo yum install -y nodejs;
sudo yum install -y npm;
