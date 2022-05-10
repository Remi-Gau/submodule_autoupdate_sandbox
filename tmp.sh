#!/usr/bin/env bash

set -e

start_dir=$PWD
SUBMOD_TO_UPDATE="lib/sub_3 lib/sub_1"

if [ "${SUBMOD_TO_UPDATE}" = "*" ]; then
    submodules=$(git submodule | awk '{print $2}')
else
    submodules=$(echo -e ${SUBMOD_TO_UPDATE} | sed "s/ /\n/g")
fi

nb_submod=$(echo "${submodules}" | wc -l)

echo -e "\nUPDATING ${nb_submod} SUBMODULES"
echo -e "${submodules}"

for i in $(seq 1 ${nb_submod}); do
    path=$(echo -e ${submodules} | awk -v i=${i} '{print $i}')
    branch=$(git config --get --file .gitmodules submodule.${path}.branch)
    echo -e "\nswitching submodule ${path} to ${branch}"
    cd "${path}" || exit
    git checkout ${branch}
    cd "${start_dir}"
done

git submodule update --remote --merge
