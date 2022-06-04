Adhocracy+ dockerized
=====================

Configuration
-------------
To create a new superuser, once the container is up and running. 

    docker exec -e DJANGO_SUPERUSER_PASSWORD=secret-pw <container-id> \
      python3 manage.py createsuperuser --noinput  \
      --email iam_super@example.com \
      --username superuser

      