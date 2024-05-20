The DenktMit eG Deployments project
===================================

Prepare Ubuntu
--------------
Have a look into the os-preparations directory. First we want to prepare your server OS to use Podman. So we can 
easily serve our containerized apps ran by an unprivileged user.

Start Traefik
--------------
Assuming you installed the Traefik docker-compose.yaml and .env file to /opt/traefik. You can now just run Traefik as
composed app using 

    podman-compose --env-file .env -f docker-compose.yaml up -d

Visit your page on

Run Nginx Helloworld
--------------------