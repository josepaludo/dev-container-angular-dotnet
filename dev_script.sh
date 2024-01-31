#!/bin/bash

echo "'dev_script.sh' start."

docker compose up --build -d

code dev.code-workspace

docker exec -it dev /container_script.sh && \

echo "Removing containers"

docker container stop dev dbpg

docker container rm dev dbpg

echo "'dev_script.sh' end."
