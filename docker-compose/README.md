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

