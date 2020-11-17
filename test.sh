#!/bin/bash

group_mgt_menu() {
    groupmenu_option=$(
        whiptail --title "Gestión de grupos" --nocancel --menu "Seleccione una opción" 15 75 5 \
        "1" "Añadir un nuevo grupo." \
        "2" "Modificar datos de un grupo." \
        "3" "Eliminar un grupo del sistema." \
        "4" "Ver información del grupo actual." \
        "0" "Volver" 3>&1 1>&2 2>&3
    )
}
#Menú de creación de grupos
while :; do
    group_mgt_menu
    case $groupmenu_option in
    1)
        group_add=$(whiptail --title "Introduce el nombre del grupo" --inputbox "Introduce el nombre de grupo" 0 0 3>&1 1>&2 2>&3)
        ;;
    2)
        #Opcion 2
        whiptail --title "WIP" --msgbox "Gestión de grupos.\nMenú en construcción." 0 0
        ;;
    3)
        #Opcion 3
        whiptail --title "WIP" --msgbox "Gestión de grupos.\nMenú en construcción." 0 0
        ;;
    4)
        #Opcion 4
        whiptail --title "WIP" --msgbox "Gestión de grupos.\nMenú en construcción." 0 0
        ;;
    0)
        break
        ;;
    *)
        whiptail --title "Error" --msgbox "Opción inválida. Elige otra opción."
        ;;
    esac

done
