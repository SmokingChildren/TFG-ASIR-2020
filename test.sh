#!/bin/bash

colormenuoption=""

color_change_menu() {
    clear
    colormenuoption=$(
        whiptail --title "Colores" --radiolist \
        "Elige un color" 20 78 4 \
        "1" "Rojo" ON \
        "2" "Azul" OFF \
        "3" "Verde" OFF \
        "0" "Salir" OFF 3>&1 1>&2 2>&3
    )
}

while [ true ]; do
    color_change_menu
    case $colormenuoption in
    1)
        export NEWT_COLORS='
        window=,red
        border=white,red
        textbox=white,red
        button=black,white
        '
        whiptail --msgbox "Muestra de colores" 0 0
        ;;
    2)
        export NEWT_COLORS='
        window=,blue
        border=white,blue
        textbox=white,blue
        button=black,white
        '
        whiptail --msgbox "Muestra de colores" 0 0
        ;;
    3)
        export NEWT_COLORS='
        window=,green
        border=white,green
        textbox=white,green
        button=black,white
        '
        whiptail --msgbox "Muestra de colores" 0 0
        ;;
    0)
        exit
        ;;
    *)
        whiptail --msgbox "Error" 0 0
        ;;
    esac
done