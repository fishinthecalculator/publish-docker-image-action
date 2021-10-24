#!/bin/sh
set -eu

main() {
  echo "" # see https://github.com/actions/toolkit/issues/168

  cd "${GITHUB_WORKSPACE}"

  if [ -n "${INPUT_WORKDIR}" ]; then
    cd "${INPUT_WORKDIR}"
  fi

  echo "${INPUT_PASSWORD}" | docker login -u "${INPUT_USERNAME}" --password-stdin "${INPUT_REGISTRY}"

  docker load < "${INPUT_IMAGE}"
  docker image tag guix:latest "${INPUT_NAME}:${INPUT_TAG}"

  docker push "${INPUT_NAME}:${INPUT_TAG}"

  docker logout
}

main
