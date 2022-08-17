#!/usr/bin/env python3

import os
import subprocess

custom_args = "custom"
key_binding_name_b=b"'Keyboard_RGB_Switch'\n"
key_binding_name="Keyboard_RGB_Switch"
key_binding_binding = "['<Super>F7']"
key_binding_command = "'msi-rgb-switch.sh'"
custom_list = ["__dummy__"]

binding_exist = False

index = 0

while True:
    process1 = subprocess.run(['dconf read /org/cinnamon/desktop/keybindings/custom-keybindings/custom' + str(index) + '/name'], shell=True, capture_output=True)
    
    if process1.stdout == key_binding_name_b:
        binding_exist = True
        break
    
    if process1.stdout == b'':
        binding_exist = False
        custom_list.append(custom_args + str(index))
        break 
    
    custom_list.append(custom_args + str(index))    
    index = index + 1
    
if binding_exist == False:
    output_custom_list = ""

    # print ('dconf write /org/cinnamon/desktop/keybindings/custom-keybindings/custom' + str(index) + '/name ' "\"'" + key_binding_name + "'\"")
    # print ('dconf write /org/cinnamon/desktop/keybindings/custom-keybindings/custom' + str(index) + '/binding ' "\"" + key_binding_binding + "\"")
    # print ('dconf write /org/cinnamon/desktop/keybindings/custom-keybindings/custom' + str(index) + '/command ' "\"" + key_binding_command + "\"")
    
    subprocess.run(['dconf write /org/cinnamon/desktop/keybindings/custom-keybindings/custom' + str(index) + '/name ' "\"'" + key_binding_name + "'\""], shell=True)
    subprocess.run(['dconf write /org/cinnamon/desktop/keybindings/custom-keybindings/custom' + str(index) + '/binding ' "\"" + key_binding_binding + "\""], shell=True)
    subprocess.run(['dconf write /org/cinnamon/desktop/keybindings/custom-keybindings/custom' + str(index) + '/command ' "\"" + key_binding_command + "\""], shell=True)
    
    for ind, i in enumerate(custom_list):
        if ind == 0:
            output_custom_list = output_custom_list + "'" + i + "'"
        
        else:
            output_custom_list = output_custom_list + ", " + "'" + i + "'" 
    # print ('dconf write /org/cinnamon/desktop/keybindings/custom-list ' "\"[" + output_custom_list + "]\"")
        
    subprocess.run(['dconf write /org/cinnamon/desktop/keybindings/custom-list ' "\"[" + output_custom_list + "]\""], shell=True)