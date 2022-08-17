#!/bin/bash

# git clone https://github.com/Askannz/msi-perkeyrgb
# cd msi-perkeyrgb/
# sudo python3 setup.py install
# sudo cp 99-msi-rgb.rules /etc/udev/rules.d/

function install_all_keyboard_packages {

    install_package_if_not_found zenity
    install_package_if_not_found git
    install_package_if_not_found python3-setuptool
    make_sure_msi_perkeyrgb_is_installed

    run_color_menu    
}

function make_sure_msi_perkeyrgb_is_installed {
    local git_folder_path="./external_source_codes/msi-perkeyrgb"
    local repository_path="https://github.com/Askannz/msi-perkeyrgb.git"
    
    if command -v msi-perkeyrgb
    then
        return
    fi

    # Clone repository from github.
    if [ ! -d $git_folder_path ]
    then
        git clone $repository_path $git_folder_path
    fi

    cd msi-perkeyrgb/
    sudo python3 setup.py install
    sudo cp 99-msi-rgb.rules /etc/udev/rules.d/
    cd ..

    # chmod 666 /dev/hidraw*
}

function run_keyboard_configuration {
    local MYLIST=`for x in $(msi-perkeyrgb --model GS65 --list-presets | awk -F '- ' '{print $2}' | sed -r '/^\s*$/d'); do echo $x "$x" "OFF"; done`
    local SELECTED_COLOR=""

    while [ "$SELECTED_COLOR" == "" ]; do

        SELECTED_COLOR=$(whiptail --title "Built-in preset" --radiolist \
        "\nChoose Built-in keyboard color preset for laptop GS65 SteelSeries" 20 42 10 $MYLIST 3>&1 1>&2 2>&3)
        local exit_status=$?

        if [ ! $exit_status = 0 ]; then
            echo "User selected Cancel."
            break;
            run_color_menu
        fi

    done

    if [ -z "$SELECTED_COLOR" ]; then
        return
    fi

    echo 'Change keyboard color'
    msi-perkeyrgb --model GS65 -p $SELECTED_COLOR

    run_color_menu
}

function choose_keyboard_solid_color {

    local SELECTED_SOLID_COLOR=$(zenity --color-selection --color red --show-palette)

    if [ -z "$SELECTED_SOLID_COLOR" ]; then
        return
    fi

    local rgbColor=$(echo $SELECTED_SOLID_COLOR | awk -F 'rgb' '{print $2}')
    local hexColor=""

    if [[ $rgbColor =~ ([[:digit:]]{1,3}),([[:digit:]]{1,3}),([[:digit:]]{1,3}) ]]; then
        hexColor=$(printf "%02x%02x%02x\n" \
            "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}" "${BASH_REMATCH[3]}")
    fi

    if [ -z "$hexColor" ]; then 
        return
    fi

    msi-perkeyrgb --model GS65 -s $hexColor
    run_color_menu
}

function create_msi_rgb_switch_for_current_user {
    if [ ! -d ~/bin ]; then
        mkdir ~/bin
    fi

    local script_file_name=$1

    if [ ! -f ~/bin/$script_file_name ]; then
        cp $SCRIPT_DIR/lib/$script_file_name ~/bin/$script_file_name
    fi

    if [ ! -x ~/bin/$script_file_name ]; then
        chmod +x ~/bin/$script_file_name
    fi
}

function create_rgb_switch_key_binding {

    # TODO: Change it into switch statement    
    if [ ! is_cinnamon_desktop_environment ]; then
        return
    fi

    local scriptName=$1
    python3 $SCRIPT_DIR/help_scripts/keyboard_shortcuts.py
}

function bind_keys_to_built_in_preset {
    local scriptName="msi-rgb-switch.sh"
    create_msi_rgb_switch_for_current_user $scriptName

    create_rgb_switch_key_binding $scriptName

    whiptail --title "Bind $scriptName script." --msgbox "RGB script is coppied into ~/bin/$scriptName. \
    \nYou can run this script from bash by typing $scriptName \
    \nNow you can create keyboard shortcut e.g Win+F7 to run this script on demand. \
    \nIf you ran this script for the first time it may be neccesairly to logout first to changes takes effect." 15 78

    run_color_menu
}

function run_color_menu {
    local COLOR_OPTION_INSTALL_PACKAGES="1). Install all packages"
    local COLOR_OPTION_BUILT_IN_PRESET="2). Built in preset"
    local COLOR_OPTION_SOLID_COLOR="3). Choose solid color"
    local COLOR_OPTION_BIND_KEYS="4). Bind Win+F7 keys."     
    local COLOR_OPTION_GO_BACK="5). < Go Back"

    local SELECTED_COLOR_MENU_OPTION=$(
    whiptail --title "MSI GS65 Keyboard Color / Effect" --menu "\nHere you can change color / effect of keyboard in laptop MSI GS65 SteelSeries" 25 100 16 \
    "$COLOR_OPTION_INSTALL_PACKAGES" "Install all required packages" \
    "$COLOR_OPTION_BUILT_IN_PRESET" "Choose from available built in presets" \
    "$COLOR_OPTION_SOLID_COLOR" "Choose from solid color settings. This setting require zenity package." \
    "$COLOR_OPTION_BIND_KEYS" "Bind Win+F7 keys for switching built in color presets." \
    "$COLOR_OPTION_GO_BACK" "Go Back to prevorius screen." 3>&2 2>&1 1>&3	
    )

    local exit_status=$?
    
    if [ ! $exit_status = 0 ]; then
        return
    fi

    case $SELECTED_COLOR_MENU_OPTION in

        $COLOR_OPTION_INSTALL_PACKAGES)

            install_all_keyboard_packages
        ;;

        $COLOR_OPTION_BUILT_IN_PRESET)

            run_keyboard_configuration
        ;;

        $COLOR_OPTION_SOLID_COLOR)
            
            choose_keyboard_solid_color
        ;;

        $COLOR_OPTION_BIND_KEYS)
            
            bind_keys_to_built_in_preset
        ;;
        $COLOR_OPTION_GO_BACK)
            return
        ;;
    esac
}