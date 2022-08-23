#!/bin/bash

install_all_neofetch_packages() {
    install_package_if_not_found neofetch

    # Add entry into .bashrc file to autorun neofetch script on bash start
    if [[ ! `awk '/^neofetch/ {print $1}' ~/.bashrc` ]]; then
        echo 'neofetch' >> ~/.bashrc
    fi
}
