#!/bin/bash

# This script is based on Nick Norton script for speed up mouse wheel.
# This version of script uses whiptail linux built in controls instead of gnome zenity.
# Original version of script is available here: http://www.nicknorton.net/mousewheel.sh



function install_all_mouse_packages {
    # -- ==================================== --
    # --         Speed Up mouse wheel         --
    # -- ==================================== --

    # Original post: https://askubuntu.com/questions/255890/how-can-i-adjust-the-mouse-scroll-sp

    install_package_if_not_found imwheel
    install_package_if_not_found zenity  
}

function run_mousewheel_script {
if [ ! -f ~/.imwheelrc ]
then

cat >~/.imwheelrc<<EOF
".*"
None,      Up,   Button4, 1
None,      Down, Button5, 1
Control_L, Up,   Control_L|Button4
Control_L, Down, Control_L|Button5
Shift_L,   Up,   Shift_L|Button4
Shift_L,   Down, Shift_L|Button5
EOF

fi
##########################################################

CURRENT_VALUE=$(awk -F 'Button4,' '{print $2}' ~/.imwheelrc)
NEW_VALUE=""

until [[ $NEW_VALUE =~ ^[0-9]+$ ]] && [ $NEW_VALUE -gt 0 ] && [ $NEW_VALUE -lt 100 ]; do
    NEW_VALUE=$(whiptail --inputbox "Enter mouse wheel speed: (accepted values 1-99). \nActual speed value: $(echo $CURRENT_VALUE)" 8 78 $CURRENT_VALUE --title "Mouse speed" 3>&1 1>&2 2>&3)
    exitstatus=$?
    
    if [ ! $exitstatus = 0 ]; then
        echo "User selected Cancel."
        NEW_VALUE=""
        break;
    fi
done

if [ -z "$NEW_VALUE" ]; then 
    run_mouse_menu
fi

sed -i "s/\($TARGET_KEY *Button4, *\).*/\1$NEW_VALUE/" ~/.imwheelrc # find the string Button4, and write new value.
sed -i "s/\($TARGET_KEY *Button5, *\).*/\1$NEW_VALUE/" ~/.imwheelrc # find the string Button5, and write new value.

cat ~/.imwheelrc

echo "Restart imwheel application"
imwheel -kill
}

function run_mouse_menu {
    local MOUSE_OPTION_INSTALL_PACKAGES="1). Install all packages"
    local MOUSE_OPTION_CHANGE_SPEED="2). Change mouse wheel speed"
    local MOUSE_OPTION_GO_BACK="5). < Go Back"

    local SELECTED_MOUSE_MENU_OPTION=$(
    whiptail --title "Mouse settings" --menu "\nHere you can change mouse settings with imwheel tool" 25 100 16 \
    "$MOUSE_OPTION_INSTALL_PACKAGES" "Install all required packages" \
    "$MOUSE_OPTION_CHANGE_SPEED" "Change mouse wheel speed" \
    "$MOUSE_OPTION_GO_BACK" "Go Back to prevorius screen." 3>&2 2>&1 1>&3	
    )

    local exit_status=$?
    
    if [ ! $exit_status = 0 ]; then
        return
    fi

    case $SELECTED_MOUSE_MENU_OPTION in

        $MOUSE_OPTION_INSTALL_PACKAGES)

            install_all_mouse_packages

            run_mouse_menu
        ;;

        $MOUSE_OPTION_CHANGE_SPEED)

            run_mousewheel_script

            run_mouse_menu
        ;;

        $MOUSE_OPTION_GO_BACK)
            return
        ;;
    esac    
}