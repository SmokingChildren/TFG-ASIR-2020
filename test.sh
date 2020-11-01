admincheck=$(
    whiptail --title "Se requiere permiso de Administrador" --yesno
    "Este script requiere permisos de administrador para funcionar correctamente. \n
    ¿Eres administrador del equipo? S/N \n
    (Utiliza TAB para cambiar de opción)" 10 10
)
if [[ admincheck = 0 ]]; then
    #Si el script no se ha lanzado como sudoer, lo hace ahora.
    [ $UID != 0 ] && exec sudo $0 "$@"
    whiptail --title "Aceptado" --msgbox "Permiso de administrador aceptado. Puede continuar." 5 10
else
    whiptail --title "Aceptado" --msgbox "Permiso de administrador aceptado. Puede continuar." 5 10
fi