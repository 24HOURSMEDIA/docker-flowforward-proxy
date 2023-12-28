#!/usr/bin/env bash
set -e

ME_DIR="$(realpath "$(dirname "$0")")"
PROJECT_DIR="${PROJECT_DIR:-$(realpath "$ME_DIR/..")}"

set -a
source "${PROJECT_DIR}/build.env"
set +a

check_env() {
    local var_name="$1"
    local var_value=$(eval echo "\$$var_name")
    if [ -z "$var_value" ]; then
        echo "Error: $var_name is undefined or empty"
        exit 1
    fi
}

check_env "NGINX_VERSION"
check_env "VERSION"
check_env "REPOSITORY_URI"
check_env "NAME"

(
  cd ${PROJECT_DIR}

  # Set the desired image name and tag
  AUTO_IMAGE_TAG=${VERSION}-nginx${NGINX_VERSION}
  IMAGE_TAG=${IMAGE_TAG:-"${AUTO_IMAGE_TAG}"}


  echo
  echo "Target for build:"
  echo "$REPOSITORY_URI:$IMAGE_TAG"
  echo
  echo "Please verify the settings above. The image will be built and pushed to the target."

    read -p "Start build. Continue? [y/N] " -n 1 -r
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo
        echo "Aborting"
        exit 1
    fi
    echo ""

  BUILDER_NAME=$NAME

  # Check if the builder already exists, and remove it if it does
  if docker buildx inspect $BUILDER_NAME > /dev/null 2>&1; then
      echo "Builder $BUILDER_NAME already exists, removing..."
      docker buildx rm $BUILDER_NAME
  fi

  # Create a new builder instance
  docker buildx create --name ${BUILDER_NAME} --use

  # Start up the builder instance
  docker buildx inspect ${BUILDER_NAME} --bootstrap

  # Build and push the image for multiple architectures
  docker buildx build --platform "linux/amd64,linux/arm64/v8,linux/arm/v7" \
      -t $REPOSITORY_URI:$IMAGE_TAG \
      --build-arg NGINX_IMAGE=nginx:${NGINX_VERSION} \
      --push \
      .

  # Clean up the builder instance
  docker buildx rm ${BUILDER_NAME}
)