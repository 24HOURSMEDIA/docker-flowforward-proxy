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
check_env "NGINX_VERSION_ALIAS"
check_env "VERSION"
check_env "REPOSITORY_URI"
check_env "NAME"

if ! [[ ${VERSION} =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Incorrect version format. Exiting..."
    exit 1
fi
# Split the version into parts
MAJOR=$(echo "$VERSION" | cut -d. -f1)
MINOR=$(echo "$VERSION" | cut -d. -f2)
PATCH=$(echo "$VERSION" | cut -d. -f3)



(
  cd ${PROJECT_DIR}

  # Set the desired image name and tag
  IMAGE_TAG1=${MAJOR}-nginx${NGINX_VERSION_ALIAS}
  IMAGE_TAG2=${MAJOR}.${MINOR}-nginx${NGINX_VERSION_ALIAS}
  IMAGE_TAG3=${MAJOR}.${MINOR}.${PATCH}-nginx${NGINX_VERSION_ALIAS}

  echo
  echo "Target for build:"
  echo "$REPOSITORY_URI:$IMAGE_TAG1"
  echo "$REPOSITORY_URI:$IMAGE_TAG2"
  echo "$REPOSITORY_URI:$IMAGE_TAG3"
  echo

  echo "interaction $INTERACTION"
  if [ "$INTERACTION" != "none" ]; then
    echo "Please verify the settings above. The image will be built and pushed to the target."
    read -p "Start build. Continue? [y/N] " -n 1 -r
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo
        echo "Aborting"
        exit 1
    fi
    echo ""
  fi

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
  docker buildx build --platform "linux/amd64,linux/arm64/v8,linux/arm/v7,linux/arm/v6" \
      --tag "$REPOSITORY_URI:$IMAGE_TAG1" \
      --tag "$REPOSITORY_URI:$IMAGE_TAG2" \
      --tag "$REPOSITORY_URI:$IMAGE_TAG3" \
      --build-arg "NGINX_IMAGE=nginx:${NGINX_VERSION}" \
      --push \
      .

  # Clean up the builder instance
  docker buildx rm ${BUILDER_NAME}
)

echo
echo "Finished, do not forget to push the repository with"
echo "git push --tags"
echo
