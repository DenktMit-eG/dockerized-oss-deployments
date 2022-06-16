Adhocracy+ dockerized
=====================

Run the container
-----------------
To run the existing container for testing, execute

    docker run --rm --env-file denktmit.env -p8000:8000 --name adhoc adhocracyplus:2202.2

Notice, that the `--rm` option makes the container ephemeral. You will lose all on shutdown, but it is great for testing.
Running it without that option makes your container survive a restart and hold the data. It is still not yet a production
setup. I am working on a docker-compose setup soon.

Configuration
-------------
To create a new superuser, once the container is up and running. 

    docker exec -e DJANGO_SUPERUSER_PASSWORD=secret-pw adhoc \
      python3 manage.py createsuperuser --noinput  \
      --email iam_super@example.com \
      --username superuser

      