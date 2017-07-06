# Docker file creators and runners

The base directory is the context for all the docker files.

## build_docker.sh

Builds a docker image 

./build_docker.sh name:tag path-to-docker-file

* 'name:tag' is a single string giving a docker image name and tag in the usual docker format

* 'path-to-docker-file' is the path to the Dockerfile (typically one on the folders under the context folder)

```bash
./build_docker.sh myimage:jessie ./debian8/Dockerfile
```

# run_docker.sh

Runs a docker image passing in all of the parameters expected by the `entrypoint.sh`. 

The current home directory is mounted as a volume at `/home/<$USER>` in the container. This makes the current host system home folder a read-write location in the container. (That's kind of handy, but also be aware that things like `.profile` and `.bashrc` are now shared between the container and the host also).

./run_docker.sh name:tag [...]

* 'name:tag' is a single string giving a docker image name and tag in the usual docker format

* '[...]' any parameters given after the image name:tag are passed to the `docker run` command immediately before the image name.

```bash
./run_docker myimage:jessie
```

## entrypoint.sh

This is the script used for the `ENTRYPOINT` command in the Dockerfiles. It expects the `docker run` command to be called so that it mounts the HOME folder, mounts the `SSH_AUTH_SOCK` directory as a volume, and passes several parameters as `-e` environment settings. These mounts and parameters are used to give the container an appearance of being somewhat on the host and access to services from the host.

The current system user name is used to create a matching user and group in the container. If possible, the same user ID and group ID will be used to try to make files created or modified use the same as the host. 

The `HOME` folder mounted is set as the current home for the user.

The last thing then entrypoint script does is to execute `su - ${USER_NAME}` which becomes the running point inside the container.