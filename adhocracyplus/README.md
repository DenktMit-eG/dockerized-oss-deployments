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

Kubernetes deployment
----------------------
To deploy the application on a Kubernetes cluster, copy the "adhocracyplus_example_manifest.yaml" file and adjust it to 
your needs. You definitely want to adjust the secrets and configmap. Keep in mind to NOT commit your real secrets and 
configs to any repository. Note, that the secrets are base64 encoded. Line-breaks and other unexpected whitespaces may
cause trouble. Encode them like `echo -n 'your-secret' | base64 -w 0` for clean results :).

First you might want to create a new namespace in your cluster. Do not forget to set the KUBECONFIG variable correctly 

    export KUBECONFIG=~/.kube/cluster-config
    kubectl apply -f service.yaml -n your-namespace

Then you can apply your manifest file to your cluster

    kubectl apply -f adhocracyplus_manifest.yaml -n your-namespace

If everything went well, your command line should show

    secret/adhocracy created
    configmap/adhocracy created
    pod/adhocracy created
    service/adhocracy created

As I am also learning Kubernetes, I do not yet know, how to properly configure an Ingress. So to play with the
deployment, I need a port forward. And you should be able to port-forward the adhocracy server to you local machine

    kubectl port-forward -n your-namespace svc/adhocracy 8000:8000

That's it, you can access it on localhost:8000. Unfortunately, you won't have a superuser yet. But there's an easy way
to fix it with the help of K9s. Go to the deployments shell and run the superuser setup script

    export KUBECONFIG=~/.kube/cluster-config
    docker run --rm -it -v $KUBECONFIG:/root/.kube/config quay.io/derailed/k9s
    
From there, navigate to your namespace, find your pod and press `s` to enter a shell inside the running container. Then
run the superuser creation script document above.