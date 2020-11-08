#!/bin/bash
which finger >/dev/null
if [[ $? -eq 0 ]]; then
    whiptail --textbox /dev/stdin 12 0 <<<"$(finger -lp)"
    #echo "El paquete 'finger' está instalado."
else
    whiptail --title "Paquete necesario" --msgbox "Se requiere la instalación del paquete 'finger' para el funcionamiento correcto de esta opción. \n \
    Puedes instalarlo con el comando '$ sudo apt install finger' o el equivalente de tu distribución de Linux." 0 0
    #echo "El paquete 'finger' no está instalado."
fi
