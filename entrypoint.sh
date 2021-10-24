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

  if [ -n "$IMAGE_TAG" ]; then
    image_name="${INPUT_NAME}:${IMAGE_TAG}"
  else
    image_name="${INPUT_NAME}:latest"
  fi

  docker image tag guix:latest "$image_name"

  docker push "$image_name"

  docker logout
}

main
