#!/bin/bash
# while read line; do export $line; done < .env.development
source ./.env.development


# set host
HOST_DOMAIN=$VUE_APP_HOST_DOMAIN
HOST_IP=$VUE_APP_HOST_IP

SET_HOST=" --add-host ${HOST_DOMAIN}:${HOST_IP}"

if [ -z "$HOST_IP" -o -z "$HOST_DOMAIN" ];then
  # If the ip or domain name has a null then drop it
  SET_HOST=""
fi


CURRENT_DIR_NAME=`basename $PWD`
CMD="$*"

echo "current directory [ ${CURRENT_DIR_NAME} ]"

CMD_MD5=`echo -n "$*$PWD" | md5sum | cut -d ' ' -f1`
CONTAINNER_NAME="${CURRENT_DIR_NAME}_${CMD_MD5}"

NODE_CACHE_DIRECTORY=$HOME/.node/.cache
NODE_NPM_GLOBAL_DIRECTORY=$HOME/.node/${IMAGE_NAME}



if [ ! -d "$NODE_CACHE_DIRECTORY" ]; then
    echo "Initially creating node cache directory: $NODE_CACHE_DIRECTORY"
    mkdir -p "$NODE_CACHE_DIRECTORY"
fi

if [ ! -d "$NODE_NPM_GLOBAL_DIRECTORY" ]; then
    echo "Initially creating npm global directory: $NODE_NPM_GLOBAL_DIRECTORY"
    mkdir -p "$NODE_NPM_GLOBAL_DIRECTORY/bin"
    mkdir -p "$NODE_NPM_GLOBAL_DIRECTORY/node_modules"
fi



PORT_SET=""
# VUE 为 PORT=
# REACT 为 PORT=
# 除非少数是认 port
RESULT=$(echo $CMD | grep -E "npm run dev|npm start|yarn start|yarn run dev")
if [ -n "$RESULT" ];then

    if [ -z "${PORT}" ]; then
      echo "Please set PORT={port} in .env.development"
      exit 1
    fi
    PORT_SET="-p ${PORT}:${PORT}"
    echo "Port mapping is ${PORT_SET}"
fi

echo "run command [ ${CMD} ]"


# NODE_USER="root:root"
NODE_USER="node:node"
HAS_GOLABL=`echo $CMD|grep ' -g '`
if [ "$HAS_GOLABL" ] ; then
  NODE_USER="root:root"
fi



# Host generates global node_modules
if [ ! -d "${NODE_NPM_GLOBAL_DIRECTORY}/bin" -o `ls ${NODE_NPM_GLOBAL_DIRECTORY}/bin/ | wc -l` -eq "0" ];then
  # Copy from within the container
  TEST_DOCKER_NODE_NAME="docker_test_node_name"
  docker rm ${TEST_DOCKER_NODE_NAME}
  docker run --name  ${TEST_DOCKER_NODE_NAME} ${IMAGE_NAME} /bin/sh -c "echo running test node"
  docker cp ${TEST_DOCKER_NODE_NAME}:/usr/local/lib/node_modules ${NODE_NPM_GLOBAL_DIRECTORY}/
  docker cp ${TEST_DOCKER_NODE_NAME}:/usr/local/bin ${NODE_NPM_GLOBAL_DIRECTORY}/
  docker rm ${TEST_DOCKER_NODE_NAME}
fi

# Stop containers that are already running again, if there are
docker ps | grep "${CONTAINNER_NAME}" &&  docker stop "${CONTAINNER_NAME}" && sleep 2

# Run docker
docker run -it --rm --name $CONTAINNER_NAME \
  -v "$PWD":/usr/src/app \
  -v "$NODE_CACHE_DIRECTORY":/home/node/.cache \
  -v "${NODE_NPM_GLOBAL_DIRECTORY}/node_modules":/usr/local/lib/node_modules \
  -v "${NODE_NPM_GLOBAL_DIRECTORY}/bin":/usr/local/bin \
  -w /usr/src/app \
  ${SET_HOST} \
  ${PORT_SET} \
  --user $NODE_USER \
  ${IMAGE_NAME} \
  /bin/sh -c "${CMD}"
