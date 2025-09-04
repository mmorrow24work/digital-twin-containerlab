```
docker compose -f ./docker-compose_v3_alpine_mysql_snmptraps_latest.yaml up -d
```
```
docker compose -f ./docker-compose_v3_alpine_mysql_snmptraps_latest.yaml down
```
```bash
mickm@mickm-Latitude-7410:~/git/zabbix-docker$ docker compose -f ./docker-compose_v3_alpine_mysql_snmptraps_latest.yaml up -d
[+] Running 11/11
 ✔ Network zabbix-docker_backend                     Created                                                                                          0.1s
 ✔ Network zabbix-docker_default                     Created                                                                                          0.1s
 ✔ Network zabbix-docker_database                    Created                                                                                          0.1s
 ✔ Network zabbix-docker_tools_frontend              Created                                                                                          0.1s
 ✔ Network zabbix-docker_frontend                    Created                                                                                          0.1s
 ✔ Container zabbix-docker-db-data-mysql-1           Started                                                                                          0.3s
 ✔ Container zabbix-docker-zabbix-snmptraps-1        Started                                                                                          0.4s
 ✔ Container zabbix-docker-mysql-server-1            Started                                                                                          0.3s
 ✔ Container zabbix-docker-server-db-init-1          Exited                                                                                           5.9s
 ✔ Container zabbix-docker-zabbix-web-nginx-mysql-1  Started                                                                                          6.3s
 ✔ Container zabbix-docker-zabbix-server-1           Started                                                                                          6.3s
mickm@mickm-Latitude-7410:~/git/zabbix-docker$
```

```bash
mickm@mickm-Latitude-7410:~/git/zabbix-docker$ docker compose -f ./docker-compose_v3_alpine_mysql_snmptraps_latest.yaml down
[+] Running 11/11
 ✔ Container zabbix-docker-db-data-mysql-1           Removed                                                                       0.0s
 ✔ Container zabbix-docker-zabbix-web-nginx-mysql-1  Removed                                                                       1.0s
 ✔ Container zabbix-docker-zabbix-server-1           Removed                                                                       1.2s
 ✔ Container zabbix-docker-server-db-init-1          Removed                                                                       0.0s
 ✔ Container zabbix-docker-zabbix-snmptraps-1        Removed                                                                       0.2s
 ✔ Container zabbix-docker-mysql-server-1            Removed                                                                       1.1s
 ✔ Network zabbix-docker_backend                     Removed                                                                       0.4s
 ✔ Network zabbix-docker_database                    Removed                                                                       0.6s
 ✔ Network zabbix-docker_tools_frontend              Removed                                                                       0.3s
 ✔ Network zabbix-docker_default                     Removed                                                                       0.2s
 ✔ Network zabbix-docker_frontend                    Removed                                                                       0.6s
mickm@mickm-Latitude-7410:~/git/zabbix-docker$
```
## From host machine - test external port mapping

```bash
mickm@mickm-Latitude-7410:~/git/docker_custom_image_kathara_alpine_pc$ snmptrap -v2c -c public localhost:162 '' 1.3.6.1.4.1.12345.1 1.3.6.1.4.1.12345.1.1 s 'External host test'
```

```bash
mickm@mickm-Latitude-7410:~/git/docker_custom_image_kathara_alpine_pc$ snmptrap -v2c -c public localhost:162 '' 1.3.6.1.4.1.12345.1 1.3.6.1.4.1.12345.1.1 s 'External host test'

# Check if it was received
docker logs zabbix-docker-zabbix-server-1 2>&1 | grep -i trap | tail -3
    51:20250904:231913.706 unmatched trap received from "172.16.238.1\nUDP:":  [172.16.238.1]:41989->[172.16.238.2]:1162\nDISMAN-EVENT-MIB::sysUpTimeInstance = 5875076\nSNMPv2-MIB::snmpTrapOID.0 = SNMPv2-SMI::enterprises.12345.1\nSNMPv2-SMI::enterprises.12345.1.1 = "aa Test trap message"
    51:20250904:233002.832 unmatched trap received from "172.16.238.1\nUDP:":  [172.16.238.1]:36490->[172.16.238.2]:1162\nDISMAN-EVENT-MIB::sysUpTimeInstance = 5939978\nSNMPv2-MIB::snmpTrapOID.0 = SNMPv2-SMI::enterprises.12345.1\nSNMPv2-SMI::enterprises.12345.1.1 = "Production trap - 172.16.238.2:1162"
    51:20250904:233504.891 unmatched trap received from "172.16.238.1\nUDP:":  [172.16.238.1]:53689->[172.16.238.2]:1162\nDISMAN-EVENT-MIB::sysUpTimeInstance = 5970212\nSNMPv2-MIB::snmpTrapOID.0 = SNMPv2-SMI::enterprises.12345.1\nSNMPv2-SMI::enterprises.12345.1.1 = "External host test"
mickm@mickm-Latitude-7410:~/git/docker_custom_image_kathara_alpine_pc$
```
