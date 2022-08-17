#!/bin/bash

#   This is a prototype of automatic installation script for laptop MSI GS65 SteelSeries.
#   This is based on information founded here

# https://wiki.archlinux.org/title/MSI_GS65 
# https://itsfoss.com/display-linux-logo-in-ascii/
# https://github.com/dylanaraps/neofetch/wiki

# Import helped script functions.
source "lib/essenssial.sh"

# Run mousewheel script.
# source "lib/mousewheel.sh"
source "mouse_script.sh"
source "msi_gs65_keyboard.sh"

# -- ==================================== --
# --             SCRIPT MENU              --
# -- ==================================== --
MENU_OPTION_SPEED_MOUSE="1. Speed up mouse"
MENU_OPTION_KEYBOARD_SETTINGS="2. Choose keyboard settings"
MENU_OPTION_CONKY_SETTINGS="3. Conky settings"
MENU_OPTION_TERMINAL_SETTINGS="4. Terminal settings"
MENU_OPTION_INSTALL_SOFTWARE="5. Install addictional software  "
MENU_OPTION_EXIT_SCRIPT="6. End script"

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

main_menu() {

    while [ 1 ]
    do
        SELECTED_MENU_OPTION=$(
            whiptail --title "Choose script function" --menu "This script helps with post linux installation things that can improve user experience with system. \nThis script is prepared for laptop MSI GS65 SteelSeries and debian linux distributions." 25 110 16 \
        "$MENU_OPTION_SPEED_MOUSE" "Speed up mouse cursor with imwheel application" \
        "$MENU_OPTION_KEYBOARD_SETTINGS" "Change keyboard settings. e.g: colors." \
        "$MENU_OPTION_CONKY_SETTINGS" "Conky settings. e.g: install packages (conky), load theme." \
        "$MENU_OPTION_TERMINAL_SETTINGS" "Terminal settings. e.g: install packages (neofetch, screenfetch, cowsay)." \
        "$MENU_OPTION_INSTALL_SOFTWARE" "Install addictional software." \
        "$MENU_OPTION_EXIT_SCRIPT" "End Script" 3>&2 2>&1 1>&3	
        )
        exitstatus=$?

        if [ ! $exitstatus = 0 ]; then
            exit
        fi

        case $SELECTED_MENU_OPTION in
            $MENU_OPTION_SPEED_MOUSE)

                run_mouse_menu
            ;;

            $MENU_OPTION_KEYBOARD_COLOR)
                
                run_color_menu
            ;;

            $MENU_OPTION_EXIT_SCRIPT)
                exit
            ;;
        esac
    done
}




# make_sure_i_am_root;




main_menu




# 
# 1. Install imwheel and adjust (to make things work):
#     
#     *   Run sudo apt install imwheel
#     *   Run bash <(curl -s http://www.nicknorton.net/mousewheel.sh)
#     *   Using the slider adjust the scroll speed 'multiplier'. (I like it on 4/5)
# 
# 2. Add imwheel as a startup application (to make things continue working after restart):
# 
#     *   Open Apps -> Startup Applications
#     *   Add a new entry to the bottom of the list: Name= Wheel Scroll Speed, Command= imwheel, Comment= Activates wheel scroll speed fix on system startup (or whatever you like)
# 
# 
# -- How to configure autostart from linux script.
# 

# Use RGB on Laptop 

# https://search.brave.com/search?q=zenity+checklist&source=web
# https://help.gnome.org/users/zenity/stable/





