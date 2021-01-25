#!/bin/bash

# Input all project repositories with category: library
export libraries=(
  "https://swugit1.salt-solutions.de/sce/library/model-webservices.git"
  "https://swugit1.salt-solutions.de/sce/library/model-ftp.git"
)

# Input all project repositories with category: service
export services=(
  "https://swugit1.salt-solutions.de/sce/provider/fex_ws_de.git"
  "https://swugit1.salt-solutions.de/sce/provider/geo_ws_fr.git"
  "https://swugit1.salt-solutions.de/sce/provider/tne_ws_de.git"
  "https://swugit1.salt-solutions.de/sce/provider/dhe_ws.git"
  "https://swugit1.salt-solutions.de/sce/provider/rom_ws_gb.git"
  "https://swugit1.salt-solutions.de/sce/provider/ups_de.git"
  "https://swugit1.salt-solutions.de/sce/common/dispatcher.git"
  "https://swugit1.salt-solutions.de/sce/common/sftp-push.git"
  "https://swugit1.salt-solutions.de/sce/common/persistence.git"
  "https://swugit1.salt-solutions.de/sce/common/mapper.git"
  "https://swugit1.salt-solutions.de/sce/common/angela.git"
)

source .gitlab/common.sh

if [[ $CI_COMMIT_TAG =~ ^L ]]; then
  printf "Loop all library projects...\n"
  # shellcheck disable=SC2154
  for project in "${libraries[@]}"; do
    project_name="$(echo "$project" | awk -F "/" '{print $NF}' | awk -F "." '{print $1}')"
    printf "Project name: %s\n" "$project_name"
    printf "GIT repo: %s\n" "$project"

    printf "Clone git repository...\n"
    # shellcheck disable=SC2001
    authenticated_address="https://$gitlab_user:$gitlab_token@$(echo "$project" | sed -e 's#https://##')"
    git clone "$authenticated_address"
    cd "$project_name" || exit

    printf "Delete gitlab-ci file and gitlab folder...\n"
    rm -f .gitlab-ci.yml
    rm -Rf .gitlab

    printf "Copy the new gitlab-ci file and gitlab folder...\n"
    cp ../gitlab-pipelines/library-pipeline.yml ./.gitlab-ci.yml
    cp -R ../gitlab-pipelines/gitlab ./.gitlab
    chmod 755 ./.gitlab/*

    printf "Commit, tag and push master branch...\n"
    git config --global user.email "$gitlab_user_email"
    git config --global user.name "$gitlab_user_name"
    git add .
    git commit -m "Release pipeline-$CI_COMMIT_TAG"
    git tag "gitlab-pipeline-$CI_COMMIT_TAG"
    git push origin master --tags

    cd ..
    printf "\n"
  done
  printf "\n"
  printf "===========================================================================================================\n"
  printf "Done, please check all the projects pipelines (each project 2 pipelines).\n"
  printf "===========================================================================================================\n"
elif [[ $CI_COMMIT_TAG =~ ^S ]]; then
  printf "\n"
  printf "Loop all service projects...\n"
  # shellcheck disable=SC2154
  for project in "${services[@]}"; do
    project_name="$(echo "$project" | awk -F "/" '{print $NF}' | awk -F "." '{print $1}')"
    printf "Project name: %s\n" "$project_name"
    printf "GIT repo: %s\n" "$project"

    printf "Clone git repository...\n"
    # shellcheck disable=SC2001
    authenticated_address="https://$gitlab_user:$gitlab_token@$(echo "$project" | sed -e 's#https://##')"
    git clone "$authenticated_address"
    cd "$project_name" || exit

    printf "Delete gitlab-ci file and gitlab folder...\n"
    rm -f .gitlab-ci.yml
    rm -Rf .gitlab

    printf "Copy the new gitlab-ci file and gitlab folder...\n"
    cp ../gitlab-pipelines/service-pipeline.yml ./.gitlab-ci.yml
    cp -R ../gitlab-pipelines/gitlab ./.gitlab
    chmod 755 ./.gitlab/*

    printf "Commit, tag and push master branch...\n"
    git config --global user.email "$gitlab_user_email"
    git config --global user.name "$gitlab_user_name"
    git add .
    git commit -m "Release pipeline-$CI_COMMIT_TAG"
    git tag "gitlab-pipeline-$CI_COMMIT_TAG"
    git push origin master --tags

    cd ..
    printf "\n"
  done
  printf "\n"
  printf "===========================================================================================================\n"
  printf "Done, please check all the projects pipelines (each project 2 pipelines).\n"
  printf "===========================================================================================================\n"
else
  printf "\nRollout failed, please start the tag with prefix L or S - Actual tag: %s" "$CI_COMMIT_TAG"
  exit 1
fi

