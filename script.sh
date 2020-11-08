#!/bin/bash
LC_ALL=es_ES.UTF-8
#==========================================================================================
#Autor: Juan Carlos Collado Custodio
#Módulo: Proyecto de Fin de Grado
#Curso: ASIR 2019-2020
#Título: Shell script con interfaz gráfica para gestión de usuarios, procesos y servicios
#==========================================================================================

# FUNCIONES

#Para lanzar el resultado de un comando (p. ej. "ls -l"): $ whiptail --textbox /dev/stdin 40 80 <<<"$(ls -l)"

# admintest() {
#     admincheck=$(
#         whiptail --title "Se requiere permiso de Administrador" --yesno "Este script requiere permisos de administrador para funcionar correctamente. \n \
#     ¿Eres administrador del equipo? S/N" 20 60 3>&1 1>&2 2>&3 #Esto último intercambia stdin y stderr, ya que whiptail usa stderr en lugar de $?
#     )
# }
#Función comentada por si es de utilidad más tarde, no funciona bien cuando pide contraseña de sudo (se repite).

mainmenu() { #De este menú derivan el resto de submenús.
    mainmenu_option=$(
        whiptail --title "Administración del Sistema" --nocancel --menu "Elige una opción" 25 60 5 \
        "1" "Gestión de usuarios." \
        "2" "Gestión de procesos." \
        "3" "Gestión de servicios." \
        "4" "Cambiar esquema de colores." \
        "0" "Salir" 3>&1 1>&2 2>&3
    )
}

user_mgt_menu() {
    usermenu_option=$(
        whiptail --title "Gestión de usuarios" --nocancel --menu "Seleccione una opción" 15 50 5 \
        "1" "Añadir un nuevo usuario." \
        "2" "Modificar datos de un usuario. (No implementado)" \
        "3" "Eliminar un usuario del sistema." \
        "4" "Ver información del usuario actual. (No implementado)" \
        "0" "Volver" 3>&1 1>&2 2>&3
    )
}

process_mgt_menu() {
    processmenu_option=$(
        whiptail --title "Gestión de procesos" --nocancel --menu "Seleccione una opción" 15 65 4 \
        "1" "Ver procesos activos. (No implementado)" \
        "2" "Ver los 10 procesos que más consumen en este momento." \
        "3" "Detener procesos. (No implementado)" \
        "0" "Volver" 3>&1 1>&2 2>&3
    )
}

services_mgt_menu() {
    servicesmenu_option=$(
        whiptail --title "Gestión de servicios" --nocancel --menu "Seleccione una opción" 15 65 5 \
        "1" "Información del sistema." \
        "2" "Memoria en uso y memoria disponible." \
        "3" "Tiempo que lleva el servidor en marcha." \
        "4" "Capacidad disponible de discos duros / particiones." \
        "0" "Volver" 3>&1 1>&2 2>&3
    )
}

color_change_menu() {
    colormenuoption=$(
        whiptail --title "Cambiar combinación de colores" --nocancel --menu "Elige un tema" 20 78 4 \
        "1" "Oscuro" \
        "2" "Claro" \
        "3" "Claro/Cyan" \
        "0" "Salir" 3>&1 1>&2 2>&3
    )
}

password_ask() {
    password=$(whiptail --title "Password" --passwordbox "Introduce contraseña" 8 39 3>&1 1>&2 2>&3)
    passwordcheck=$(whiptail --title "Password" --passwordbox "Introduce confirmación de contraseña" 8 39 3>&1 1>&2 2>&3)
}

#name_del_check() {
#}
#==========================================================================================

# Inicio del script
clear
#admintest
if [ $UID != 0 ]; then
    whiptail --title "Error" --msgbox "Este script se debe lanzar como Administrador (sudo). Se cerrará el programa tras este aviso." 0 0
    exit
else
    whiptail --title "Bienvenido" --msgbox "Permiso de Administrador reconocido. Puede continuar." 0 0
fi

