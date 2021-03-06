#!/bin/bash
LC_ALL=es_ES.UTF-8
#==========================================================================================
#Autor: Juan Carlos Collado Custodio
#Módulo: Proyecto de Fin de Grado
#Curso: ASIR 2019-2020
#Título: Shell script con interfaz gráfica para gestión de usuarios, procesos y servicios
#Instituto: IES Virgen de la Paz (Alcobendas)
#==========================================================================================

# FUNCIONES

#Para lanzar el resultado de un comando (p. ej. "ls -l"): $ whiptail --textbox /dev/stdin 40 80 <<<"$(ls -l)"

mainmenu() { #De este menú derivan el resto de submenús.
    mainmenu_option=$(
        whiptail --title "Administración del Sistema" --nocancel --menu "Elige una opción" 0 0 6 \
        "A" "Gestión de usuarios." \
        "B" "Gestión de grupos" \
        "C" "Información de procesos." \
        "D" "Información del sistema." \
        "E" "Cambiar esquema de colores." \
        "X" "Salir" 3>&1 1>&2 2>&3
    )
}

user_mgt_menu() {
    usermenu_option=$(
        whiptail --title "Gestión de usuarios" --nocancel --menu "Seleccione una opción" 0 0 5 \
        "A" "Añadir un nuevo usuario." \
        "B" "Modificar datos de un usuario." \
        "C" "Eliminar un usuario del sistema." \
        "D" "Ver información de los usuarios conectados." \
        "X" "Volver" 3>&1 1>&2 2>&3
    )
}

group_mgt_menu() {
    groupmenu_option=$(
        whiptail --title "Gestión de grupos" --nocancel --menu "Seleccione una opción" 0 0 7 \
        "A" "Añadir un nuevo grupo." \
        "B" "Modificar datos de un grupo." \
        "C" "Eliminar un grupo del sistema." \
        "D" "Ver usuarios de un grupo concreto." \
        "E" "Meter usuario en un grupo." \
        "F" "Sacar usuario de un grupo." \
        "X" "Volver" 3>&1 1>&2 2>&3
    )
}

process_mgt_menu() {
    processmenu_option=$(
        whiptail --title "Información de procesos" --nocancel --menu "Seleccione una opción" 0 0 4 \
        "A" "Ver procesos activos del sistema." \
        "B" "Buscar texto en la lista de procesos." \
        "C" "Ver los 10 procesos que más consumen en este momento." \
        "X" "Volver" 3>&1 1>&2 2>&3
    )
}

system_info_menu() {
    systeminfo_option=$(
        whiptail --title "Información del sistema" --nocancel --menu "Seleccione una opción" 0 0 5 \
        "A" "Información del sistema." \
        "B" "Memoria en uso y memoria disponible." \
        "C" "Tiempo que lleva el equipo en marcha." \
        "D" "Capacidad disponible de discos duros / particiones." \
        "X" "Volver" 3>&1 1>&2 2>&3
    )
}

color_change_menu() {
    colormenuoption=$(
        whiptail --title "Cambiar combinación de colores" --nocancel --menu "Elige un tema" 0 0 4 \
        "A" "Oscuro" \
        "B" "Claro" \
        "C" "Claro/Cyan" \
        "X" "Salir" 3>&1 1>&2 2>&3
    )
}

user_info_menu() {
    user_info_option=$(
        whiptail --title "Modificar información del usuario" --nocancel --menu "Elige el dato que deseas modificar" 0 0 6 \
        "A" "Nombre completo" \
        "B" "Departamento" \
        "C" "Telf. Empresa" \
        "D" "Telf. Personal" \
        "E" "Otros datos" \
        "X" "Salir" 3>&1 1>&2 2>&3
    )
}

password_ask() {
    password=$(whiptail --title "Password" --passwordbox "Introduce contraseña" 8 39 3>&1 1>&2 2>&3)
    passwordcheck=$(whiptail --title "Password" --passwordbox "Introduce confirmación de contraseña" 8 39 3>&1 1>&2 2>&3)
}

