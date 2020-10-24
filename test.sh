#!/bin/sh

color_menu() {
    colormenu=$(
        whiptail --title "Administración del Sistema" --nocancel --radiolist "Elige una opción" 25 60 4 \
        "1" "Color 1" \
        "2" "Color 2" \
        "3" "Color 3" \
        "0" "Salir" 3>&1 1>&2 2>&3)
}

while [[ true ]]; do

    color_menu
    case $colormenu in
    1)
        NEWT_COLORS='
    window=,red
    border=white,red
    textbox=white,red
    button=black,white
    ' \
        whiptail --msgbox "Muestra de colores" 0 0
        ;;
    2)
        NEWT_COLORS='
    window=,blue
    border=white,blue
    textbox=white,blue
    button=black,white
    ' \
        whiptail --msgbox "Muestra de colores" 0 0
        ;;
    3)
        NEWT_COLORS='
    window=,green
    border=white,green
    textbox=white,green
    button=black,white
    ' \
        whiptail --msgbox "Muestra de colores" 0 0
        ;;
    0)
        break
        ;;
    esac
done
