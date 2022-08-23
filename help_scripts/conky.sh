#!/bin/bash

install_all_conky_packages() {
    
    # Here need to be added some addictional packages e.g: hddtemp, lm-sensors 
    install_package_if_not_found conky-all


    local conky_script_name="conky-startup.sh"
    local conky_config_file="lukasz.conkyrc"
    # Create confogiration file if not exist
    if [ ! -d ~/.conky ]; then

        mkdir ~/.conky
        # cp $SCRIPT_DIR/help_scripts/$conky_script_name ~/.conky/$conky_script_name
    fi

    if [ ! -f ~/.conky/$conky_script_name ]; then
        cp $SCRIPT_DIR/help_scripts/.conky/$conky_script_name ~/.conky/$conky_script_name
    fi

        if [ ! -f ~/.conky/$conky_config_file ]; then
        cp $SCRIPT_DIR/help_scripts/.conky/$conky_config_file ~/.conky/$conky_config_file
    fi
}