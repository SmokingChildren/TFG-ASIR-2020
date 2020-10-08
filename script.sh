#!/bin/bash
#Autor: Juan Carlos Collado Custodio
#Módulo: Proyecto de Fin de Grado
#Curso: ASIR 2019-2020
#Título: Shell script con interfaz gráfica para gestión de usuarios, procesos y servicios

clear

while [[ true ]]; do
echo "menu"
case "$selection" in
1) #Gestión de usuarios
2) #Gestión de procesos
3) #Gestión de servicios
4) #Actualización del sistema