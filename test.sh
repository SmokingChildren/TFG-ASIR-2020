#!/bin/bash

#Menú con las opciones a cambiar
user_info_menu() {
    user_info_option=$(
        whiptail --title "Modificar información del usuario" --nocancel --menu "Elige el dato que deseas modificar" 15 65 5 \
        "1" "Nombre completo" \
        "2" "Departamento" \
        "3" "Telf. Empresa" \
        "4" "Telf. Personal" \
        "5" "Otros datos" \
        "0" "Salir" 3>&1 1>&2 2>&3
    )
}

user_info=$(whiptail --title "Ejemplo" --inputbox "Introduce el nombre de usuario" 8 39 nombreusuario 3>&1 1>&2 2>&3) #Pedir nombre de usuario
if [[ -z "$user_info" ]]; then
    whiptail --title "Error" --msgbox "No has introducido un nombre de usuario." 0 0
    break
else
    user_info_menu
fi
#Comprobar que el usuario existe. Si no, salir al menú anterior.
getent passwd $user_info
if [[ $? -eq 2 ]]; then
    whiptail --title "Error" --msgbox "No se ha encontrado ese usuario." 0 0
    break
else
    user_info_menu
fi


case "$user_info_option" in
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
    user_other=$(whiptail --title "Introduce el nombre completo" --inputbox "Introduce el nombre completo del usuario" 0 0 3>&1 1>&2 2>&3)
    if [[ -z "$user_other" ]]; then
        whiptail --title "Error" --msgbox "No has introducido un nombre." 0 0
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
