# Zabbix
## SQL backup in Zabbix

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

## SQL restore in Zabbix

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

## Containerlab - mounted folders config

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

## Containerlab - mounted folders from host

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

## Zabbix - Install using docker compose

```bash
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
mickm@mickm-Latitude-7410:~/git/zabbix-docker$ docker images
REPOSITORY                      TAG                 IMAGE ID       CREATED         SIZE
zabbix/zabbix-server-mysql      alpine-7.4-latest   8d6cd3b7c658   9 days ago      110MB
zabbix/zabbix-web-nginx-mysql   alpine-7.4-latest   69d382bd8ad7   9 days ago      282MB
zabbix7.4_frr                   1.0                 98a38a8e5c40   12 days ago     1.09GB
<none>                          <none>              75789162b0d1   12 days ago     1.06GB
kathara_zabbix7.4-ubuntu24      1.0                 c0e192409cc4   13 days ago     803MB
alpine_pc                       1.0                 558f54e8cfe4   13 days ago     24MB
ubuntu                          24.04               e0f16e6366fe   5 weeks ago     78.1MB
mysql                           8.4-oracle          45f1b9da918e   6 weeks ago     786MB
alpine                          latest              9234e8fb04c4   7 weeks ago     8.31MB
kathara/frr                     latest              0fbf3877a39c   6 months ago    1.06GB
kathara/base                    latest              54609bfdb680   7 months ago    1.02GB
busybox                         latest              0ed463b26dae   11 months ago   4.43MB
kathara/quagga                  latest              62dd101dfa28   23 months ago   1.09GB
mickm@mickm-Latitude-7410:~/git/zabbix-docker$
```

## Zabbix - Stop/start using docker compose

```bash
mickm@mickm-Latitude-7410:~/git/zabbix-docker$ docker compose -f ./docker-compose_v3_alpine_mysql_latest.yaml down
[+] Running 10/10
 ✔ Container zabbix-docker-zabbix-server-1           Removed                                                                                                                                                                                        0.7s 
 ✔ Container zabbix-docker-zabbix-web-nginx-mysql-1  Removed                                                                                                                                                                                        1.2s 
 ✔ Container zabbix-docker-db-data-mysql-1           Removed                                                                                                                                                                                        0.0s 
 ✔ Container zabbix-docker-server-db-init-1          Removed                                                                                                                                                                                        0.0s 
 ✔ Container zabbix-docker-mysql-server-1            Removed                                                                                                                                                                                        1.1s 
 ✔ Network zabbix-docker_default                     Removed                                                                                                                                                                                        0.8s 
 ✔ Network zabbix-docker_database                    Removed                                                                                                                                                                                        0.1s 
 ✔ Network zabbix-docker_frontend                    Removed                                                                                                                                                                                        0.3s 
 ✔ Network zabbix-docker_tools_frontend              Removed                                                                                                                                                                                        0.5s 
 ✔ Network zabbix-docker_backend                     Removed                                                                                                                                                                                        0.4s 
mickm@mickm-Latitude-7410:~/git/zabbix-docker$
mickm@mickm-Latitude-7410:~/git/zabbix-docker$ docker compose -f ./docker-compose_v3_alpine_mysql_latest.yaml up -d
[+] Running 10/10
 ✔ Network zabbix-docker_frontend                    Created                                                                                                                                                                                        0.1s 
 ✔ Network zabbix-docker_tools_frontend              Created                                                                                                                                                                                        0.1s 
 ✔ Network zabbix-docker_backend                     Created                                                                                                                                                                                        0.1s 
 ✔ Network zabbix-docker_default                     Created                                                                                                                                                                                        0.1s 
 ✔ Network zabbix-docker_database                    Created                                                                                                                                                                                        0.1s 
 ✔ Container zabbix-docker-db-data-mysql-1           Started                                                                                                                                                                                        0.2s 
 ✔ Container zabbix-docker-mysql-server-1            Started                                                                                                                                                                                        0.2s 
 ✔ Container zabbix-docker-server-db-init-1          Exited                                                                                                                                                                                         5.9s 
 ✔ Container zabbix-docker-zabbix-web-nginx-mysql-1  Started                                                                                                                                                                                        6.2s 
 ✔ Container zabbix-docker-zabbix-server-1           Started                                                                                                                                                                                        6.3s 
mickm@mickm-Latitude-7410:~/git/zabbix-docker$ 
```

