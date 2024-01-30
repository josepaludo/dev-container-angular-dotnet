FROM ubuntu:23.10

# INSTALL DEPENDENCIES
RUN apt update && \
    apt install tmux -y && \
    apt install npm -y && \
    apt install wget -y && \
    wget https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh && \
    chmod +x dotnet-install.sh && \
    ./dotnet-install.sh && \
    npm install -g @angular/cli

ENV PATH="/root/.dotnet:${PATH}"

# CREATE THE FRONTAND AND BACKEND APPLICATION
RUN mkdir app && cd app && \
    dotnet new webapi -o api && \
    ng new frontend --standalone=false --style=scss --ssr=false && \
    cp -a . /backup

COPY ./container_script.sh /container_script.sh
COPY ./launchSettings.json /launchSettings.json

# CMD ["/bin/bash", "-c", "/container_script.sh && /bin/bash"]

WORKDIR /app

VOLUME /app 

