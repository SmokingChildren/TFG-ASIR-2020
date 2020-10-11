#!/bin/bash
#==========================================================================================
#Autor: Juan Carlos Collado Custodio
#Módulo: Proyecto de Fin de Grado
#Curso: ASIR 2019-2020
#Título: Shell script con interfaz gráfica para gestión de usuarios, procesos y servicios
#==========================================================================================

# VARIABLES

#==========================================================================================

# FUNCIONES

#Para lanzar el resultado de un comando: $ whiptail --textbox /dev/stdin 40 80 <<<"$(ls -l)"

function menu() {
    clear
    option=$(whiptail --title "Administración del Sistema" --menu "Elige una opción" 15 60 4 \
        "1" "Gestión de usuarios" \
        "2" "Gestión de procesos" \
        "3" "Gestión de servicios" \
        "0" "Salir" 3>&1 1>&2 2>&3)

    selected_option=$?
    echo $?
}

#==========================================================================================

# Inicio del script

while [[ true ]]; do
    menu
    case $selected_option in
    1)
        whiptail --infobox "Opción 1" 40 80
        ;;
    2)
        whiptail --infobox "Opción 2" 40 80
        ;;
    3)
        whiptail --infobox "Opción 3" 40 80
        ;;
    0)
        whiptail --infobox "Saliendo" 40 80
        exit
        ;;
    *)
        whiptail --infobox "Opción inválida. Elige otra opción." 40 80
        ;;
    esac
done
