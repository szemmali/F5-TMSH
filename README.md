# F5-TMSH
## Configure and Manage BIG-IP F5 System 13.x with tmsh

:shipit: [Modify Hostname](#) 
```
tmsh modify sys global-settings hostname szemmali.intra.local
```

:shipit: [Create VLAN](#) 
```
tmsh create net vlan external interfaces add {1.2}
tmsh create net vlan internal interfaces add {1.1}
```

:shipit: [Create Self IPS](#) 
```
tmsh create net self 10.20.30.40/24 vlan external
tmsh create net self 20.30.40.50/24 vlan internal
```

:shipit: [Create HTTP_POOL Pool](#) 
```
tmsh create ltm pool HTTP_POOL load-balancing-mode round-robin members add {172.16.23:80 172.16.24:80 172.16.25:80}
```
:shipit: [Create HTTP_POOL Pool](#)
```
tmsh create ltm pool HTTP_POOL load-balancing-mode round-robin members add {192.168.1.41:80 192.168.1.42:80 192.168.1.43:80}
```

:shipit: [Create HTTP_TEST Virtual Server](#)
```
tmsh create ltm virtual HTTP_TEST destination 10.20.20.40:80 profiles add {tcp http} pool HTTP_POOL snat automap
```

:shipit: [Save the config](#)
```
tmsh save sys config
```