#==========================================================================================

# Inicio del script
clear

if [ $UID != 0 ]; then
    whiptail --title "Error" --msgbox "Este script se debe lanzar como Administrador (sudo).\nSe cerrará el programa tras este aviso." 0 0
    exit
else
    whiptail --title "Bienvenido" --msgbox "Permiso de Administrador reconocido.\nPuede continuar." 0 0
fi

while :; do
    mainmenu
    case $mainmenu_option in
    A)
        while :; do
            user_mgt_menu #Gestión de usuarios. Ver funciones al principio del script.
            case $usermenu_option in
            A)
                nombre_add=$(whiptail --title "Introduce el nombre" --inputbox "Introduce el nombre de usuario" 0 0 3>&1 1>&2 2>&3)
                if [[ -z "$nombre_add" ]]; then
                    #Si el campo está en blanco, sale un aviso y vuelve al menú anterior.
                    #Este proceso se repite a lo largo de todo el script en diferentes puntos.
                    whiptail --title "Error" --msgbox "No has introducido un nombre de usuario." 0 0
                    break
                fi
                password_ask
                if [[ -z "$password" ]]; then
                    whiptail --title "Error" --msgbox "No has introducido una contraseña." 0 0
                    break
                fi
                until [[ $password == $passwordcheck ]]; do #Comprueba que el usuario ha puesto correctamente la contraseña. Ver funciones.
                    whiptail --title "Error" --msgbox "Las contraseñas no coinciden. Vuelve a intentarlo." 0 0
                    password_ask
                done
                #En caso de querer meter al usuario en un grupo, se le pregunta:
                whiptail --title "Añadir a grupo" --yesno "¿Deseas añadir al usuario a un grupo específico?" --yes-button "Si" 0 0
                if [[ $? -eq 0 ]]; then
                    group_add=$(whiptail --title "Nombre del grupo" --inputbox "Introduce el nombre del grupo de usuarios." 0 0 3>&1 1>&2 2>&3)
                    group_check=$(getent group $group_add)
                    if [[ -z "$group_add" ]]; then
                        whiptail --title "Error" --msgbox "No has introducido el nombre del grupo."
                        break
                    elif [[ -z "$group_check" ]]; then
                        whiptail --title "Error" --msgbox "Ese grupo de usuarios no existe en el sistema.\n Cancelando la creación de usuario..." 0 0
                        break
                    fi
                    useradd -m -p $(echo $password | openssl passwd -1 -stdin) $nombre_add -G $group_add
                    #La contraseña se encripta automáticamente en el sistema. Si no se pasa por openssl primero, la variable $password se guarda encriptada en lugar de ser
                    #la password del usuario, por lo que no se podría utilizar. Habría que hacer un "$passwd usuario" y resetearla.
                    whiptail --title "Mensaje" --msgbox "Usuario $nombre_add registrado correctamente y añadido al grupo $group_add." 0 0
                elif [[ $? -eq 1 ]]; then
                    useradd -m -p $(echo $password | openssl passwd -1 -stdin) $nombre_add
                    whiptail --title "Mensaje" --msgbox "Usuario $nombre_add registrado correctamente." 0 0
                fi
                ;;

            B)
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
                A)
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
                B)
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
                C)
                    #Cambiar telf. empresa
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

                D) #Cambiar telf. personal
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

                E) #Añadir otros datos
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
            C)
                #Pedir nombre del usuario
                nombre_del=$(whiptail --title "Ejemplo" --inputbox "Introduce el nombre de usuario a eliminar" 8 50 nombreusuario 3>&1 1>&2 2>&3)
                if [[ -z "$nombre_del" ]]; then #Si no has metido un nombre, te saca al menú anterior.
                    whiptail --title "Error" --msgbox "No has introducido un nombre de usuario." 0 0
                    break
                fi
                #Comprueba que existe ese usuario y que no es del sistema (ver en /etc/passwd que es superior a 100X)
                safety_check=$(getent passwd $nombre_del | cut -d: -f3)
                if [[ $safety_check -gt 999 && $safety_check -lt 65534 ]]; then
                    userdel -r $nombre_del
                    whiptail --title "Correcto" --msgbox "Usuario $nombre_del eliminado correctamente." 0 0
                else
                    whiptail --title "Error" --msgbox "Error: ese usuario no existe o no se puede eliminar." 0 0
                fi
                ;;
            D)
                #Información del usuario. Comprueba primero que tiene instalado el paquete finger.
                which finger >/dev/null
                if [[ $? -eq 0 ]]; then
                    whiptail --textbox /dev/stdin 12 0 <<<"$(finger -lp)"
                else
                    whiptail --title "Paquete necesario" --msgbox "Se requiere la instalación del paquete 'finger' para el funcionamiento correcto de esta opción.\n\
Puedes instalarlo con el comando '$ sudo apt install finger' o el equivalente de tu distribución de Linux." 0 0
                fi
                ;;
            X)
                break
                ;;
            esac
        done
        ;;
    B)
        #Menú de creación de grupos
        while :; do
            group_mgt_menu
            case $groupmenu_option in
            A)
                group_add=$(whiptail --title "Crear grupo" --inputbox "Introduce el nombre de grupo" 0 0 3>&1 1>&2 2>&3)
                if [[ -z "$group_add" ]]; then
                    whiptail --title "Error" --msgbox "No has introducido un nombre para el grupo.\nVolviendo al menú anterior..." 0 0
                    break
                fi
                groupadd "$group_add"
                whiptail --title "Grupo de usuarios creado" --msgbox "Se ha generado el grupo de usuarios $group_add." 0 0
                ;;
            B)
                #Modificar nombre de grupo
                group_oldname=$(whiptail --title "Modificar grupo" --inputbox "Introduce el nombre de grupo que quieres modificar:" 0 0 3>&1 1>&2 2>&3)
                if [[ -z "$group_oldname" ]]; then
                    whiptail --title "Error" --msgbox "No has introducido un nombre para el grupo.\nVolviendo al menú anterior..." 0 0
                    break
                fi
                #Antes de modificar el grupo, comprueba que existe y no es del sistema.
                group_oldname_safetycheck=$(getent group $group_oldname | cut -d: -f3)
                if [[ $group_oldname_safetycheck -lt 999 || $group_oldname_safetycheck -gt 65534 || -z "$group_oldname_safetycheck" ]]; then
                    whiptail --title "Error" --msgbox "Ese grupo de usuarios no existe o no se puede modificar.\nVolviendo al menú anterior..." 0 0
                    break
                fi
                group_newname=$(whiptail --title "Nuevo nombre de grupo" --inputbox "Introduce el nuevo nombre del grupo:" 0 0 3>&1 1>&2 2>&3)
                groupmod -n $group_newname $group_oldname
                if [[ $? -eq 0 ]]; then
                    whiptail --title "Grupo de usuarios renombrado" --msgbox "Se ha renombrado el grupo de usuarios $group_oldname a $group_newname." 0 0
                else
                    whiptail --title "Error" --msgbox "Se ha producido un error." 0 0
                    break
                fi
                ;;
            C)
                #Eliminar grupo
                group_del=$(whiptail --title "Eliminar grupo" --inputbox "Introduce el nombre de grupo que quieres eliminar" 0 0 3>&1 1>&2 2>&3)
                if [[ -z "$group_del" ]]; then
                    whiptail --title "Error" --msgbox "No has introducido un nombre de grupo.\nVolviendo al menú anterior..." 0 0
                    break
                fi
                #Antes de modificar el grupo, comprueba que existe y no es del sistema.
                group_del_safetycheck=$(getent group $group_del | cut -d: -f3)
                if [[ $group_del_safetycheck -lt 999 || $group_del_safetycheck -gt 65534 || -z "$group_del_safetycheck" ]]; then
                    whiptail --title "Error" --msgbox "Ese grupo de usuarios no existe o no se puede eliminar.\nVolviendo al menú anterior..." 0 0
                    break
                fi
                groupdel $group_del
                if [[ $? -eq 0 ]]; then
                    whiptail --title "Grupo de usuarios eliminado" --msgbox "Se ha eliminado el grupo de usuarios $group_del." 0 0
                else
                    whiptail --title "Error" --msgbox "Se ha producido un error." 0 0
                    break
                fi
                ;;
            D)
                #Información de grupo
                group_info=$(whiptail --title "Información de grupo" --inputbox "Introduce el nombre del grupo que quieres consultar:" 0 0 3>&1 1>&2 2>&3)
                if [[ -z "$group_info" ]]; then
                    whiptail --title "Error" --msgbox "No has introducido nada. Volviendo al menú anterior..." 0 0
                    break
                elif [[ -z "$(getent group $group_info)" ]]; then
                    whiptail --title "Error" --msgbox "Ese grupo no existe. Volviendo al menú anterior..." 0 0
                    break
                fi
                whiptail --textbox /dev/stdin 20 0 <<<"El grupo $group_info contiene los siguientes usuarios:\n\n$(getent group $group_info)"
                ;;
            E)
                #Unir usuario a grupo
                user_join=$(whiptail --title "Añadir usuario a grupo" --inputbox "Introduce el nombre del usuario a añadir:" 0 0 3>&1 1>&2 2>&3)
                if [[ -z "$user_join" ]]; then
                    whiptail --title "Error" --msgbox "No has introducido nada. Volviendo al menú anterior..." 0 0
                    break
                elif [[ -z "$(getent passwd $user_join)" ]]; then
                    whiptail --title "Error" --msgbox "Ese usuario no existe. Volviendo al menú anterior..." 0 0
                    break
                fi
                group_join=$(whiptail --title "Añadir usuario a grupo" --inputbox "Introduce el nombre del grupo donde añadir al usuario:" 0 0 3>&1 1>&2 2>&3)
                if [[ -z "$group_join" ]]; then
                    whiptail --title "Error" --msgbox "No has introducido nada. Volviendo al menú anterior..." 0 0
                    break
                elif [[ -z "$(getent group $group_join)" ]]; then
                    whiptail --title "Error" --msgbox "Ese grupo no existe. Volviendo al menú anterior..." 0 0
                    break
                fi
                usermod -a -G $group_join $user_join
                if [[ $? -eq 0 ]]; then
                    whiptail --title "Usuario añadido a grupo" --msgbox "Usuario $user_join añadido al grupo $group_join correctamente." 0 0
                else
                    whiptail --title "Error" --msgbox "Se ha producido un error." 0 0
                    break
                fi
                ;;
            F)
                #Retirar usuario de grupo
                user_remove=$(whiptail --title "Retirar usuario de grupo" --inputbox "Introduce el nombre del usuario a retirar:" 0 0 3>&1 1>&2 2>&3)
                if [[ -z "$user_remove" ]]; then
                    whiptail --title "Error" --msgbox "No has introducido nada. Volviendo al menú anterior..." 0 0
                    break
                elif [[ -z "$(getent passwd $user_remove)" ]]; then
                    whiptail --title "Error" --msgbox "Ese usuario no existe. Volviendo al menú anterior..." 0 0
                    break
                fi
                group_remove=$(whiptail --title "Retirar usuario de grupo" --inputbox "Introduce el nombre del grupo de donde retirar al usuario:" 0 0 3>&1 1>&2 2>&3)
                if [[ -z "$group_remove" ]]; then
                    whiptail --title "Error" --msgbox "No has introducido nada. Volviendo al menú anterior..." 0 0
                    break
                elif [[ -z "$(getent group $group_remove)" ]]; then
                    whiptail --title "Error" --msgbox "Ese grupo no existe. Volviendo al menú anterior..." 0 0
                    break
                fi
                gpasswd -d $user_remove $group_remove
                if [[ $? -eq 0 ]]; then
                    whiptail --title "Usuario añadido a grupo" --msgbox "Usuario $user_remove retirado del grupo $group_remove correctamente." 0 0
                else
                    whiptail --title "Error" --msgbox "Se ha producido un error." 0 0
                    break
                fi
                ;;
            X)
                #Salir
                break
                ;;
            *)
                whiptail --title "Error" --msgbox "Opción inválida. Elige otra opción."
                ;;
            esac

        done
        ;;
    C)
        while :; do
            process_mgt_menu #Gestión de procesos. Ver funciones.
            case $processmenu_option in
            A)
                #whiptail --title "Mensaje" --msgbox "Procesos activos" 0 0
                whiptail --textbox /dev/stdin 20 0 <<<"$(ps aux)"
                ;;
            B)
                #Buscar cadena de texto en lista de procesos
                process_search=$(whiptail --title "Introduce texto" --inputbox "Introduce el texto a buscar en la lista de procesos:" 0 0 3>&1 1>&2 2>&3)
                whiptail --textbox /dev/stdin 20 0 <<<"Procesos encontrados:\n\n$(ps aux | grep $process_search)"
                ;;
            C)
                #Procesos que más consumen en este momento (max. 10)
                whiptail --textbox /dev/stdin 20 0 <<<"10 procesos de mayor consumo:\n$(ps -eo %mem,%cpu,comm --sort=-%mem | head -n 11 | column -t)"
                ;;
            X)
                break
                ;;
            esac
        done
        ;;
    D)
        while :; do
            system_info_menu #Gestión de servicios y sistema
            case $systeminfo_option in
            A)
                #Información del sistema.
                whiptail --textbox /dev/stdin 0 0 <<<"$(hostnamectl)"
                ;;
            B)
                #Memoria en uso y memoria disponible
                whiptail --textbox /dev/stdin 15 0 <<<"$(free --si -hw)"
                ;;
            C)
                #Tiempo que lleva el servidor en marcha.
                hora=$(uptime | cut -d"," -f1 | cut -d" " -f2)
                tiempo=$(uptime -p | cut -c4-100) #En minutos
                whiptail --title "Tiempo activo" --msgbox "Son las $hora.\nEl equipo lleva encendido $tiempo." 0 0
                ;;
            D)
                #Distribución de discos duros / particiones y su ocupación. Requiere permiso sudo.
                whiptail --textbox /dev/stdin 30 0 <<<"$(parted -l)"
                ;;
            X)
                break
                ;;
            esac
        done
        ;;
    E) #Cambio de colores del menú
        while :; do
            color_change_menu
            case $colormenuoption in
            A)
                #Oscuro
                export NEWT_COLORS='
                root=,gray
                window=white,black
                title=magenta,black
                border=white,black
                textbox=white,black
                button=magenta,black
                actbutton=black,magenta
                listbox=white,black
                '
                whiptail --msgbox "Muestra de colores" 0 0
                ;;
            B)
                #Claro
                export NEWT_COLORS='
                root=,lightgray
                window=black,white
                title=black,blue
                border=black,white
                textbox=black,white
                button=black,blue
                actbutton=blue,black
                listbox=black,white
                '
                whiptail --msgbox "Muestra de colores" 0 0
                ;;
            C)
                #Cyan
                export NEWT_COLORS='
                root=,lightgray
                window=black,cyan
                title=black,blue
                border=black,cyan
                textbox=black,cyan
                button=black,blue
                actbutton=cyan,black
                listbox=black,cyan
                '
                whiptail --msgbox "Muestra de colores" 0 0
                ;;
            X)
                break
                ;;
            esac
        done
        ;;
    X)
        whiptail --title "Mensaje" --msgbox "Gracias por utilizar este servicio." 10 70
        exit
        ;;
    *)
        whiptail --title "Mensaje" --msgbox "Opción no válida. Elige otra opción." 40 80
        ;;
    esac
done
