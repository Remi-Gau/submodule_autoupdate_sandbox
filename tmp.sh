#!/usr/bin/env bash

start_dir=$PWD
SUBMOD_TO_UPDATE="*"

if [ "${SUBMOD_TO_UPDATE}"="*" ]; then
    submodules=$(git submodule | awk '{print $2}')
    nb_submod=$(echo "${submodules}" | wc -l)
fi

echo "UPDATING ${nb_submod} SUBMODULES"
echo ${submodules}

for i in $(seq 1 ${nb_submod}); do
    path=$(echo ${submodules} | awk -v i=${i} '{print $i}')
    branch=$(git config --get --file .gitmodules submodule.${path}.branch)
    echo "switching submodule ${path} to ${branch}"
    cd "${path}"
    git checkout ${branch}
    cd "${start_dir}"
done

git submodule update --remote --merge
