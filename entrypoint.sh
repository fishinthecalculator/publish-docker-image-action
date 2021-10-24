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
  commit_tag="$(git tag --points-at HEAD)"

  if [ -z "$commit_tag" ]; then
    image_name="${INPUT_NAME}:${INPUT_TAG}"
  else
    image_name="${INPUT_NAME}:${commit_tag}"
  fi

  docker image tag guix:latest "$image_name"

  docker push "$image_name"

  docker logout
}

main
