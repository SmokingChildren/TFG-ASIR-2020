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
        whiptail --title "Administración del Sistema" --nocancel --menu "Elige una opción" 25 60 6 \
        "1" "Gestión de usuarios." \
        "2" "Gestión de grupos" \
        "3" "Información de procesos." \
        "4" "Información de servicios." \
        "5" "Cambiar esquema de colores." \
        "0" "Salir" 3>&1 1>&2 2>&3
    )
}

user_mgt_menu() {
    usermenu_option=$(
        whiptail --title "Gestión de usuarios" --nocancel --menu "Seleccione una opción" 15 75 5 \
        "1" "Añadir un nuevo usuario." \
        "2" "Modificar datos de un usuario." \
        "3" "Eliminar un usuario del sistema." \
        "4" "Ver información del usuario actual." \
        "0" "Volver" 3>&1 1>&2 2>&3
    )
}

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

process_mgt_menu() {
    processmenu_option=$(
        whiptail --title "Información de procesos" --nocancel --menu "Seleccione una opción" 15 65 4 \
        "1" "Ver procesos activos del sistema." \
        "2" "Ver procesos activos del usuario." \
        "3" "Ver los 10 procesos que más consumen en este momento." \
        "0" "Volver" 3>&1 1>&2 2>&3
    )
}

