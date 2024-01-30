# Angular-Dotnet-Postgres Development Container

## Table of Contents

1. [Table of Contents](#table-of-contents)
2. [Requirements](#requirements)
3. [TLDR](#tldr)
4. [Overview](#overview)
5. [File by File](#file-by-file)

## Requirements

- Bash
- Docker Engine
- Docker Compose

## TLDR

1. Clone the repository, **cd** into it and run ```./dev_script```.
2. Open your browser on [http://localhost:3000](http://localhost:3000). You should see Angular's front page.
3. Start coding on the development container using VS Code's [Remote Explorer](https://marketplace.visualstudio.com/items?itemName=ms-vscode.remote-explorer).
4. Connect to the api with the port **8080** and to the database with the port **5432**.
5. Write crapy code.

## Overview

The purpose of this repository is to supply a scripted way, using docker compose, to create a containerized development environment for a fullstack application built with Angular, .NET Core Api and Postgres. By simply running ```./dev_script``` you are able to, on the first time, build the container, application and corresponding volumes, as well as, on subsequent occasions, load the volumes and have the container ready for the development of the application.

The easiest way to start coding after that is to connect to the container from your favorite IDE. Doing this on VS Code is remarkably simple with the Remote Explorer extension. 

*Keep in mind that this is a project built by a web development intern. It's not meant to replicate best practices. Hints, suggestions and advices are welcome.*

## File by file

### [Dockerfile](Dockerfile)

The Dockerfile builds from the ubuntu image and install all dependencies. It's meant to be built with ```docker compose up --build``` as does the [dev_script.sh](dev_script.sh), but the line 24 can be uncommented if you only wish to build the dev container and not use it with compose.

It would probably be much better to use node and .NET images. But I guess the way I did it does serve a training/exercise purpose.

### [compose.yaml](compose.yaml)

Simple compose file to configure ports, volumes and environment variables of the development container and the postgres container.

### [container_script.sh](container_script.sh)

The conditional checks if */app* dir is empty (that is, it's the first time the container runs, so no volume was loaded), then it loads the backup from the */backup* dir into the */app* dir. Other thing that must be done on the first time is to replace the default launchSettings.json from the .NET Core Api, so it doesn't try to open a browser and uses the port 8080.

Then comes my personal favorite part of the project. The script runs basic tmux commands to split the terminal into 3 and start the development servers (one window is left open and empty, just in case). The configuration for the angular server is supplied on the script, which is much easier than having to replace files (I'm looking at you, launchSettings.json).

The script then attaches to the session created and you are left with 3 panes open, two of them running scripts. This is particularly useful in two occasions. In case you want to install more dependencies and in case you want to restart a server. ```Dotnet watch run``` sometimes requires manual restarts, for example.

### [dev_script.sh](dev_script.sh)

I spent a whole evening trying NOT to use this
```
docker compose up --build -d && \
docker exec -it dev /container_script.sh
```
But I failed. The goal was to simply run ``` docker compose up --build ``` and then configure the compose.yaml file so that my terminal would attach to the  container's shell, whilst running the tmux commands from the [container_script.sh](container_script.sh). However, as I failed doing that, the way I found was to run the containers detached and then running the exec command with [container_script.sh](container_script.sh). It works, so there's that.

The rest of the script ensures the containers are stopped and removed after you exit the development container. The volume should be stored on the */volume* dir.