while :; do
    mainmenu
    case $mainmenu_option in
    1)
        while :; do
            user_mgt_menu #Gestión de usuarios. Ver funciones.
            case $usermenu_option in
            1)
                nombre_add=$(whiptail --title "Ejemplo" --inputbox "Introduce el nombre de usuario" 8 39 nombreusuario 3>&1 1>&2 2>&3)
                if [[ -z "$nombre_add" ]]; then #Si no has metido un nombre, te saca al menú anterior.
                    whiptail --title "Error" --msgbox "No has introducido un nombre de usuario." 0 0
                    break
                fi
                password_ask
                if [[ -z "$password" ]]; then #Si no has metido una contraseña, te saca al menú anterior.
                    whiptail --title "Error" --msgbox "No has introducido una contraseña." 0 0
                    break
                fi
                until [[ $password == $passwordcheck ]]; do
                    whiptail --title "Error" --msgbox "Las contraseñas no coinciden" 0 0
                    password_ask
                done
                useradd -m -p $(echo $password | openssl passwd -1 -stdin) $nombre_add
                whiptail --title "Mensaje" --msgbox "Usuario $nombre_add registrado correctamente." 0 0
                #TO-DO: Condicional comprobando que no falla.
                #Comprobar la variable $nombre_add si coincide con la última línea de /etc/passwd
                ;;
            2)
                whiptail --title "Mensaje" --msgbox "Modificar datos de un usuario" 0 0
                #Pedir nombre de usuario
                #Comprobar que el usuario existe. Si no, salir al menú anterior.
                #Mostrar menú radio con las opciones a cambiar.
                ;;
            3)
                #Pedir nombre del usuario
                nombre_del=$(whiptail --title "Ejemplo" --inputbox "Introduce el nombre de usuario a eliminar" 8 50 nombreusuario 3>&1 1>&2 2>&3)
                if [[ -z "$nombre_del" ]]; then #Si no has metido un nombre, te saca al menú anterior.
                    whiptail --title "Error" --msgbox "No has introducido un nombre de usuario." 0 0
                    break
                fi
                #Comprobar que existe ese usuario y que no es del sistema (ver en /etc/passwd que es superior a 1000)
                safety_check=$(getent passwd $nombre_del | cut -d: -f3)
                if [[ $safety_check -gt 999 && $safety_check -lt 65534 ]]; then
                    userdel -r $nombre_del
                    whiptail --title "Correcto" --msgbox "Usuario $nombre_del eliminado correctamente." 0 0 #Mensaje de confirmación
                else
                    whiptail --title "Error" --msgbox "Error: ese usuario no existe o no se puede eliminar." 0 0
                fi
                ;;
            4)
                whiptail --title "Mensaje" --msgbox "Información del usuario." 0 0 #Grupos, carpetas y algo más de info (TBD).

                ;;
            0)
                break
                ;;
            esac
        done
        ;;
    2)
        while :; do
            process_mgt_menu #Gestión de procesos. Ver funciones.
            case $processmenu_option in
            1)
                whiptail --title "Mensaje" --msgbox "Procesos activos" 0 0
                #TO-DO: ¿Mostrar resultado de un ps o un top?
                ;;
            2)
                #Procesos que más consumen en este momento (max. 10)
                whiptail --textbox /dev/stdin 20 40 <<<"$(ps -eo %mem,%cpu,comm --sort=-%mem | head -n 11)"
                ;;
            3)
                whiptail --title "Mensaje" --msgbox "Detener procesos (submenú)." 0 0
                #TO-DO: Bucle for, mostrar procesos en lista de opciones, detener proceso seleccionado.
                ;;
            0)
                break
                ;;
            esac
        done
        ;;
    3)
        while :; do
            services_mgt_menu #Gestión de servicios y sistema
            case $servicesmenu_option in
            1)
                #Información del sistema.
                whiptail --textbox /dev/stdin 0 0 <<<"$(hostnamectl)"
                ;;
            2)
                #Memoria en uso y memoria disponible
                whiptail --textbox /dev/stdin 0 0 <<<"$(free --si -hw)"
                ;;
            3)
                #Tiempo que lleva el servidor en marcha.
                whiptail --textbox /dev/stdin 0 0 <<<"$(uptime)"
                ;;
            4)
                #Distribución de discos duros / particiones y su ocupación. Requiere permiso sudo.
                whiptail --textbox /dev/stdin 0 0 <<<"$(parted -l)"
                ;;
            0)
                break
                ;;
            esac
        done
        ;;
    4)
        while :; do
            color_change_menu
            case $colormenuoption in
            1)
                #Oscuro - Falta añadir más parámetros, esto son de prueba
                export NEWT_COLORS='
                root=,gray
                window=white,black
                title=magenta,black
                border=white,black
                textbox=white,black
                button=magenta,black
                '
                whiptail --msgbox "Muestra de colores" 0 0
                ;;
            2)
                #Claro - Falta añadir más parámetros, esto son de prueba
                export NEWT_COLORS='
                root=,lightgray
                window=black,white
                title=black,blue
                border=black,white
                textbox=black,white
                button=black,blue
                '
                whiptail --msgbox "Muestra de colores" 0 0
                ;;
            3)
                #Cyan - Falta añadir más parámetros, esto son de prueba
                export NEWT_COLORS='
                root=,lightgray
                window=black,cyan
                title=black,blue
                border=black,cyan
                textbox=black,cyan
                button=black,blue
                '
                whiptail --msgbox "Muestra de colores" 0 0
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
