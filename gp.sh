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

prev_output=$(ip route)

while true; do
    if ip link show tun0 > /dev/null 2>&1; then
        echo "tun0 is up"
        tun0_ip=$(ip addr show tun0 | grep 'inet\b' | awk '{print $2}' | cut -d/ -f1)

        if ! ip route | grep default | grep tun0 > /dev/null 2>&1; then
            echo "adding default route to tun0"
            sleep 3
            ip route del default
            ip route add $OLD_DEFAULT_ROUTE
            ip route add 192.168.10.0./24 dev tun0 scope link
            exit 0
        fi
        sleep 3
    fi
done
