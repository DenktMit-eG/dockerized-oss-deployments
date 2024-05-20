The DenktMit eG Deployments project
===================================

Prepare Ubuntu
--------------
export NEW_USER=<username>

sudo adduser $NEW_USER

sudo useradd -G sudo $NEW_USER
sudo useradd -G docker $NEW_USER