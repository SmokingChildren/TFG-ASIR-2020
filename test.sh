OLDIFS=$IFS
IFS=$'\n'  
usuarios=$(cat /etc/passwd | cut -d: -f3)
for i in $usuarios; do
    usuario=$i
    echo $i
    username=$(head $usuario /etc/passwd | cut -d: -f1)
    echo $username
done