## Zabbix - inside the container

```bash
mickm@mickm-Latitude-7410:~/git/zabbix-docker$ docker ps
CONTAINER ID   IMAGE                                             COMMAND                  CREATED          STATUS                    PORTS                                                                                NAMES
9a9f618f8ef4   zabbix/zabbix-web-nginx-mysql:alpine-7.4-latest   "docker-entrypoint.sh"   46 seconds ago   Up 12 seconds (healthy)   0.0.0.0:80->8080/tcp, [::]:80->8080/tcp, 0.0.0.0:443->8443/tcp, [::]:443->8443/tcp   zabbix-docker-zabbix-web-nginx-mysql-1
6cf5a525e3a1   zabbix/zabbix-server-mysql:alpine-7.4-latest      "/usr/bin/docker-ent…"   46 seconds ago   Up 12 seconds             0.0.0.0:10051->10051/tcp, :::10051->10051/tcp                                        zabbix-docker-zabbix-server-1
32094b0289d9   mysql:8.4-oracle                                  "docker-entrypoint.s…"   47 seconds ago   Up 46 seconds                                                                                                  zabbix-docker-mysql-server-1
mickm@mickm-Latitude-7410:~/git/zabbix-docker$
mickm@mickm-Latitude-7410:~/git/zabbix-docker$ docker exec -it zabbix-docker-zabbix-server-1 bash 
d949ca9b1089:~$ uname -a
Linux d949ca9b1089 6.14.0-28-generic #28~24.04.1-Ubuntu SMP PREEMPT_DYNAMIC Fri Jul 25 10:47:01 UTC 2 x86_64 Linux
d949ca9b1089:~$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
41: eth1@if42: <BROADCAST,MULTICAST,UP,LOWER_UP,M-DOWN> mtu 1500 qdisc noqueue state UP 
    link/ether 02:42:ac:10:f0:02 brd ff:ff:ff:ff:ff:ff
    inet 172.16.240.2/24 brd 172.16.240.255 scope global eth1
       valid_lft forever preferred_lft forever
49: eth2@if50: <BROADCAST,MULTICAST,UP,LOWER_UP,M-DOWN> mtu 1500 qdisc noqueue state UP 
    link/ether 02:42:ac:10:ef:03 brd ff:ff:ff:ff:ff:ff
    inet 172.16.239.3/24 brd 172.16.239.255 scope global eth2
       valid_lft forever preferred_lft forever
51: eth3@if52: <BROADCAST,MULTICAST,UP,LOWER_UP,M-DOWN> mtu 1500 qdisc noqueue state UP 
    link/ether 02:42:ac:13:00:04 brd ff:ff:ff:ff:ff:ff
    inet 172.19.0.4/16 brd 172.19.255.255 scope global eth3
       valid_lft forever preferred_lft forever
53: eth0@if54: <BROADCAST,MULTICAST,UP,LOWER_UP,M-DOWN> mtu 1500 qdisc noqueue state UP 
    link/ether 02:42:ac:10:ee:03 brd ff:ff:ff:ff:ff:ff
    inet 172.16.238.3/24 brd 172.16.238.255 scope global eth0
       valid_lft forever preferred_lft forever
d949ca9b1089:~$ ip r
default via 172.16.238.1 dev eth0 
172.16.238.0/24 dev eth0 scope link  src 172.16.238.3 
172.16.239.0/24 dev eth2 scope link  src 172.16.239.3 
172.16.240.0/24 dev eth1 scope link  src 172.16.240.2 
172.19.0.0/16 dev eth3 scope link  src 172.19.0.4 
d949ca9b1089:~$ exit
exit
mickm@mickm-Latitude-7410:~/git/zabbix-docker$ 
```

## Zabbix web UI - [Zabbix - localhost](http://localhost)

## Zabbix environment variables

