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

nombre=$(whiptail --inputbox "Introduce texto" 8 39 Nombre --title "Ejemplo" 3>&1 1>&2 2>&3)
password=$(whiptail --passwordbox "Introduce password" 8 39 --title "Password" 3>&1 1>&2 2>&3)
echo "El nombre es " $nombre
echo "La contraseña es " $password