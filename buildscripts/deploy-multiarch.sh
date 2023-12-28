#!/usr/bin/env zsh
set -e

ME_DIR="$(realpath "$(dirname "$0")")"
PROJECT_DIR="${PROJECT_DIR:-$(realpath "$ME_DIR/..")}"

# key of nginx versions is the version as in the nginx repository,
# value is the version to include in the tag of the deployment
# Please respect ascending order of importance, last build will appear top of the list.
declare -A nginx_versions
nginx_versions=(
  ["1.21.6-alpine"]="1.21.6-alpine3.15"
  ["1.23.1-alpine"]="1.23.1-alpine3.16"
  ["1.25.3-alpine3.18"]="1.25-alpine3.18"
  ["1.25.3-alpine3.18-slim"]="1.25-alpine3.18-slim"
)

echo 
echo "Specify a version to build. Versions should include major,minor,path (i.e. 1.2.3)"
echo "and be incremental. The semantic version to be deployed should be tagged."
echo "Before the build a new tag will be created with the specified version!"
echo 
echo "The latest tags in the repository are:"
git tag | tail -n 5
echo 

while true; do
  echo "Please enter a version: "
  read version
  if [[ $version =~ '^[0-9]+\.[0-9]+\.[0-9]+$' ]]; then
    break
  fi
  echo "Invalid version. Please enter a version in the format of '1.2.3'"
done

echo "Tagging repository. If this fails you should choose another tag or remove the tag ${version}"
git tag "$version"

for nginx_version nginx_alias in ${(kv)nginx_versions}; do
  (
      cd "$PROJECT_DIR"
      export NGINX_VERSION="$nginx_version"
      export NGINX_VERSION_ALIAS="$nginx_alias"
      export VERSION="$version"
      export INTERACTION="none"
      echo "Building for $NGINX_VERSION as $NGINX_VERSION_ALIAS"
      ./buildscripts/01-buildpush-multiarch.sh
  )
done