```bash
mickm@mickm-Latitude-7410:~/git/zabbix-docker/env_vars$ ls -al
total 112
drwxrwxr-x 3 mickm mickm  4096 Sep  4 07:21 .
drwxrwxr-x 9 mickm mickm  4096 Sep  4 07:25 ..
-rw-rw-r-- 1 mickm mickm 28423 Sep  4 07:21 chrome_dp.json
-rw-rw-r-- 1 mickm mickm  1152 Sep  4 07:21 .env_agent
-rw-rw-r-- 1 mickm mickm   395 Sep  4 07:21 .env_db_mysql
-rw-rw-r-- 1 mickm mickm   451 Sep  4 07:21 .env_db_mysql_proxy
-rw-rw-r-- 1 mickm mickm   339 Sep  4 07:21 .env_db_pgsql
-rw-rw-r-- 1 mickm mickm   162 Sep  4 07:21 .env_java
-rw-rw-r-- 1 mickm mickm  2581 Sep  4 07:21 .env_prx
-rw-rw-r-- 1 mickm mickm   443 Sep  4 07:21 .env_prx_mysql
-rw-rw-r-- 1 mickm mickm    36 Sep  4 07:21 .env_prx_sqlite3
-rw-rw-r-- 1 mickm mickm   254 Sep  4 07:21 .env_snmptraps
-rw-rw-r-- 1 mickm mickm  3621 Sep  4 07:21 .env_srv
-rw-rw-r-- 1 mickm mickm  2104 Sep  4 07:21 .env_web
-rw-rw-r-- 1 mickm mickm   254 Sep  4 07:21 .env_web_service
drwxrwxr-x 2 mickm mickm  4096 Sep  4 07:21 mysql_init
-rw-rw-r-- 1 mickm mickm     6 Sep  4 07:21 .MYSQL_PASSWORD
-rw-rw-r-- 1 mickm mickm     8 Sep  4 07:21 .MYSQL_ROOT_PASSWORD
-rw-rw-r-- 1 mickm mickm     4 Sep  4 07:21 .MYSQL_ROOT_USER
-rw-rw-r-- 1 mickm mickm     6 Sep  4 07:21 .MYSQL_USER
-rw-rw-r-- 1 mickm mickm     6 Sep  4 07:21 .POSTGRES_PASSWORD
-rw-rw-r-- 1 mickm mickm     6 Sep  4 07:21 .POSTGRES_USER
mickm@mickm-Latitude-7410:~/git/zabbix-docker/env_vars$ more .MYSQL*
::::::::::::::
.MYSQL_PASSWORD
::::::::::::::
zabbix
::::::::::::::
.MYSQL_ROOT_PASSWORD
::::::::::::::
root_pwd
::::::::::::::
.MYSQL_ROOT_USER
::::::::::::::
root
::::::::::::::
.MYSQL_USER
::::::::::::::
zabbix
mickm@mickm-Latitude-7410:~/git/zabbix-docker/env_vars$ 
```

## Zabbix - Install using podman-compose 

Although using podman and podman-compose might be the right way to go, it didn't work first time for me - so I decided to park this to avoid getting pulled down yet another rabbit hole !!

