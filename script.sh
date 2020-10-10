#!/bin/bash
#==========================================================================================
#Autor: Juan Carlos Collado Custodio
#Módulo: Proyecto de Fin de Grado
#Curso: ASIR 2019-2020
#Título: Shell script con interfaz gráfica para gestión de usuarios, procesos y servicios
#==========================================================================================

#1) Gestión de usuarios y grupos
    #a) Crear usuario
    #b) Buscar usuario
        #b.1) Modificar datos del usuario
        #b.2) Borrar usuario
    #c) Consultar último usuario creado
    #d) Crear grupo
    #e) Buscar grupo
        #e.1) Modificar datos del grupo
        #e.2) Añadir o quitar miembros
        #e.3) Borrar grupo

#2) Gestión de procesos
    #a) Consultar procesos activos en este momento
    #b) Consultar cantidad de memoria libre
    #c) Consultar cuánto tiempo lleva el servidor encendido
    #d) Consultar quién está logeado en el sistema
    #e) Consultar los 10 procesos que más memoria están consumiendo

#3) Gestión de servicios
    #a) Mostrar servicios activos en este momento
    #b) Mostrar tiempo que ha tardado el equipo en arrancar
    #c) Mostrar cuánto han tardado los procesos en arrancar
    #d) Mostrar servicios disponibles y seleccionar
        #d.1) Arrancar o detener servicio seleccionado (solo 1, opción tipo radio)

#4) Información del sistema
    #a) 

#q) Salir del menú

#==========================================================================================

# VARIABLES

#==========================================================================================

# FUNCIONES

function menu() {
    clear
    echo
    echo -e "\t\t\tAdmin Menu\n"
    echo -e "\t1. Display Total Disk Space"
    echo -e "\t2. Display All Logged in Users"
    echo -e "\t3. Display Memory Usage"
    echo -e "\t0. Exit Menu\n\n"
    echo -en "\t\tEnter an Option: "
    read -n 1 selection
}

#==========================================================================================

# Inicio del script

clear

while [[ true ]]; do
    menu
    case $selection in
    a)
        echo "TO DO"
        ;;
    b)
        echo "TO DO"
        ;;
    c)
        echo "TO DO"
        ;;
    q)
        echo "Saliendo"
        break
        ;;
    *)
        echo "Opción inválida."
        ;;
    esac
done
