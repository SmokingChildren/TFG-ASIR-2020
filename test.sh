#!/bin/bash
read -p "Dime el nombre de un paquete para ver si está instalado: " paquete
which $paquete >/dev/null
if [[ $? -eq 0 ]]; then
    echo "$paquete está instalado."
else
    echo "$paquete no está instalado."
fi
