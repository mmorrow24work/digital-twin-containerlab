# NOTES

## Zabbix
### SQL backup in Zabbix

```bash
mmorrow24work@containerlab-gce-1-0:~/containerlab/lab-examples/frr01$ docker exec -it clab-frr01-PC2 bash
root@PC2:/# mysqldump -u zabbix -p --single-transaction --quick --lock-tables=false zabbix | gzip > /home/zabbix_backup.sql.gz
root@PC2:/# ls -lh /home
total 28M
-rw-r--r-- 1 ubuntu 1001  24M Sep  3 20:27 2_zabbix_backup.sql
-rw-r--r-- 1 ubuntu 1001 4.2M Sep  3 20:24 zabbix_backup.sql.gz
root@PC2:/#
root@PC2:/# exit
exit
mmorrow24work@containerlab-gce-1-0:~/containerlab/lab-examples/frr01$
```

### SQL restore in Zabbix

```bash
mmorrow24work@containerlab-gce-1-0:~/containerlab/lab-examples/frr01$ docker exec -it clab-frr01-PC2 bash
root@PC2:/# service zabbix-server stop
 * Stopping Zabbix server zabbix_server                                                                              [ OK ]
root@PC2:/# gunzip < /home/zabbix_backup.sql.gz | mysql -u zabbix -p zabbix
root@PC2:/# service zabbix-server start
root@PC2:/#
root@PC2:/# exit
exit
mmorrow24work@containerlab-gce-1-0:~/containerlab/lab-examples/frr01$
```

### Containerlab - mounted folders

```yml

    PC2:
      kind: linux
      image: zabbix:1.0
      ports:
      - "8080:80"
      - "8443:443"
      - "10051:10051"
      - "10050:10050"
      dns:
        servers:
          - "1.1.1.1"
      binds:
        - PC2/home:/home
```

