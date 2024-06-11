# wg-oc
Connect to openconnect through wireguard to regulate what traffic goes through

## wireguard conf
you will need to update the wireguard PostUp and PostDown to support specific access to the openconnect resources (ie 192.168.10.0/24)
```
PostUp = iptables -A FORWARD -i %i -j ACCEPT; iptables -A FORWARD -o %i -j ACCEPT; iptables -t nat -A POSTROUTING -o eth+ -j MASQUERADE; iptables -t nat -A POSTROUTING -d 192.168.10.0/24 -o tun0 -j MASQUERADE
PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -D FORWARD -o %i -j ACCEPT; iptables -t nat -D POSTROUTING -o eth+ -j MASQUERADE; iptables -t nat -D POSTROUTING -d 192.168.10.0/24 -o tun0 -j MASQUERADE
```
