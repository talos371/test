#!/bin/bash

source .gitlab/common.sh

project_name="$(echo "$project" | awk -F "/" '{print $NF}' | awk -F "." '{print $1}')"
printf "Project name: %s\n" "$project_name"
printf "GIT repo: %s\n" "$project"

printf "Clone git repository...\n"

gitlab_address="https://$gitlab_user:$gitlab_token@$(echo "$project" | sed -e 's#https://##')"
git clone "$gitlab_address"

cd "$project_name" || exit

printf "Delete pipeline tags - if exists...\n"
for tag in $(git tag | grep pipeline); do
  git tag -d "$tag"
  git push --delete origin "$tag"
done

printf "Delete gitlab-ci file and gitlab folder...\n"
git rm .gitlab-ci.yml
git rm -rf .gitlab

github_address="https://$github_user:$github_password@$(echo "$github_url" | sed -e 's#https://##')"
printf "Copy into $github_address\n"

git config --global user.email "$github_user_email"
git config --global user.name "$github_user"
git remote add github "$github_address"
git commit -m "$github_commit_message"
git push github master -f

printf "\n"
printf "==============================================================================================================\n"
printf "Done, all pipelines were rolled out successfully! \n"
printf "==============================================================================================================\n"
