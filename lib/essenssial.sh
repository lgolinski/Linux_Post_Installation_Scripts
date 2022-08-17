#!/bin/bash

# bool function checked if script is executed with root permissions.
is_user_root () { [ "$(id -u)" -eq 0 ]; }


make_sure_i_am_root() {
    if ! is_user_root; then

        echo 'Please run this script with root access'.
        exit 1 # Return some script error here.
    fi
}

# Function for checking if package is installed on system
# $1 package name
# Function return true if package is installed otherwise it return false. 
is_package_installed() {
    local REQUIRED_PKG=$1
    local PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
    
    echo Checking for $REQUIRED_PKG: $PKG_OK
    
    if [ "" = "$PKG_OK" ]; then
        return $(false)          
    fi

    return $(true)
}

install_package_if_not_found() {
    local package_name=$1

    if ! is_package_installed $package_name; then

        echo "No $package_name. Setting up $package_name."
        sudo apt-get --yes install $package_name
    fi
}

get_user_home_directory() {
    # if is_user_root; then
    #     exit
    # fi

    local actual_path=$(pwd)
    cd ~

    USER_HOME_DIRECTORY=$(pwd)
    
    cd $actual_path
}

get_script_location() {
    local SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

    echo $SCRIPT_DIR
}

get_desktop_enviroment() {
    echo $DESKTOP_SESSION    
}

is_cinnamon_desktop_environment() {
    local de=$(get_desktop_enviroment)
    
    if [ $de == "cinnamon" ]; then
        true
    fi

    false
}