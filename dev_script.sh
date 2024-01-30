#!/bin/bash

docker compose up --build -d && \
docker exec -it dev /container_script.sh && \
echo "Removing containers" && \
docker container stop dev dbpg && \
docker container rm dev dbpg && \
echo "'dev_script.sh' finished successfully."
