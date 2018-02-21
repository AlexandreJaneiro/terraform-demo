#!/bin/bash
sudo yum update -y
sudo yum install -y httpd php
sudo service httpd start
sudo chkconfig httpd on
sudo groupadd www
sudo usermod -a -G www ec2-user
sudo chown -R root:www /var/www
sudo chmod 2777 /var/www
sudo echo "<?php phpinfo(); ?>" > /var/www/html/phpinfo.php
sudo echo "<h1>AWS Terraform Demo</h1>" > /var/www/html/demo.html
sudo chmod 2775 /var/www