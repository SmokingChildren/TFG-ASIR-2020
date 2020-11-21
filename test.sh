#!/bin/bash

group_mgt_menu() {
    groupmenu_option=$(
        whiptail --title "Gestión de grupos" --nocancel --menu "Seleccione una opción" 15 75 5 \
        "1" "Añadir un nuevo grupo." \
        "2" "Modificar nombre de un grupo." \
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
        if [[ -z "$group_add" ]]; then
            whiptail --title "Error" --msgbox "No has introducido un nombre para el grupo." 0 0
        fi
        groupadd "$group_add"
        whiptail --title "Grupo de usuarios creado" --msgbox "Se ha generado el grupo de usuarios $group_add." 0 0
        ;;
    2)
        #Modificar nombre de grupo
        group_oldname=$(whiptail --title "Introduce el nombre del grupo" --inputbox "Introduce el nombre de grupo que quieres modificar:" 0 0 3>&1 1>&2 2>&3)        
        if [[ -z "$group_oldname" ]]; then
            whiptail --title "Error" --msgbox "No has introducido un nombre para el grupo.\nVolviendo al menú anterior..." 0 0
            break
        fi
        group_oldname_safetycheck=$(getent group $group_oldname | cut -d: -f3)
        if [[ $group_oldname_safetycheck -gt 999 && $group_oldname_safetycheck -lt 65534 || -z "$group_oldname_safetycheck" ]]; then
            whiptail --title "Error" --msgbox "Ese grupo de usuarios no existe o no se puede modificar.\nVolviendo al menú anterior..." 0 0
            break
        fi
        group_newname=$(whiptail --title "Introduce el nombre del grupo" --inputbox "Introduce el nombre de grupo que quieres modificar:" 0 0 3>&1 1>&2 2>&3)
        groupmod -n $group_newname $group_oldname
        if [[ $? -eq 0 ]]; then
            whiptail --title "Grupo de usuarios renombrado" --msgbox "Se ha renombrado el grupo de usuarios $group_oldname a $group_newname." 0 0
        else
            whiptail --title "Error" --msgbox "Se ha producido un error." 0 0
        fi
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
