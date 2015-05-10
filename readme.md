#New Ubuntu 14.04 LTS(Cloud@Cost)
These are the steps I took to install nginx from a new cloud@cost vm. As long as you have git and wget installed this should work. See https://github.com/fideloper/docker-nginx-php for more information about the Dockerfile this uses and see https://github.com/phusion/baseimage-docker for more information about the base image used. 
##disable root SSH
- add "PermitRootLogin no" to /etc/ssh/sshd_config
- sudo service ssh restart

##install docker
- wget -qO- https://get.docker.com/ | sh
- sudo usermod -aG docker $USER
- log out then back in for permissions to take effect

##get/configure nginx-php
- git clone https://github.com/BlackthornYugen/docker-nginx-php.git
- cd docker-nginx-php
- make and save changes ( optional )
- docker build nginx .

##make a run.sh script
```
#!/bin/sh
docker run \
	-v /path/to/host/www:/var/www:rw \
	-p 80:80 \
	-d nginx
```
