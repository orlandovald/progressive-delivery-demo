#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

notFoundReq=()
notFoundOpt=()
deps=()

deps+=("docker;docker -v;Docker;1")
deps+=("go;go version;Golang;1")
deps+=("kubectl;kubectl version --short --client=true;Kubectl;1")
deps+=("kind;kind --version=true;Kind;1")
deps+=("helm;helm version;Helm;1")
deps+=("kubectl-argo-rollouts;kubectl-argo-rollouts version --short;Argo Rollouts Kubectl plugin;0")
deps+=("npm;npm -v;npm;0")

for dep in "${deps[@]}"
do
    IFS=";" read -r -a arr <<< "${dep}"
    command="${arr[0]}"
    version="${arr[1]}"
    label="${arr[2]}"
    req="${arr[3]}"
    if ! command -v $command &> /dev/null
    then
        if [[ $req -eq "1" ]]
        then
            notFoundReq+=("$label")
        else
            notFoundOpt+=("$label")
        fi 
    else
        echo -e "${GREEN}$label found:${NC}"
        eval $version
        echo ""
    fi
done

if ((${#notFoundReq[@]})); then
    echo -e "\nSome ${RED}required${NC} dependencies were not found:"
    for d in ${notFoundReq[@]}; do
        echo -e "x ${RED}$d${NC}"
    done
else
    echo -e "${GREEN}\nAll required dependencies were found!${NC}"
fi

if ((${#notFoundOpt[@]})); then
    echo -e "\nSome ${GREEN}optional${NC} dependencies were not found:"
    for d in ${notFoundOpt[@]}; do
        echo -e "x $d"
    done
else
    echo -e "${GREEN}\nAll optional dependencies were found!${NC}"
fi
