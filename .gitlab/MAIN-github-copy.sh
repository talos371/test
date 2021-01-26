#!/bin/bash


source .gitlab/common.sh

# shellcheck disable=SC2154

  project="https://swugit1.salt-solutions.de/sce/common/github_test.git"
  project_name="$(echo "$project" | awk -F "/" '{print $NF}' | awk -F "." '{print $1}')"
  printf "Project name: %s\n" "$project_name"
  printf "GIT repo: %s\n" "$project"

  printf "Clone git repository...\n"
  # shellcheck disable=SC2001

  gitlab_address="https://$gitlab_user:$gitlab_token@$(echo "$project" | sed -e 's#https://##')"
  git clone "$gitlab_address"

  cd "$project_name"

  printf "Delete pipeline tags - if exists...\n"
  for tag in $(git tag | grep pipeline); do
    git tag -d "$tag"
    git push --delete origin "$tag"
  done

  printf "1...\n"
  pwd
  ls -a

  printf "Delete gitlab-ci file and gitlab folder...\n"
  # rm -f .gitlab-ci.yml
  # rm -Rf .gitlab

  git rm .gitlab-ci.yml
  git rm -rf .gitlab

  printf "2...\n"
  pwd
  ls -a

  github_address="https://$github_user:$github_password@$(echo "$github_url" | sed -e 's#https://##')"
  printf "Copy into $github_address\n"

  git config --global user.email "you@example.com"
  git config --global user.name "Your Name"
  git remote add github "$github_address"
  git commit -m "added my github name"
  git push github master -f

  # git push --mirror -f "$github_address"

printf "\n"
printf "==============================================================================================================\n"
printf "Done, all pipelines were rolled out successfully! \n"
printf "==============================================================================================================\n"
