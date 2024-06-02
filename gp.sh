#check that openconnect isn't already running
if pgrep -x "openconnect" > /dev/null
then
    echo "openconnect is already running"
    pkill openconnect
    echo "killed openconnect"
    exit 1
fi

OLD_DEFAULT_ROUTE=$(ip route list default | head -n 1)
echo "saving old default route: $OLD_DEFAULT_ROUTE"
echo "starting openconnect"
timeout 5h openconnect --protocol=gp --user=$GP_USER --passwd-on-stdin $GP_HOST < <(echo $GP_PASS) &
ip route del default
ip route add $OLD_DEFAULT_ROUTE
ip route add 192.168.10.0/24 dev tun0 scope link