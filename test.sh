read -p "Dime un nombre " nombre_del
safety_check=$(getent passwd $nombre_del | cut -d: -f3)
echo $safety_check
if [[ $safety_check -gt 999 && $safety_check -lt 65534 ]]; then
    echo "bien"
else
    echo "mal"
fi