#!/bin/bash

export libraries=(
  "https://swugit1.salt-solutions.de/sce/common/github_test.git"
)

source .gitlab/common.sh

printf "Loop all library projects...\n"
# shellcheck disable=SC2154
#for project in "${libraries[@]}"; do

  project="https://swugit1.salt-solutions.de/sce/common/github_test.git"
  project_name="$(echo "$project" | awk -F "/" '{print $NF}' | awk -F "." '{print $1}')"
  printf "Project name: %s\n" "$project_name"
  printf "GIT repo: %s\n" "$project"

  printf "Clone git repository...\n"
  # shellcheck disable=SC2001

  gitlab_address="https://$gitlab_user:$gitlab_token@$(echo "$project" | sed -e 's#https://##')"
  git clone "$gitlab_address"

  cd "$project_name" || exit

  printf "Delete pipeline tags - if exists...\n"
  for tag in $(git tag | grep pipeline); do
    git tag -d "$tag"
    git push --delete origin "$tag"
  done

  printf "Delete gitlab-ci file and gitlab folder...\n"
  rm -f .gitlab-ci.yml
  rm -Rf .gitlab

  printf "Copy the new gitlab-ci file and gitlab folder...\n"
  cp ../gitlab-pipelines/library-pipeline.yml ./.gitlab-ci.yml
  cp -R ../gitlab-pipelines/gitlab ./.gitlab
  chmod 755 ./.gitlab/*


  github_address="https://talos371:371Talos@$(echo "$github_url" | sed -e 's#https://##')"
  printf "Copy into $github_address\n"

  git push --mirror "$github_address"

  cd ..
  rm -Rf "$project_name"
  printf "\n"
#done


printf "\n"
printf "==============================================================================================================\n"
printf "Done, all pipelines were rolled out successfully! \n"
printf "==============================================================================================================\n"
