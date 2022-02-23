#! /bin/bash
sudo yum update -y
sudo yum install httpd -y
sudo systemctl enable httpd
sudo service httpd start 
echo "<h1>Welcome to terraform course</h1>">>/var/www/html/index.html