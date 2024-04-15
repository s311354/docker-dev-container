## The container ##

The Dockerfile contains two container definitions:

- a CI container which should contain everything necessary to build C++ applications and run their tests

- a DEV container which inherits the CI container and adds debugging tools like Valgrind, gdb, etc.

The compose file contains a basic setup to run the DEV container locallly. Since some IDEs depend on an SSH connection to a container, SSHD is started in the service defined by the compose file.

The user for the Docker container is `dev`. The compose file maps `~/git` on the host machine to `/home/dev/git` in the container, so we can check out our project there.

## Scripts ##

The scripts directory has a few helpers for easire building and running of the container and executing commands in it. Consider adding the scripts directory to our path for ease of use.

#### Building the container image  ####

`docker build` (re)builds and tags the container image

#### Starting  ####

`docker up` starts the container in the background

#### Stopping  ####

`docker down` stops the runnung container

#### Entering the container/Running commands  ####

- Via docker exec: `docker run`
- Via ssh: `ssh dev@localhost -p 2222`, password is `dev`

## Miscellaneous ##

#### Package tools ####

- ccache: a tool that caches the output of compiler calls.
- cppcheck: a static analysis tool for C and C++ code. It checks for various types of errors and potential issues in source code, helping developers identify and fix bugs, potential memory leaks, and other problems early in the development process.
- curl: a command that perform various tasks, such as downloading files from remote servers, sending requests to web servers, and testing network connectivity.
- gcovr: a command-line tool that generates reports summarizing the code coverage provided by the GCC compiler's coverage testing tool. 
- lsb-release: a package is a utility commonly found in Linux distributions that adhere to the Linux Standard Base (LSB).
- shellcheck: a static analysis tool for shell scripts. It helps to identify common issues and potential bugs in shell scripts, improving their reliability and maintainability.
- software-properties-common: a package provides a utility called add-apt-repository, which simplifies the management of APT software repositories on Debian-based Linux distributions like Ubuntu. 
- valgrind: a powerful and widely-used tool for memory debugging, memory leak detection, and profiling. It's particularly valuable for C and C++ programmers to identify memory-related issues in their code.
- ...

## Reference ##

- [docker.docs](https://docs.docker.com/)

- [arnemertz/docker4c](https://github.com/arnemertz/docker4c)