```bash

mickm@mickm-Latitude-7410:~/git/zabbix-docker$ podman compose -f ./docker-compose_v3_alpine_mysql_latest.yaml up -d
>>>> Executing external compose provider "/usr/libexec/docker/cli-plugins/docker-compose". Please refer to the documentation for details. <<<<
unable to get image 'zabbix/zabbix-web-nginx-mysql:alpine-7.4-latest': Cannot connect to the Docker daemon at unix:///run/user/1000/podman/podman.sock. Is the docker daemon running?
Error: executing /usr/libexec/docker/cli-plugins/docker-compose -f ./docker-compose_v3_alpine_mysql_latest.yaml up -d: exit status 1
mickm@mickm-Latitude-7410:~/git/zabbix-docker$ ls
build.json                          compose_zabbix_components.yaml              docker-compose_v3_alpine_pgsql_local.yaml   docker-compose_v3_ol_mysql_latest.yaml      docker-compose_v3_ubuntu_mysql_local.yaml   kubernetes.yaml           sources
build.sh                            config_templates                            docker-compose_v3_centos_mysql_latest.yaml  docker-compose_v3_ol_mysql_local.yaml       docker-compose_v3_ubuntu_pgsql_latest.yaml  LICENSE                   zbx_env
compose_additional_components.yaml  docker-compose_v3_alpine_mysql_latest.yaml  docker-compose_v3_centos_mysql_local.yaml   docker-compose_v3_ol_pgsql_latest.yaml      docker-compose_v3_ubuntu_pgsql_local.yaml   README.md
compose_databases.yaml              docker-compose_v3_alpine_mysql_local.yaml   docker-compose_v3_centos_pgsql_latest.yaml  docker-compose_v3_ol_pgsql_local.yaml       Dockerfiles                                 SECURITY.md
compose.yaml                        docker-compose_v3_alpine_pgsql_latest.yaml  docker-compose_v3_centos_pgsql_local.yaml   docker-compose_v3_ubuntu_mysql_latest.yaml  env_vars                                    sonar-project.properties
mickm@mickm-Latitude-7410:~/git/zabbix-docker$
```

### The error message:

```
unable to get image 'zabbix/zabbix-web-nginx-mysql:alpine-7.4-latest': Cannot connect to the Docker daemon at unix:///run/user/1000/podman/podman.sock. Is the docker daemon running?
```

indicates that when running `podman compose`, the system is actually delegating to the Docker Compose plugin (`/usr/libexec/docker/cli-plugins/docker-compose`) which tries to connect to a Docker daemon socket that isn't running or accessible for Podman.

### Why this happens:

- `podman compose` is a thin wrapper that calls an external Compose provider.
- By default on your system, the Docker Compose CLI is installed and is taking precedence.
- Docker Compose expects a Docker daemon which is not running because Podman works daemonless.
- When running `docker compose` directly, it works because Docker is installed and running.

***

### How to fix this for Podman Compose usage:

1. **Use the native Podman Compose** (a separate tool):
   - Install `podman-compose` (the Python-based tool designed for Podman).
   - Run:  
     ```
     podman-compose -f ./docker-compose_v3_alpine_mysql_latest.yaml up -d
     ```
   - This does not require a running Docker daemon and is designed for Podman's rootless mode.

2. **Use Podman’s daemon socket** (if you want to continue using Docker Compose CLI):
   - Start Podman's socket:
     ```
     systemctl --user enable --now podman.socket
     ```
   - Set environment variable (for rootless Podman user):
     ```
     export DOCKER_HOST=unix:///run/user/1000/podman/podman.sock
     ```
   - Retry `podman compose` after this.

3. **Or use Docker directly** if Docker daemon is available (which you already did successfully):
   - Using `docker compose -f ... up -d` works since Docker daemon is running.

***

### Summary

- On your system, `podman compose` is calling Docker Compose CLI, which requires a Docker daemon.
- Unless you configure or enable Podman’s socket as Docker socket, `podman compose` won't work smoothly.
- For true Podman Compose usage, install and use the separate `podman-compose` tool, or start Podman's socket service.
- Alternatively, continue using Docker Compose CLI if Docker daemon is running.

This explains why `docker compose` works on your machine but `podman compose` doesn't without additional setup.[1][4][5][7]

[1](https://docs.podman.io/en/v5.3.1/markdown/podman-compose.1.html)
[2](https://podman-desktop.io/docs/migrating-from-docker/managing-docker-compatibility)
[3](https://www.reddit.com/r/podman/comments/1bk4nee/whats_the_current_canonical_way_to_run_docker/)
[4](https://www.redhat.com/en/blog/podman-docker-compose)
[5](https://www.redhat.com/en/blog/podman-compose-docker-compose)
[6](https://podman-desktop.io/docs/compose/running-compose)
[7](https://linuxconfig.org/how-to-use-docker-compose-with-podman-on-linux)
[8](https://github.com/containers/podman/discussions/14430)
[9](https://betterstack.com/community/guides/scaling-docker/podman-vs-docker/)