```bash
mmorrow24work@containerlab-gce-1-0:~/containerlab/lab-examples/frr01$ ls -l
total 44
-rwxr-xr-x  1 mmorrow24work mmorrow24work 1229 Sep  1 23:07 PC-interfaces.sh
drwxr-xr-x  3 mmorrow24work mmorrow24work 4096 Sep  3 19:18 PC2
-rwxr-xr-x  1 mmorrow24work mmorrow24work  516 Sep  1 17:16 README.md
drwxrwxr-x+ 3 root          mmorrow24work 4096 Sep  1 17:18 clab-frr01
-rwxr-xr-x  1 mmorrow24work mmorrow24work 1271 Sep  3 19:52 frr01.clab.yml
drwxr-xr-x  2 mmorrow24work mmorrow24work 4096 Sep  1 17:16 router1
drwxr-xr-x  2 mmorrow24work mmorrow24work 4096 Sep  1 17:16 router2
drwxr-xr-x  2 mmorrow24work mmorrow24work 4096 Sep  1 23:06 router3
-rwxr-xr-x  1 mmorrow24work mmorrow24work  229 Sep  1 23:39 routers-snmp.sh
-rwxr-xr-x  1 mmorrow24work mmorrow24work   64 Sep  1 23:55 run.sh
mmorrow24work@containerlab-gce-1-0:~/containerlab/lab-examples/frr01$ ls -l PC2/home/
total 28096
-rw-r--r-- 1 mmorrow24work mmorrow24work 24444013 Sep  3 20:27 2_zabbix_backup.sql
-rw-r--r-- 1 mmorrow24work mmorrow24work  4321895 Sep  3 20:24 zabbix_backup.sql.gz
mmorrow24work@containerlab-gce-1-0:~/containerlab/lab-examples/frr01$
```
### Zabbix - Install using docker compose
```
mickm@mickm-Latitude-7410:~/git$ git clone https://github.com/zabbix/zabbix-docker.git
Cloning into 'zabbix-docker'...
remote: Enumerating objects: 128163, done.
remote: Counting objects: 100% (6781/6781), done.
remote: Compressing objects: 100% (416/416), done.
remote: Total 128163 (delta 6673), reused 6365 (delta 6365), pack-reused 121382 (from 3)
Receiving objects: 100% (128163/128163), 38.56 MiB | 10.33 MiB/s, done.
Resolving deltas: 100% (100623/100623), done.
mickm@mickm-Latitude-7410:~/git$ 
mickm@mickm-Latitude-7410:~/git$ git checkout 7.4
fatal: not a git repository (or any of the parent directories): .git
mickm@mickm-Latitude-7410:~/git$ ls
digital_twin-using_kathara_PDF  zabbix-docker
mickm@mickm-Latitude-7410:~/git$ cd zabbix-docker/
mickm@mickm-Latitude-7410:~/git/zabbix-docker$ git checkout 7.4
Already on '7.4'
Your branch is up to date with 'origin/7.4'.
mickm@mickm-Latitude-7410:~/git/zabbix-docker$ 
mickm@mickm-Latitude-7410:~/git/zabbix-docker$ docker images
REPOSITORY                   TAG       IMAGE ID       CREATED         SIZE
zabbix7.4_frr                1.0       98a38a8e5c40   12 days ago     1.09GB
<none>                       <none>    75789162b0d1   12 days ago     1.06GB
kathara_zabbix7.4-ubuntu24   1.0       c0e192409cc4   13 days ago     803MB
alpine_pc                    1.0       558f54e8cfe4   13 days ago     24MB
ubuntu                       24.04     e0f16e6366fe   5 weeks ago     78.1MB
alpine                       latest    9234e8fb04c4   7 weeks ago     8.31MB
kathara/frr                  latest    0fbf3877a39c   6 months ago    1.06GB
kathara/base                 latest    54609bfdb680   7 months ago    1.02GB
kathara/quagga               latest    62dd101dfa28   23 months ago   1.09GB
mickm@mickm-Latitude-7410:~/git/zabbix-docker$ docker compose -f ./docker-compose_v3_alpine_mysql_latest.yaml up -d
[+] Running 28/28
 ✔ zabbix-web-nginx-mysql Pulled                                                                                                                                                                                                                   19.2s 
   ✔ 9824c27679d3 Already exists                                                                                                                                                                                                                    0.0s 
   ✔ af10a4fb4a70 Pull complete                                                                                                                                                                                                                     6.3s 
   ✔ 159bd14f71ed Pull complete                                                                                                                                                                                                                     6.3s 
   ✔ 438029867321 Pull complete                                                                                                                                                                                                                    17.2s 
   ✔ 4f4fb700ef54 Pull complete                                                                                                                                                                                                                    17.2s 
   ✔ 2650898c220c Pull complete                                                                                                                                                                                                                    17.3s 
 ✔ db-data-mysql Pulled                                                                                                                                                                                                                             6.0s 
   ✔ 80bfbb8a41a2 Pull complete                                                                                                                                                                                                                     4.0s 
 ✔ zabbix-server Pulled                                                                                                                                                                                                                            12.5s 
 ✔ server-db-init Pulled                                                                                                                                                                                                                           12.5s 
   ✔ ae90140530e4 Pull complete                                                                                                                                                                                                                     5.4s 
   ✔ 41fb8017524c Pull complete                                                                                                                                                                                                                     5.7s 
   ✔ a1147630f0b0 Pull complete                                                                                                                                                                                                                     6.1s 
   ✔ fb99ebe5f805 Pull complete                                                                                                                                                                                                                     6.8s 
   ✔ e57634f6dcad Pull complete                                                                                                                                                                                                                    10.5s 
   ✔ 92602a37251b Pull complete                                                                                                                                                                                                                    10.5s 
 ✔ mysql-server Pulled                                                                                                                                                                                                                             37.7s 
   ✔ 500d7b2546c4 Pull complete                                                                                                                                                                                                                    16.3s 
   ✔ bd66ec68b64f Pull complete                                                                                                                                                                                                                    16.3s 
   ✔ df938959d2c4 Pull complete                                                                                                                                                                                                                    16.3s 
   ✔ d9348ee598b8 Pull complete                                                                                                                                                                                                                    16.5s 
   ✔ bf5ff5eaaa3b Pull complete                                                                                                                                                                                                                    16.5s 
   ✔ d504a2807609 Pull complete                                                                                                                                                                                                                    16.5s 
   ✔ efbc662f1080 Pull complete                                                                                                                                                                                                                    23.4s 
   ✔ b0a933af8023 Pull complete                                                                                                                                                                                                                    23.4s 
   ✔ 14223e8296d1 Pull complete                                                                                                                                                                                                                    35.5s 
   ✔ 61f9674f6b0d Pull complete                                                                                                                                                                                                                    35.5s 
[+] Running 11/11
 ✔ Network zabbix-docker_default                     Created                                                                                                                                                                                        0.1s 
 ✔ Network zabbix-docker_tools_frontend              Created                                                                                                                                                                                        0.1s 
 ✔ Network zabbix-docker_database                    Created                                                                                                                                                                                        0.0s 
 ✔ Network zabbix-docker_backend                     Created                                                                                                                                                                                        0.1s 
 ✔ Network zabbix-docker_frontend                    Created                                                                                                                                                                                        0.1s 
 ✔ Volume "zabbix-docker_snmptraps"                  Created                                                                                                                                                                                        0.0s 
 ✔ Container zabbix-docker-db-data-mysql-1           Started                                                                                                                                                                                        1.1s 
 ✔ Container zabbix-docker-mysql-server-1            Started                                                                                                                                                                                        1.1s 
 ✔ Container zabbix-docker-server-db-init-1          Exited                                                                                                                                                                                        33.9s 
 ✔ Container zabbix-docker-zabbix-server-1           Started                                                                                                                                                                                       34.2s 
 ✔ Container zabbix-docker-zabbix-web-nginx-mysql-1  Started                                                                                                                                                                                       34.2s 
mickm@mickm-Latitude-7410:~/git/zabbix-docker$ docker ps
CONTAINER ID   IMAGE                                             COMMAND                  CREATED          STATUS                    PORTS                                                                                NAMES
9a9f618f8ef4   zabbix/zabbix-web-nginx-mysql:alpine-7.4-latest   "docker-entrypoint.sh"   46 seconds ago   Up 12 seconds (healthy)   0.0.0.0:80->8080/tcp, [::]:80->8080/tcp, 0.0.0.0:443->8443/tcp, [::]:443->8443/tcp   zabbix-docker-zabbix-web-nginx-mysql-1
6cf5a525e3a1   zabbix/zabbix-server-mysql:alpine-7.4-latest      "/usr/bin/docker-ent…"   46 seconds ago   Up 12 seconds             0.0.0.0:10051->10051/tcp, :::10051->10051/tcp                                        zabbix-docker-zabbix-server-1
32094b0289d9   mysql:8.4-oracle                                  "docker-entrypoint.s…"   47 seconds ago   Up 46 seconds                                                                                                  zabbix-docker-mysql-server-1
mickm@mickm-Latitude-7410:~/git/zabbix-docker$ 


