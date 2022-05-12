#!/usr/bin/env bash

set -e

SUBMOD_TO_UPDATE="*"

set -e -u -x
git submodule update --init --recursive
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
    git -C ${path} fetch --depth=1 origin "refs/heads/${branch}"
    git -C ${path} branch -a
    git -C ${path} checkout "remotes/origin/${branch}"
done
git submodule update --remote --merge
