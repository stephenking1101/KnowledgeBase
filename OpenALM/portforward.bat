netsh interface portproxy add v4tov4 listenaddress=127.0.0.1 listenport=80 connectaddress=52.82.80.146 connectport=8081
netsh interface portproxy add v4tov4 listenaddress=127.0.0.1 listenport=443 connectaddress=52.82.80.146 connectport=8443
netsh interface portproxy add v4tov4 listenaddress=127.0.0.1 listenport=22 connectaddress=52.82.80.146 connectport=2222

netsh interface portproxy show all
pause