services_mgt_menu() {
    servicesmenu_option=$(
        whiptail --title "Información del equipo" --nocancel --menu "Seleccione una opción" 15 65 5 \
        "1" "Información del sistema." \
        "2" "Memoria en uso y memoria disponible." \
        "3" "Tiempo que lleva el equipo en marcha." \
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

user_info_menu() {
    user_info_option=$(
        whiptail --title "Modificar información del usuario" --nocancel --menu "Elige el dato que deseas modificar" 15 65 6 \
        "1" "Nombre completo" \
        "2" "Departamento" \
        "3" "Telf. Empresa" \
        "4" "Telf. Personal" \
        "5" "Otros datos" \
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
                nombre_add=$(whiptail --title "Introduce el nombre" --inputbox "Introduce el nombre de usuario" 0 0 3>&1 1>&2 2>&3)
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
                    whiptail --title "Error" --msgbox "Las contraseñas no coinciden. Vuelve a intentarlo." 0 0
                    password_ask
                done
                #En caso de querer meter al usuario en un grupo, se le pregunta:
                whiptail --title "Añadir a grupo" --yesno "¿Deseas añadir al usuario a un grupo específico?" --yes-button "Si" 0 0
                if [[ $? -eq 0 ]]; then
                    group_add=$(whiptail --title "Nombre del grupo" --inputbox "Introduce el nombre del grupo" 0 0 3>&1 1>&2 2>&3)
                    if [[ -z "$group_add" ]]; then
                        whiptail --title "Error" --msgbox "No has introducido el nombre del grupo."
                        break
                    fi
                    useradd -m -p $(echo $password | openssl passwd -1 -stdin) $nombre_add -G $group_add #Se pasa la contraseña por openssl, si no se hace no es recuperable.
                    whiptail --title "Mensaje" --msgbox "Usuario $nombre_add registrado correctamente y añadido al grupo $group_add." 0 0
                elif [[ $? -eq 1 ]]; then
                    useradd -m -p $(echo $password | openssl passwd -1 -stdin) $nombre_add
                    whiptail --title "Mensaje" --msgbox "Usuario $nombre_add registrado correctamente." 0 0
                fi

                ;;

            2)
                user_info=$(whiptail --title "Ejemplo" --inputbox "Introduce el nombre de usuario" 8 39 3>&1 1>&2 2>&3) #Pedir nombre de usuario
                if [[ -z "$user_info" ]]; then
                    whiptail --title "Error" --msgbox "No has introducido un nombre de usuario." 0 0
                    break
                fi
                #Comprobar que el usuario existe. Si no, salir al menú anterior.
                usercheck=$(getent passwd $user_info)
                if [[ -z "$usercheck" ]]; then
                    whiptail --title "Error" --msgbox "No se ha encontrado ese usuario." 0 0
                    break
                fi

                user_info_menu
                case $user_info_option in
                1)
                    #Cambiar nombre
                    user_fullname=$(whiptail --title "Introduce el nombre completo" --inputbox "Introduce el nombre completo del usuario" 0 0 3>&1 1>&2 2>&3)
                    if [[ -z "$user_fullname" ]]; then
                        whiptail --title "Error" --msgbox "No has introducido un nombre." 0 0
                        break
                    fi
                    chfn -f "$user_fullname" $user_info
                    if [[ $? -eq 0 ]]; then
                        whiptail --title "Éxito" --msgbox "Dato cambiado correctamente." 0 0
                    else
                        whiptail --title "Error" --msgbox "Se ha producido un error." 0 0
                    fi
                    ;;
                2)
                    #Cambiar departamento
                    user_room=$(whiptail --title "Introduce el departamento" --inputbox "Introduce el departamento del usuario" 0 0 3>&1 1>&2 2>&3)
                    if [[ -z "$user_room" ]]; then
                        whiptail --title "Error" --msgbox "No has introducido un nombre." 0 0
                        break
                    fi
                    chfn -r "$user_room" $user_info
                    if [[ $? -eq 0 ]]; then
                        whiptail --title "Éxito" --msgbox "Dato cambiado correctamente." 0 0
                    else
                        whiptail --title "Error" --msgbox "Se ha producido un error." 0 0
                    fi
                    ;;
                3)
                    #Cambiar telf. empresa - ¿Añadir regex?
                    user_cnumber=$(whiptail --title "Introduce el teléfono de empresa" --inputbox "Introduce el teléfono de empresa del usuario" 0 0 3>&1 1>&2 2>&3)
                    if [[ -z "$user_cnumber" ]]; then
                        whiptail --title "Error" --msgbox "No has introducido un teléfono." 0 0
                        break
                    fi
                    chfn -w "$user_cnumber" $user_info
                    if [[ $? -eq 0 ]]; then
                        whiptail --title "Éxito" --msgbox "Dato cambiado correctamente." 0 0
                    else
                        whiptail --title "Error" --msgbox "Se ha producido un error." 0 0
                    fi
                    ;;

                4) #Cambiar telf. personal
                    user_pnumber=$(whiptail --title "Introduce el teléfono particular" --inputbox "Introduce el teléfono particular del usuario" 0 0 3>&1 1>&2 2>&3)
                    if [[ -z "$user_pnumber" ]]; then
                        whiptail --title "Error" --msgbox "No has introducido un teléfono." 0 0
                        break
                    fi
                    chfn -h "$user_pnumber" $user_info
                    if [[ $? -eq 0 ]]; then
                        whiptail --title "Éxito" --msgbox "Dato cambiado correctamente." 0 0
                    else
                        whiptail --title "Error" --msgbox "Se ha producido un error." 0 0
                    fi
                    ;;

                5) #Añadir otros datos
                    user_other=$(whiptail --title "Observaciones" --inputbox "Añade cualquier dato de interés sobre el usuario" 0 0 3>&1 1>&2 2>&3)
                    if [[ -z "$user_other" ]]; then
                        whiptail --title "Error" --msgbox "No has introducido nada." 0 0
                        break
                    fi
                    chfn -o "$user_other" $user_info
                    if [[ $? -eq 0 ]]; then
                        whiptail --title "Éxito" --msgbox "Dato cambiado correctamente." 0 0
                    else
                        whiptail --title "Error" --msgbox "Se ha producido un error." 0 0
                    fi
                    ;;

                *)
                    whiptail --title "Error" --msgbox "Opción inválida. Elige otra opción."
                    ;;
                esac
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
                #Información del usuario.
                which finger >/dev/null
                if [[ $? -eq 0 ]]; then
                    whiptail --textbox /dev/stdin 12 0 <<<"$(finger -lp)"
                else
                    whiptail --title "Paquete necesario" --msgbox "Se requiere la instalación del paquete 'finger' para el funcionamiento correcto de esta opción.\n\
Puedes instalarlo con el comando '$ sudo apt install finger' o el equivalente de tu distribución de Linux." 0 0
                fi
                ;;
            0)
                break
                ;;
            esac
        done
        ;;
    2)
        #Menú de creación de grupos
        while :; do
            group_mgt_menu
            case $groupmenu_option in
            1)
                #group_add=$(whiptail --title "Introduce el nombre del grupo" --inputbox "Introduce el nombre de grupo" 0 0 3>&1 1>&2 2>&3)
                whiptail --title "WIP" --msgbox "Gestión de grupos.\nMenú en construcción." 0 0
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
        ;;
    3)
        while :; do
            process_mgt_menu #Gestión de procesos. Ver funciones.
            case $processmenu_option in
            1)
                #whiptail --title "Mensaje" --msgbox "Procesos activos" 0 0
                whiptail --textbox /dev/stdin 20 0 <<<"$(top -b -n 1)"
                ;;
            2)
                me=$(whoami)
                whiptail --textbox /dev/stdin 20 0 <<<"$(top -b -n 1 -u $me)"
                ;;
            3)
                #Procesos que más consumen en este momento (max. 10)
                whiptail --textbox /dev/stdin 20 0 <<<"$(ps -eo %mem,%cpu,comm --sort=-%mem | head -n 11 | column -t)"
                ;;
            0)
                break
                ;;
            esac
        done
        ;;
    4)
        while :; do
            services_mgt_menu #Gestión de servicios y sistema
            case $servicesmenu_option in
            1)
                #Información del sistema.
                whiptail --textbox /dev/stdin 0 0 <<<"$(hostnamectl)"
                ;;
            2)
                #Memoria en uso y memoria disponible
                whiptail --textbox /dev/stdin 15 0 <<<"$(free --si -hw)"
                ;;
            3)
                #Tiempo que lleva el servidor en marcha.
                hora=$(uptime | cut -d"," -f1 | cut -d" " -f2)
                tiempo=$(uptime | cut -d"," -f1 | cut -d" " -f4) #En minutos
                whiptail --title "Tiempo activo" --msgbox "Son las $hora.\nEl equipo lleva encendido $tiempo minutos." 0 0
                ;;
            4)
                #Distribución de discos duros / particiones y su ocupación. Requiere permiso sudo.
                whiptail --textbox /dev/stdin 30 0 <<<"$(parted -l)"
                ;;
            0)
                break
                ;;
            esac
        done
        ;;
    5)
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
