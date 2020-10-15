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

function mainmenu() {
    clear
    mainmenu_option=$(whiptail --title "Administración del Sistema" --menu "Elige una opción" 15 60 4 \
        "1" "Gestión de usuarios" \
        "2" "Gestión de procesos" \
        "3" "Gestión de servicios" \
        "0" "Salir" 3>&1 1>&2 2>&3)

    echo $?
}

function user_mgt_menu() {
    usermenu_option=$(whiptail --title "Gestión de usuarios" --menu "Seleccione una opción" 10 60 4 \
    "1" "Añadir nuevo usuario." \
    "2" "Modificar datos de usuario." \
    "3" "Eliminar usuario del sistema." \
    "4" "Ver información de usuario." \
    "0" "Volver" 3>&1 1>&2 2>&3)
}

function process_mgt_menu(){
    usermenu_option=$(whiptail --title "Gestión de procesos" --menu "Seleccione una opción" 10 60 4 \
    "1" "Procesos activos." \
    "2" "Modificar datos de usuario." \
    "3" "Eliminar usuario del sistema." \
    "4" "Ver información de usuario." \
    "0" "Volver" 3>&1 1>&2 2>&3)
}

function services_mgt_menu(){
    usermenu_option=$(whiptail --title "Gestión de servicios" --menu "Seleccione una opción" 10 60 4 \
    "1" "Añadir nuevo usuario." \
    "2" "Modificar datos de usuario." \
    "3" "Eliminar usuario del sistema." \
    "4" "Ver información de usuario." \
    "0" "Volver" 3>&1 1>&2 2>&3)
}

#==========================================================================================

# Inicio del script

while [[ true ]]; do
    mainmenu
    case $mainmenu_option in
    1)
        #whiptail --title "Mensaje" --msgbox "Opción 1" 40 80
        while [[ true ]]; do
            user_mgt_menu
            case $usermenu_option in
            1) whiptail --title "Mensaje" --msgbox "Añadir usuario" 40 80
                ;;
            2)
                whiptail --title "Mensaje" --msgbox "Modificar usuario" 40 80
                ;;
            3)
                whiptail --title "Mensaje" --msgbox "Eliminar usuario" 40 80
                ;;
            4)
                whiptail --title "Mensaje" --msgbox "Información del usuario." 40 80
                ;;
            0)
                break 
                ;;
            esac
        done
        ;;
    2)
        whiptail --title "Mensaje" --msgbox "Opción 2" 40 80
        ;;
    3)
        whiptail --title "Mensaje" --msgbox "Opción 3" 40 80
        ;;
    0)
        whiptail --title "Mensaje" --msgbox "Saliendo" 40 80
        exit
        ;;
    *)
        whiptail --title "Mensaje" --msgbox "Opción inválida. Elige otra opción." 40 80
        ;;
    esac
done
