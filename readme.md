# Docker file creators and runners

The base directory is the context for all the docker files.

## build_docker.sh

`./build_docker.sh name:tag path-to-docker-file`

Builds a docker image. While this can be used to build an image from any Dockerfile, the other scripts here assume the image used is being created with with this script and some assumptions in the Dockerfile that center on the behavior of the `entrypoint.sh`.

* 'name:tag' is a single string giving a docker image name and tag in the usual docker format

* 'path-to-docker-file' is the path to the Dockerfile (typically one on the folders under the context folder)

```bash
./build_docker.sh katadocker:ubuntu16 ./ubuntu16/Dockerfile
```

## run_docker.sh

`./run_docker.sh name:tag [...]`

Creates a container from a docker image passing in all of the parameters expected by the `entrypoint.sh`. 

Assumes the docker image has been created using the `build_docker.sh` and uses the `entrypoint.sh` found here.

The current home directory is mounted as a volume at `/home/<$USER>` in the container. This makes the current host system home folder a read-write location in the container. 

Being able to access the home folder in the container is handy, but also be aware that things like `.profile` and `.bashrc` are now shared between the container and the host. If you have commands in those files that work in the host but not in the container (i.e. OSX specific things that do not play well in Ubuntu), you can protect them by checking for the existence of `/.dockerenv` which will only exist when you are in a container. (* Note * Word on the interwebs is that this will stop being correct at some point, but it still works today.)


* 'name:tag' is a single string giving a docker image name and tag in the usual docker format

* '[...]' any parameters given after the image name:tag are passed to the `docker run` command immediately before the image name.

```bash
./run_docker katadocker:ubuntu16
```

## exec_docker.sh

`./exec_docker.sh container_id [...]`

Attach a new tty to an running container started with `run_docker.sh` passing in all of the parameters expected by the `entrypoint.sh`. 

Assumes the docker image has been created using the `build_docker.sh` and uses the `entrypoint.sh` found here.

The current home directory is mounted as a volume at `/home/<$USER>` in the container. This makes the current host system home folder a read-write location in the container. 

Being able to access the home folder in the container is handy, but also be aware that things like `.profile` and `.bashrc` are now shared between the container and the host. If you have commands in those files that work in the host but not in the container (i.e. OSX specific things that do not play well in Ubuntu), you can protect them by checking for the existence of `/.dockerenv` which will only exist when you are in a container. (* Note * Word on the interwebs is that this will stop being correct at some point, but it still works today.)

* `container_id` is the container id from `docker ps` for a container started using `run_docker.sh`

* '[...]' any parameters given after the container id are passed to the `docker exec` command immediately before the image name.

```bash
$ docker ps
CONTAINER ID        IMAGE                   COMMAND                  
64ff7f722a0d        katadocker:ubuntu16     "/bin/sh -c 'DEBIA..." 
$ ./exec_docker 64ff7f722a0d
```


## entrypoint.sh

This is the script used for the `ENTRYPOINT` command in the Dockerfiles. It expects the `docker run` or `docker exec` command to be called so that it mounts the HOME folder, mounts the `SSH_AUTH_SOCK` directory as a volume, and passes several parameters as `-e` environment settings. These mounts and parameters are used to give the container an appearance of being somewhat on the host and access to services from the host.

The current system user name is used to create a matching user and group in the container. If possible, the same user ID and group ID will be used to try to make files created or modified use the same as the host. 

The `HOME` folder mounted is set as the current home for the user.

The last thing then entrypoint script does is to execute `su - ${USER_NAME}` which becomes the running point inside the container.