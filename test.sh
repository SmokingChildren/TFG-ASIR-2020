admintest() {
    admincheck=$(
        whiptail --title "Se requiere permiso de Administrador" --yesno "Este script requiere permisos de administrador para funcionar correctamente. \n \
    ¿Eres administrador del equipo? S/N" 20 60 3>&1 1>&2 2>&3
    )
}
admintest
if [ $? = 0 ]; then
    #Si el script no se ha lanzado como sudoer, lo hace ahora.
    [ $UID != 0 ] && exec sudo $0 "$@"
    whiptail --title "Aceptado" --msgbox "Permiso de administrador aceptado. Puede continuar." 10 55
else
    whiptail --title "Aceptado" --msgbox "No tienes permisos de administrador. Se cerrará el programa tras este aviso." 10 55
    exit
fi
