#!/bin/bash

# change these for an easier experience
IMAGE_NAME="natearn/random-vim-tips"
CONTAINER="tipsAPI"
COMMAND="bash"

if [[ "$(docker images -q $IMAGE_NAME 2> /dev/null)" == "" ]];
then docker build -t $IMAGE_NAME .
fi

if docker inspect -f '{{.State.Running}}' "$CONTAINER" &> /dev/null
then docker exec -it "$CONTAINER" "$COMMAND"
else docker run -it --rm --name "$CONTAINER" \
  -v $(pwd):"/home/stack/app" \
  -v "/home/stack/app/.stack-work" \
  -p 8080:8080 \
  "$IMAGE_NAME" \
  "$COMMAND"
fi
