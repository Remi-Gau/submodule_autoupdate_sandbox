#!/usr/bin/env bash

nb_submod=$(git submodule | wc -l)

start_dir=$PWD

for i in $(seq 1 ${nb_submod}); do

    path=$(git submodule | awk -v i=${i} '{if(NR==i) print $2}')
    branch=$(git submodule | awk -v i=${i} '{if(NR==i) print $3}' | cut -c 8- | rev | cut -c 2- | rev)

    echo ${path} ${branch}

    cd ${path}
    git checkout ${branch}
    git pull
    cd ${start_dir}

done
