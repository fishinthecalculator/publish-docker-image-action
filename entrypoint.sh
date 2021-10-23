#!/bin/sh
set -eu

main() {
  echo "" # see https://github.com/actions/toolkit/issues/168

  sanitize "${INPUT_USERNAME}" "username"
  sanitize "${INPUT_PASSWORD}" "password"

  if uses "${INPUT_WORKDIR}"; then
    changeWorkingDirectory
  fi

  if uses "${INPUT_USERNAME}" && uses "${INPUT_PASSWORD}"; then
    docker login -u "${INPUT_USERNAME}" -p "${INPUT_PASSWORD}" "${INPUT_REGISTRY}"
  fi

  docker load < "${INPUT_IMAGE}"
  docker image tag guix:latest "${INPUT_NAME}:${INPUT_TAG}"

  push

  docker logout
}

sanitize() {
  if [ -z "${1}" ]; then
    >&2 echo "Unable to find the ${2}. Did you set with.${2}?"
    exit 1
  fi
}


changeWorkingDirectory() {
  cd "${INPUT_WORKDIR}"
}

uses() {
  [ -n "${1}" ]
}

usesBoolean() {
  [ -n "${1}" ] && [ "${1}" = "true" ]
}

push() {
  docker push "${INPUT_NAME}:${INPUT_TAG}"
}

main
