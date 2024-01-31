# Angular-Dotnet-Postgres Development Container

## Table of Contents

1. [Table of Contents](#table-of-contents)
2. [Requirements](#requirements)
3. [TLDR](#tldr)
4. [Overview](#overview)
5. [File by File](#file-by-file)
6. [Current Issues](#current-issues)

## Requirements

- Bash
- Docker Compose
- Visual Studio Code and [Remote Explorer Extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode.remote-explorer)

## TLDR

**Note that running this will open VS Code**

1. Clone the repository, **cd** into it and run ```./dev_script```.
2. Select the */dev* container on the VS Code's prompt.
3. Open your browser on [http://localhost:3000](http://localhost:3000). You should see Angular's front page.
4. Connect to the api with the port **8080** and to the database with the port **5432**.
5. Write crapy code.

## Overview

The purpose of this repository is to provided a streamlined way, leveraging Docker Compose, to create a containerized development environment for a fullstack application with the Angular, .NET Core Api and Postgres stack.

By simply running ```./dev_script``` you are able to, on the first time, build the container, application and corresponding volumes, as well as, on subsequent occasions, load the volumes and have the container ready for the application development.

You can start coding right away since this script opens a VS Code window and prompts for you to select the container to attach to.

*Keep in mind that this project aims to be a programming exercise, not a solution to problems.* 

## File by file

### [Dockerfile](Dockerfile)

The Dockerfile builds from the ubuntu image and install all dependencies. It's meant to be built with ```docker compose up --build``` as does the [dev_script.sh](dev_script.sh). The line 24 is commented since it had no effect on the compose build, but it works for building the container with ```docker build```.

### [compose.yaml](compose.yaml)

Simple compose file to configure ports, volumes and environment variables of the development container and the postgres container.

### [container_script.sh](container_script.sh)

The conditional checks if */app* dir is empty (that is, it's the first time the container runs, so no volume was loaded), then it loads the backup from the */backup* dir into the */app* dir. Other thing that must be done on the first time is to replace the default launchSettings.json from the .NET Core Api, so it doesn't try to open a browser and uses the port 8080.

Then comes my personal favorite part of the project. The script runs basic tmux commands to split the terminal into 3 and start the development servers (one window is left open and empty, just in case). The configuration for the angular server is supplied on the script, which is much easier than having to replace files (I'm looking at you, launchSettings.json). Perhaps the angular server will prompt for some questions, but only on the first time. To those unfamiliar with tmux, pressing Ctrl+B, then Q and then 1 should move the cursor to the angular pane so you can answer the prompts from there.

The script then attaches to the session created and you are left with 3 panes open, two of them running scripts. This is particularly useful in two occasions. In case you want to install more dependencies and in case you want to restart a server. ```Dotnet watch run``` sometimes requires manual restarts, for example.

### [dev_script.sh](dev_script.sh)

I spent a whole evening trying NOT to use this
```
docker compose up --build -d && \
docker exec -it dev /container_script.sh
```
But I failed. The goal was to simply run ``` docker compose up --build ``` and then configure the compose.yaml file so that my terminal would attach to the  container's shell, whilst running the tmux commands from the [container_script.sh](container_script.sh). However, as I failed doing that, the way I found was to run the containers detached and then running the exec command with [container_script.sh](container_script.sh). It works, so there's that.

The script also opens a VS Code window and prompts the user to select a container to attach to.

The rest of the script ensures the containers are stopped and removed after you exit the development container. The volume should be stored on the */volume* dir.

### [task.json](.vscode/tasks.json) and [dev.code-workspace](dev.code-workspace)

The defined task runs when the workspace opens and runs the command to attach to a running container. I could not managed to make it attach automatically to the **dev** container, however.

The workspace file simply points to the root of the project.

## Current Issues

- I would like to avoid the **[gambiarra](https://www.urbandictionary.com/define.php?term=Gambiarra)** of running the containers and then attaching to the dev container, as I explained [here](#dev_scriptsh).
- Currently the user has to select manually the container on VS Code. I tried to pass the container name as an *arg* on the task but it does not work.
- The C# language server must me initialized every time the container runs. I have not yet looked into it to see if I'm missing something or if it's supposed to be like this.