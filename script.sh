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
    mainmenu_option=$(whiptail --title "Administración del Sistema" --menu "Elige una opción" 25 60 4 \
        "1" "Gestión de usuarios" \
        "2" "Gestión de procesos" \
        "3" "Gestión de servicios" \
        "0" "Salir" 3>&1 1>&2 2>&3)
}

function user_mgt_menu() {
    usermenu_option=$(whiptail --title "Gestión de usuarios" --menu "Seleccione una opción" 15 50 5 \
    "1" "Añadir nuevo usuario." \
    "2" "Modificar datos de usuario." \
    "3" "Eliminar usuario del sistema." \
    "4" "Ver información de usuario." \
    "0" "Volver" 3>&1 1>&2 2>&3)
}

function process_mgt_menu(){
    processmenu_option=$(whiptail --title "Gestión de procesos" --menu "Seleccione una opción" 15 50 5 \
    "1" "Ver procesos activos." \
    "2" "Ver procesos que más consumen en este momento (max. 10)." \
    "3" "Detener o arrancar procesos." \
    "4" "Opcion no implementada." \
    "0" "Volver" 3>&1 1>&2 2>&3)
}

function services_mgt_menu(){
    servicesmenu_option=$(whiptail --title "Gestión de servicios" --menu "Seleccione una opción" 15 50 5 \
    "1" "Información del sistema." \
    "2" "Memoria en uso y memoria disponible." \
    "3" "Tiempo que lleva el servidor en marcha." \
    "4" "Capacidad disponible de discos duros / particiones." \
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
        #whiptail --title "Mensaje" --msgbox "Opción 2" 40 80
        while [[ true ]]; do
            process_mgt_menu
            case $processmenu_option in
            1) whiptail --title "Mensaje" --msgbox "Procesos activos" 40 80
                ;;
            2)
                #Procesos que más consumen en este momento (max. 10)
                whiptail --textbox /dev/stdin 50 60 <<<"$(ps -eo %mem,%cpu,comm --sort=-%mem | head -n 11)"
                ;;
            3)
                whiptail --title "Mensaje" --msgbox "Detener procesos (submenú)." 40 80
                ;;
            4)
                whiptail --title "Mensaje" --msgbox "Opcion no implementada." 40 80
                ;;
            0)
                break 
                ;;
            esac
        done
        ;;
    3)
        #whiptail --title "Mensaje" --msgbox "Opción 3" 40 80
        while [[ true ]]; do
            services_mgt_menu
            case $servicesmenu_option in
            1) #"nformación del sistema.
                whiptail --textbox /dev/stdin 30 40 <<<"$(hostnamectl)"
                ;;
            2)
                #Memoria en uso y memoria disponible
                whiptail --textbox /dev/stdin 30 40 <<<"$(free)"
                ;;
            3)
                #Tiempo que lleva el servidor en marcha.
                whiptail --textbox /dev/stdin 30 40 <<<"$(uptime)"
                ;;
            4)
                #Distribución de discos duros / particiones y su ocupación
                whiptail --textbox /dev/stdin 30 40 <<<"$(df -h)"
                ;;
            0)
                break 
                ;;
            esac
        done
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
