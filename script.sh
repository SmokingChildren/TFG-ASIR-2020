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

function mainmenu() { #De este menú derivan el resto de submenús.
    clear
    mainmenu_option=$(whiptail --title "Administración del Sistema" --menu "Elige una opción" 25 60 4 \
        "1" "Gestión de usuarios" \
        "2" "Gestión de procesos" \
        "3" "Gestión de servicios" \
        "0" "Salir" 3>&1 1>&2 2>&3) #Esto último intercambia stdin y stderr.
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
    processmenu_option=$(whiptail --title "Gestión de procesos" --menu "Seleccione una opción" 15 65 5 \
    "1" "Ver procesos activos." \
    "2" "Ver procesos que más consumen en este momento (max. 10)." \
    "3" "Detener o arrancar procesos." \
    "4" "Opcion no implementada." \
    "0" "Volver" 3>&1 1>&2 2>&3)
}

function services_mgt_menu(){
    servicesmenu_option=$(whiptail --title "Gestión de servicios" --menu "Seleccione una opción" 15 65 5 \
    "1" "Información del sistema." \
    "2" "Memoria en uso y memoria disponible." \
    "3" "Tiempo que lleva el servidor en marcha." \
    "4" "Capacidad disponible de discos duros / particiones." \
    "0" "Volver" 3>&1 1>&2 2>&3)
}

function password_ask(){
    password=$(whiptail --passwordbox "Introduce contraseña" 8 39 --title "Password" 3>&1 1>&2 2>&3)
    passwordcheck=$(whiptail --passwordbox "Introduce confirmación de contraseña" 8 39 --title "Password" 3>&1 1>&2 2>&3)
}
#==========================================================================================

# Inicio del script

while [[ true ]]; do #Se puede hacer con condición expresamente, pero no es necesario.
    mainmenu
    case $mainmenu_option in
    1)
        while [[ true ]]; do
            user_mgt_menu #Gestión de usuarios. Ver funciones.
            case $usermenu_option in
            1) #whiptail --title "Mensaje" --msgbox "Añadir usuario" 40 80
                nombre=$(whiptail --inputbox "Introduce el nombre de usuario" 8 39 Nombre --title "Ejemplo" 3>&1 1>&2 2>&3)
                password_ask
                until [[ $password == $passwordcheck ]]; do
                    whiptail --title "Error" --msgbox "Las contraseñas no coinciden" 40 80
                    password_ask
                done
                whiptail --title "Mensaje" --msgbox "El nombre es $nombre y la contraseña es $password." 40 80 #TO-DO: Cambiar por un useradd con los argumentos
                ;;
            2)
                whiptail --title "Mensaje" --msgbox "Modificar usuario" 40 80 #Estos mensajes hay que sustituirlos por las funciones correspondientes.
                ;;
            3)
                whiptail --title "Mensaje" --msgbox "Eliminar usuario" 40 80 #TO-DO: Añadir confirmación de eliminación.
                ;;
            4)
                whiptail --title "Mensaje" --msgbox "Información del usuario." 40 80 #Grupos, carpetas y algo más de info (TBD).
                ;;
            0)
                break 
                ;;
            esac
        done
        ;;
    2)        
        while [[ true ]]; do
            process_mgt_menu #Gestión de procesos. Ver funciones.
            case $processmenu_option in
            1) whiptail --title "Mensaje" --msgbox "Procesos activos" 40 80 #TO-DO: ¿Mostrar resultado de un ps o un top?
                ;;
            2)
                #Procesos que más consumen en este momento (max. 10)
                whiptail --textbox /dev/stdin 20 40 <<<"$(ps -eo %mem,%cpu,comm --sort=-%mem | head -n 11)"
                ;;
            3)
                whiptail --title "Mensaje" --msgbox "Detener procesos (submenú)." 40 80 #TO-DO: Bucle for, mostrar procesos en opciones radio, detener proceso seleccionado.
                ;;
            4)
                whiptail --title "Mensaje" --msgbox "Opcion no implementada (Placeholder)." 40 80 #TBD. 
                ;;
            0)
                break 
                ;;
            esac
        done
        ;;
    3)
        while [[ true ]]; do
            services_mgt_menu #Gestión de servicios y sistema
            case $servicesmenu_option in
            1) #Información del sistema.
                whiptail --textbox /dev/stdin 20 60 <<<"$(hostnamectl)"
                ;;
            2)
                #Memoria en uso y memoria disponible
                whiptail --textbox /dev/stdin 15 90 <<<"$(free)"
                ;;
            3)
                #Tiempo que lleva el servidor en marcha.
                whiptail --textbox /dev/stdin 10 70 <<<"$(uptime)"
                ;;
            4)
                #Distribución de discos duros / particiones y su ocupación
                whiptail --textbox /dev/stdin  30 90 <<<"$(df -h)"
                ;;
            0)
                break 
                ;;
            esac
        done
        ;;
    0)
        whiptail --title "Mensaje" --msgbox "Gracias por utilizar este servicio." 10 70
        exit
        ;;
    *)
        whiptail --title "Mensaje" --msgbox "Opción no válida. Elige otra opción." 40 80
        ;;
    esac
done