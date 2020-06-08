# vpn.ks
#
# Tierra VPN

%packages

NetworkManager-openvpn

%end

%post

echo ""
echo "POST vpn ************************************"
echo ""

mkdir /etc/openvpn/TierraFerrucci

cat > /etc/openvpn/TierraFerrucci/tierrahqvpn.tlsauth << EOF
-----BEGIN OpenVPN Static key V1-----
763d898b2dc2d61532aaf8fbfd9ed27a
88b758bbc9e6c2c69640fef91f87a9ce
7b2938ce4e06a7bfabdcfa75fb73a939
6b198a0baf0cde7fad5f3b3363ab8e50
70ed2ebb36d9c41524d1ea1a6a300d98
d06072398dc258a7c53f7d69d63649e9
d3afc133f7c7186ddc3b24127ee882b9
0d4892f84a7889b8be60df0c6def9a9d
604fc86372266973ceddb338705da217
af42e4a9bb5c9ac5e0f7059964c1d2b0
6e3271ee5f8888e5e059bfd296151a77
68df119fc8151127b4487d62dc9b9953
492c6dd8567f2e1f756204ad74cc5e0f
363f506d682e43dc0f8c8a881dad2ab1
d03fcf65fdc216f5cfa12b52e402e64d
bdee93243b308fb25f025fa0eb66f3f9
-----END OpenVPN Static key V1-----
EOF

cat > /etc/openvpn/TierraFerrucci/ca.crt << EOF
-----BEGIN CERTIFICATE-----
MIIHADCCBOigAwIBAgIJAJtTZVTZVOR6MA0GCSqGSIb3DQEBCwUAMIGwMQswCQYD
VQQGEwJJVDELMAkGA1UECBMCVE8xDjAMBgNVBAcTBVR1cmluMQ8wDQYDVQQKEwZU
aWVycmExEjAQBgNVBAsTCUNvbW11bml0eTEiMCAGA1UEAxMZb3BlbnZwbi50aWVy
cmFzZXJ2aWNlLmNvbTEQMA4GA1UEKRMHT3BlblZQTjEpMCcGCSqGSIb3DQEJARYa
c3lzYWRtaW5AdGllcnJhc2VydmljZS5jb20wHhcNMjAwNDE2MTM1NTMzWhcNMzAw
NDE0MTM1NTMzWjCBsDELMAkGA1UEBhMCSVQxCzAJBgNVBAgTAlRPMQ4wDAYDVQQH
EwVUdXJpbjEPMA0GA1UEChMGVGllcnJhMRIwEAYDVQQLEwlDb21tdW5pdHkxIjAg
BgNVBAMTGW9wZW52cG4udGllcnJhc2VydmljZS5jb20xEDAOBgNVBCkTB09wZW5W
UE4xKTAnBgkqhkiG9w0BCQEWGnN5c2FkbWluQHRpZXJyYXNlcnZpY2UuY29tMIIC
IjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEA5af85Y7cAeiiBT760546OMgB
7jXSxL6J5xPKG3JJI77jbIo5ZLjbVr4ayVAetVq2RdyThhM7ctrJKN/xRKLj0CyU
FDgy5v8mUr5L77Y+yN0jLCCX5g+T2EaxmBgOucTdaaV4RXkL3o99+tpSOr+bH5B0
l9RuMk/Qn28pJ8a9sidP/XLX0+uECT31/Y6U2V0fKkMzGq2xOerbmrzuenx6jYLO
VAGwGiOG3keU6ZTztZz2WOgOE9+cvQ5QcKQqN4xHYEgNGuqNj+cSx4AwmcfedNN5
/WoFuH21SuBVpTrkfwsThE6r5Q/DlunOBy5r9Y2rZG1b+tqBLVdqswowx1KeP8PC
D3fO9uoK9QNwRAyXKN8x4dVS+x/LsiptRQYQHtFCUvUwKHw1sZwlXT171VjmoQYo
C2Rh7tNifWmP28ehraO0UWB6YiKDiyPvzRDMSU1/3FZ0j2eksQr9EhEdCAmC9Qnt
2pwZ3cBcqPS1SOw4KPE4+iBRgWpBTjb6rVmmA0iFXtlviIu864L8h2UG7ao2m0yu
bCtKg02xZZvvwDZ35ibGOZMwDFRcBi/zdWCoBJhs9RAro4z0YgypH7Lc2/0n7JDg
ASkeLwaREWgiPWp+ResuoK+E3/Xl2BqxlDm1LaAvh7A/fvtj+/1AQVdtpcoMam5j
16unLTgrKg//p/zi1EUCAwEAAaOCARkwggEVMB0GA1UdDgQWBBQblA7O3RAiPXo0
W5CAnhfWs9ea2jCB5QYDVR0jBIHdMIHagBQblA7O3RAiPXo0W5CAnhfWs9ea2qGB
tqSBszCBsDELMAkGA1UEBhMCSVQxCzAJBgNVBAgTAlRPMQ4wDAYDVQQHEwVUdXJp
bjEPMA0GA1UEChMGVGllcnJhMRIwEAYDVQQLEwlDb21tdW5pdHkxIjAgBgNVBAMT
GW9wZW52cG4udGllcnJhc2VydmljZS5jb20xEDAOBgNVBCkTB09wZW5WUE4xKTAn
BgkqhkiG9w0BCQEWGnN5c2FkbWluQHRpZXJyYXNlcnZpY2UuY29tggkAm1NlVNlU
5HowDAYDVR0TBAUwAwEB/zANBgkqhkiG9w0BAQsFAAOCAgEACL22MDyP8hValHYa
EvYAdjZVbkvMKtqsKoIGCJxIhbuEYTOGonaiv74Jb1PECxxxYcJzsR8LunC56OQ+
Dz6QiW5LEkKojxBmsCTHELqWSKarK7qklp8Vin6zlz13eqIFq4zfSoLYDC55DKcK
Ux0tA6XvTopP5B9BKHm5WpD4uoOw8kOy7hph2U1ANzcWwEER56GVUA0j8Y+fkCGW
bTK4ykfv9HWX7oC5kLM90imFnumXwSc6KNtjsHJWKXey2nTgghFKsEZ9FnzfRvAy
h0rOcfRHJoY3j7haqleVCTjDI9OraEgKeG7Hysq9xUU2Uddnmfzp4OF7syGKhGpF
6iRyq4t21U68UW0vKuRGCVpzV/ApvC5U5LfuMmmrfEe+DdaXV7+zRAhiAAcQ9zGr
qcs2MvUdDYODEBzV0zpu6vhZ4uilTMdFj8sV+WmL0tYd9yntCVwNn9PY8vTKoIDj
/zJe/mZJjzPuk9UwDG9vhMpeNCVtPKJv5wRuZ7Qwau6pa6BVKWVRY6BZlMWe+4Wp
Y0GtK3oPNJxHobV3j8qEDG46SXwB4vXNWVL9Ix3nf/L0lS+A0jPtHIXLTG2fNyJW
5Gva85LmPtxogcqMnkt3/gJtW6g1MOaUr2rpP6Tvy38IclXzeMeCk8irL6/3mTC1
Ud4qeZ36Bo3Asbd5wDd7JDVLQ8o=
-----END CERTIFICATE-----
EOF

