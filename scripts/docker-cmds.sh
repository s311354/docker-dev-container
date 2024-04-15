#!/bin/bash -e

SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "${SCRIPT}")

DOCKER_DIR=$(readlink -f "${SCRIPT_DIR}/..")
COMPOSE_FILE=${DOCKER_DIR}/docker-compose.yml

usage() {
    echo "Docker - container for C/C++ development"
    echo "Usage: $0 <command> [<args>]"
    echo ""
    echo "Commands:"
    echo "  build     - build the container"
    echo "  up        - starts the container"
    echo "  down      - stops and remove the container"
    echo "  run       - open a shell in the container"
    echo "  run <cmd> - run <cmd> inside the container"
    exit 0
}

_compose() {
    docker compose -f "$COMPOSE_FILE" "$@"
}

_container() {
    _compose ps -q
}

_is_up() {
    CONTAINER=$(_container)
    test -n "$CONTAINER" && docker ps -q --no-trunc | grep "$CONTAINER" > /dev/null
    return $?
}

docker_up() {
    _compose up -d
}

docker_down() {
    _compose down
}

docker_build() {
    _is_up && docker_down
    DOCKER_BUILDKIT=1 docker build -t docker-dev:latest "$DOCKER_DIR"
}

docker_run() {
    _is_up || docker_up
    WORKDIR=$(pwd | sed "s#${HOME}#/home/dev#")

    if [ $# -ne 0 ]; then
         docker exec -i -t -u dev:dev $(_container) bash -c "if [ -d \"${WORKDIR}\" ]; then cd ${WORKDIR}; fi; ${*@Q}"
    else
	 docker exec -i -t -u dev:dev $(_container) bash -c "if [ -d \"${WORKDIR}\" ]; then cd ${WORKDIR}; fi; bash"
    fi
}

[ -n "$1" ] || usage
COMMAND=$1
shift

case ${COMMAND} in
    up)
        docker_up
        ;;
    down)
        docker_down
        ;;
    build)
        docker_build
        ;;
    run)
        docker_run "$@"
        ;;
    *)
        usage
        ;;
esac
