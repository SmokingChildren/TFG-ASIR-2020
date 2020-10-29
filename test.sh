#!/bin/bash

function color_menu(){
    colormenu_opt=$(whiptail --title "Colores" --radiolist "Elige un color" 20 78 4 \
        "1" "Rojo" ON \
        "2" "Azul" OFF \
        "3" "Verde" OFF \
        "0" "Salir" OFF)
}

while [[ true ]]; do
    color_menu
    case $colormenu_opt in
    10)
        export NEWT_COLORS='
        window=,red
        border=white,red
        textbox=white,red
        button=black,white
        '
        whiptail --msgbox "Muestra de colores" 0 0
        ;;
    20)
        export NEWT_COLORS='
        window=,blue
        border=white,blue
        textbox=white,blue
        button=black,white
        '
        whiptail --msgbox "Muestra de colores" 0 0
        ;;
    30)
        export NEWT_COLORS='
        window=,green
        border=white,green
        textbox=white,green
        button=black,white
        '
        whiptail --msgbox "Muestra de colores" 0 0
        ;;
    00)
        break
        ;;
    *)
        whiptail --msgbox "Error" 0 0
        ;;
    esac
done