cat > /etc/openvpn/TierraFerrucci/TierraFerrucci.ovpn << EOF
##############################################
###
### Configuration file created by Securepoint SSL VPN Thu Nov 28 2019 - 11:23:52
### Project website: http://sourceforge.net/projects/securepoint/
### Securepoint GmbH, Bleckeder Landstrasse 28, 21337 Lueneburg, Germany; www.securepoint.de
###
### For further information about the configuration file,
### please visit: http://www.openvpn.net/index.php/open-source/documentation
###
##############################################

client
float
nobind
persist-key
persist-tun
auth-user-pass
cipher AES-256-CBC
auth SHA1
dev tun
remote openvpn.tierraservice.com 1194
proto udp
ca "ca.crt"
remote-cert-tls server
mssfix
route-method exe
verb 3
route-delay 2
mute 20
tls-crypt tierrahqvpn.tlsauth
EOF

cat > /etc/NetworkManager/system-connections/TierraFerrucci.nmconnection << EOF
[connection]
id=TierraFerrucci
uuid=9b02e9b2-7ada-4b4a-9563-37bdf5dd81d0
type=vpn
permissions=

[vpn]
auth=SHA1
ca=/etc/openvpn/TierraFerrucci/ca.crt
cipher=AES-256-CBC
connection-type=password
dev=tun
float=yes
mssfix=yes
password-flags=1
remote=openvpn.tierraservice.com:1194
remote-cert-tls=server
tls-crypt=/etc/openvpn/TierraFerrucci/tierrahqvpn.tlsauth
service-type=org.freedesktop.NetworkManager.openvpn

[ipv4]
dns-search=
method=auto
never-default=true

[ipv6]
addr-gen-mode=stable-privacy
dns-search=
method=auto

[proxy]
EOF

chmod 600 /etc/NetworkManager/system-connections/TierraFerrucci.nmconnection

%end
