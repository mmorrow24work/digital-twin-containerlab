# Git
## Use Git Clone to download a new repository

```bash
mickm@mickm-Latitude-7410:~/git$ git clone https://github.com/mmorrow24work/digital-twin-containerlab.git
Cloning into 'digital-twin-containerlab'...
remote: Enumerating objects: 398, done.
remote: Counting objects: 100% (109/109), done.
remote: Compressing objects: 100% (86/86), done.
remote: Total 398 (delta 64), reused 20 (delta 20), pack-reused 289 (from 2)
Receiving objects: 100% (398/398), 167.13 KiB | 496.00 KiB/s, done.
Resolving deltas: 100% (167/167), done.
mickm@mickm-Latitude-7410:~/git$
```

## Use git pull to download changes to a new repository
```bash
mickm@mickm-Latitude-7410:~/git$ git clone https://github.com/mmorrow24work/digital-twin-containerlab.git
fatal: destination path 'digital-twin-containerlab' already exists and is not an empty directory.
mickm@mickm-Latitude-7410:~/git$ cd digital-twin-containerlab/
mickm@mickm-Latitude-7410:~/git/digital-twin-containerlab$ git pull
remote: Enumerating objects: 91, done.
remote: Counting objects: 100% (77/77), done.
remote: Compressing objects: 100% (67/67), done.
remote: Total 91 (delta 35), reused 7 (delta 7), pack-reused 14 (from 1)
Unpacking objects: 100% (91/91), 42.32 KiB | 1.63 MiB/s, done.
From https://github.com/mmorrow24work/digital-twin-containerlab
   40b64d8..9d0a29c  main       -> origin/main
Updating 40b64d8..9d0a29c
Fast-forward
 BLOG.md                                              |  35 +++++++
 NOTES.md                                             | 198 ++++++++++++++++++++++++++++++---------
 QUICKSTART.md                                        | 145 +++++++++++++++++++++++++++++
 README.md                                            |  70 ++++----------
 docker_custom_image/frr-snmp/AI.md                   | 960 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 docker_custom_image/frr-snmp/Dockerfile              |  36 ++++++++
 docker_custom_image/frr-snmp/configs/frr/daemons     |  57 ++++++++++++
 docker_custom_image/frr-snmp/configs/frr/frr.conf    |  28 ++++++
 docker_custom_image/frr-snmp/configs/snmp/snmpd.conf |  72 +++++++++++++++
 docker_custom_image/frr-snmp/start-frr-snmp.sh       |  72 +++++++++++++++
 10 files changed, 1579 insertions(+), 94 deletions(-)
 create mode 100644 BLOG.md
 create mode 100644 QUICKSTART.md
 create mode 100644 docker_custom_image/frr-snmp/AI.md
 create mode 100644 docker_custom_image/frr-snmp/Dockerfile
 create mode 100644 docker_custom_image/frr-snmp/configs/frr/daemons
 create mode 100644 docker_custom_image/frr-snmp/configs/frr/frr.conf
 create mode 100644 docker_custom_image/frr-snmp/configs/snmp/snmpd.conf
 create mode 100644 docker_custom_image/frr-snmp/start-frr-snmp.sh
mickm@mickm-Latitude-7410:~/git/digital-twin-containerlab$
```

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
## SQL backup in Zabbix - delta

Using the default Zabbix MySQL container, I had to run the backps as user ```root```, not user ```zabbix```

```bash
bash-5.1# mariadb-dump -u zabbix -p --single-transaction --quick --lock-tables=false zabbix | gzip > /home/zabbix_backup.sql.gz
bash: mariadb-dump: command not found
bash-5.1# mysqldump -u zabbix -p --single-transaction --quick --lock-tables=false zabbix | gzip > /home/zabbix_backup.sql.gz
Enter password:
mysqldump: Error: 'Access denied; you need (at least one of) the PROCESS privilege(s) for this operation' when trying to dump tablespaces
bash-5.1# mysqldump -u root -p --single-transaction --quick --lock-tables=false zabbix | gzip > /home/zabbix_backup.sql.gz
Enter password:
bash-5.1# ls -ltrh /home
total 4.5M
-rw-r--r-- 1 root root 4.5M Sep  4 15:34 zabbix_backup.sql.gz
bash-5.1#
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

### Zabbix - Stop/start using docker compose

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

### Zabbix - inside the container

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

### Zabbix web UI - [Zabbix - localhost](http://localhost)

### Zabbix environment variables

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

## Zabbix - Install using podman compose or podman-compose - fails on first attempt

Although using podman compose or podman-compose might be the right way to go, it didn't work first time for me - so I decided to park this to avoid getting pulled down yet another rabbit hole !!

I created an [ISSUE](https://github.com/mmorrow24work/digital-twin-containerlab/issues/20) for it - so I don't forget it.

# Containerlab

## Containerlab - start lab

```bash
mickm@mickm-Latitude-7410:~/git/containerlab/lab-examples/frr01$ ./run.sh
14:30:12 INFO Containerlab started version=0.69.3
14:30:12 INFO Parsing & checking topology file=frr01.clab.yml
14:30:12 INFO Creating docker network name=clab IPv4 subnet=172.20.20.0/24 IPv6 subnet=3fff:172:20:20::/64 MTU=1500
14:30:12 INFO Creating lab directory path=/home/mickm/git/containerlab/lab-examples/frr01/clab-frr01
14:30:12 INFO Creating container name=PC2
14:30:12 INFO Creating container name=router2
14:30:12 INFO Creating container name=router3
14:30:12 INFO Creating container name=PC1
14:30:12 INFO Creating container name=router1
14:30:12 INFO Creating container name=PC3
14:30:13 INFO Created link: PC3:eth1 ▪┄┄▪ router3:eth3
14:30:13 INFO Created link: router2:eth2 ▪┄┄▪ router3:eth2
14:30:13 INFO Created link: PC2:eth1 ▪┄┄▪ router2:eth3
14:30:13 INFO Created link: router1:eth1 ▪┄┄▪ router2:eth1
14:30:13 INFO Created link: router1:eth2 ▪┄┄▪ router3:eth1
14:30:13 INFO Created link: PC1:eth1 ▪┄┄▪ router1:eth3
14:30:13 INFO Adding host entries path=/etc/hosts
14:30:13 INFO Adding SSH config for nodes path=/etc/ssh/ssh_config.d/clab-frr01.conf
You are on the latest version (0.69.3)
╭────────────────────┬─────────────────────────────────┬─────────┬───────────────────╮
│        Name        │            Kind/Image           │  State  │   IPv4/6 Address  │
├────────────────────┼─────────────────────────────────┼─────────┼───────────────────┤
│ clab-frr01-PC1     │ linux                           │ running │ 172.20.20.3       │
│                    │ alpine_pc:1.0                   │         │ 3fff:172:20:20::3 │
├────────────────────┼─────────────────────────────────┼─────────┼───────────────────┤
│ clab-frr01-PC2     │ linux                           │ running │ 172.20.20.2       │
│                    │ praqma/network-multitool:latest │         │ 3fff:172:20:20::2 │
├────────────────────┼─────────────────────────────────┼─────────┼───────────────────┤
│ clab-frr01-PC3     │ linux                           │ running │ 172.20.20.6       │
│                    │ praqma/network-multitool:latest │         │ 3fff:172:20:20::6 │
├────────────────────┼─────────────────────────────────┼─────────┼───────────────────┤
│ clab-frr01-router1 │ linux                           │ running │ 172.20.20.7       │
│                    │ frrouting/frr:v7.5.1            │         │ 3fff:172:20:20::7 │
├────────────────────┼─────────────────────────────────┼─────────┼───────────────────┤
│ clab-frr01-router2 │ linux                           │ running │ 172.20.20.5       │
│                    │ frrouting/frr:v7.5.1            │         │ 3fff:172:20:20::5 │
├────────────────────┼─────────────────────────────────┼─────────┼───────────────────┤
│ clab-frr01-router3 │ linux                           │ running │ 172.20.20.4       │
│                    │ frrouting/frr:v7.5.1            │         │ 3fff:172:20:20::4 │
╰────────────────────┴─────────────────────────────────┴─────────┴───────────────────╯
mickm@mickm-Latitude-7410:~/git/containerlab/lab-examples/frr01$
```

## Containerlab - stop lab

```bash
mickm@mickm-Latitude-7410:~/git/containerlab/lab-examples/frr01$ clab destroy --topo frr01.clab.yml
14:27:18 INFO Parsing & checking topology file=frr01.clab.yml
14:27:18 INFO Parsing & checking topology file=frr01.clab.yml
14:27:18 INFO Destroying lab name=frr01
14:27:18 INFO Removed container name=clab-frr01-PC3
14:27:18 INFO Removed container name=clab-frr01-PC1
14:27:18 INFO Removed container name=clab-frr01-PC2
14:27:18 INFO Removed container name=clab-frr01-router3
14:27:18 INFO Removed container name=clab-frr01-router2
14:27:18 INFO Removed container name=clab-frr01-router1
14:27:18 INFO Removing host entries path=/etc/hosts
14:27:18 INFO Removing SSH config path=/etc/ssh/ssh_config.d/clab-frr01.conf
mickm@mickm-Latitude-7410:~/git/containerlab/lab-examples/frr01$
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

# SNMP 

A **test SNMP trap** can be sent from the command line using the `snmptrap` utility, which is part of the `net-snmp` package on Linux systems. This command helps simulate SNMP events for monitoring or troubleshooting.[1][2]

## Example SNMP Trap Command

Here’s a common test SNMP trap for SNMP v2c:

```
snmptrap -v 2c -c public 127.0.0.1 '' SNMPv2-MIB::coldStart SNMPv2-MIB::sysName.0 s "MyDevice"
```
- `-v 2c` specifies SNMP version 2c.
- `-c public` sets the community string.
- `127.0.0.1` is the destination IP address (the trap receiver, often localhost for tests).
- `''` is a required but empty uptime field.
- `SNMPv2-MIB::coldStart` is the trap OID.
- `SNMPv2-MIB::sysName.0 s "MyDevice"` passes a variable (sysName) with type string and value "MyDevice".[3][2][1]

## SNMP Trap with a Custom OID

To send a trap using a specific OID, for example, for printer alerts:
```
snmptrap -v 2c -c public 127.0.0.1 '' .1.3.6.1.2.1.43.18.2.0.1
```
You must provide all required variable bindings per the trap specification.[4]

## Notes
- Ensure `snmptrap` is installed (`sudo apt install snmp snmptrapd` on Debian/Ubuntu).
- Make sure your SNMP trap daemon is running and configured to listen on the correct address and port.[1]
- SNMP v3 traps require more authentication and encryption options.[3]

## Troubleshooting
- Confirm the correct community string and IP.
- Verify your firewall allows UDP SNMP traffic (default port 162 for traps).
- Check `snmptrapd` or another SNMP manager for received traps.[2][1]

This method simulates SNMP events in test setups or for integration checks with SNMP-based monitoring systems.[2][1]

[1](https://www.baeldung.com/linux/snmp-trap-send)
[2](https://stackoverflow.com/questions/49857532/can-snmp-trap-be-faked)
[3](https://support.nagios.com/kb/article/snmp-trap-how-to-send-a-test-trap-493.html)
[4](https://stackoverflow.com/questions/37119903/send-a-notification-trap-snmp-with-snmptrap-command-linux)
[5](https://community.splunk.com/t5/Deployment-Architecture/How-to-send-snmp-traps-from-my-Linux-machine-to-a-Splunk-indexer/m-p/145240)
[6](https://techkluster.com/linux/snmp-trap-send/)
[7](https://stackoverflow.com/questions/19947680/what-is-the-correct-snmptrap-command-format)
[8](https://www.ibm.com/docs/sv/ssw_aix_72/s_commands/snmptrap.html)
[9](http://www.net-snmp.org/tutorial/tutorial-5/commands/snmptrap.html)
[10](https://knowledge.broadcom.com/external/article/57331/how-to-manually-generate-traps-and-test.html)

# Iperf3 examples

## Iperf3 - server recieves packets

```bash
mickm@mickm-Latitude-7410:~$ docker exec -it clab-frr01-PC1 bash
PC1:/#
PC1:/# iperf3 -s
-----------------------------------------------------------
Server listening on 5201 (test #1)
-----------------------------------------------------------
Accepted connection from 3fff:172:20:20::6, port 47692
[  5] local 3fff:172:20:20::5 port 5201 connected to 3fff:172:20:20::6 port 33760
[ ID] Interval           Transfer     Bitrate         Jitter    Lost/Total Datagrams
[  5]   0.00-1.00   sec  5.96 MBytes  50.0 Mbits/sec  0.002 ms  0/4379 (0%)
[  5]   1.00-2.00   sec  5.96 MBytes  50.0 Mbits/sec  0.002 ms  0/4378 (0%)
[  5]   2.00-3.00   sec  5.96 MBytes  50.0 Mbits/sec  0.002 ms  0/4375 (0%)
[  5]   3.00-4.00   sec  5.96 MBytes  50.0 Mbits/sec  0.001 ms  0/4377 (0%)
[  5]   4.00-5.00   sec  5.96 MBytes  50.0 Mbits/sec  0.001 ms  0/4377 (0%)
[  5]   5.00-6.00   sec  5.96 MBytes  50.0 Mbits/sec  0.002 ms  0/4379 (0%)
[  5]   6.00-7.00   sec  5.96 MBytes  50.0 Mbits/sec  0.010 ms  0/4374 (0%)
[  5]   7.00-8.00   sec  5.96 MBytes  50.0 Mbits/sec  0.002 ms  0/4377 (0%)
[  5]   8.00-9.00   sec  5.96 MBytes  50.0 Mbits/sec  0.002 ms  0/4377 (0%)
[  5]   9.00-10.00  sec  5.96 MBytes  50.0 Mbits/sec  0.001 ms  0/4377 (0%)
[  5]  10.00-11.00  sec  5.96 MBytes  50.0 Mbits/sec  0.001 ms  0/4376 (0%)
[  5]  11.00-12.00  sec  5.96 MBytes  50.0 Mbits/sec  0.001 ms  0/4378 (0%)
[  5]  12.00-13.00  sec  5.96 MBytes  50.0 Mbits/sec  0.003 ms  0/4376 (0%)
[  5]  13.00-14.00  sec  5.96 MBytes  50.0 Mbits/sec  0.001 ms  0/4376 (0%)
[  5]  14.00-15.00  sec  5.96 MBytes  50.0 Mbits/sec  0.001 ms  0/4377 (0%)
[  5]  15.00-16.00  sec  5.96 MBytes  50.0 Mbits/sec  0.001 ms  0/4377 (0%)
[  5]  16.00-17.00  sec  5.96 MBytes  50.0 Mbits/sec  0.001 ms  0/4377 (0%)
[  5]  17.00-18.00  sec  5.96 MBytes  50.0 Mbits/sec  0.001 ms  0/4377 (0%)
[  5]  18.00-19.00  sec  5.96 MBytes  50.0 Mbits/sec  0.010 ms  0/4377 (0%)
[  5]  19.00-20.00  sec  5.96 MBytes  50.0 Mbits/sec  0.009 ms  0/4376 (0%)
[  5]  20.00-21.00  sec  5.96 MBytes  50.0 Mbits/sec  0.001 ms  0/4377 (0%)
[  5]  21.00-22.00  sec  5.96 MBytes  50.0 Mbits/sec  0.001 ms  0/4377 (0%)
[  5]  22.00-23.00  sec  5.96 MBytes  50.0 Mbits/sec  0.001 ms  0/4376 (0%)
[  5]  23.00-24.00  sec  5.96 MBytes  50.0 Mbits/sec  0.001 ms  0/4378 (0%)
[  5]  24.00-25.00  sec  5.96 MBytes  50.0 Mbits/sec  0.004 ms  0/4376 (0%)
[  5]  25.00-26.00  sec  5.96 MBytes  50.0 Mbits/sec  0.001 ms  0/4376 (0%)
[  5]  26.00-27.00  sec  5.96 MBytes  50.0 Mbits/sec  0.001 ms  0/4377 (0%)
[  5]  27.00-28.00  sec  5.96 MBytes  50.0 Mbits/sec  0.001 ms  0/4377 (0%)
[  5]  28.00-29.00  sec  5.96 MBytes  50.0 Mbits/sec  0.001 ms  0/4379 (0%)
[  5]  29.00-30.00  sec  5.96 MBytes  50.0 Mbits/sec  0.002 ms  0/4375 (0%)
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Jitter    Lost/Total Datagrams
[  5]   0.00-30.00  sec   179 MBytes  50.0 Mbits/sec  0.002 ms  0/131305 (0%)  receiver
-----------------------------------------------------------
```

## Iperf3 - client sends packets

```bash
mickm@mickm-Latitude-7410:~$ docker exec -it clab-frr01-PC2 bash
PC2:/# iperf3 -c PC1 -u -b 50M -t 30
Connecting to host PC1, port 5201
[  5] local 3fff:172:20:20::6 port 33760 connected to 3fff:172:20:20::5 port 5201
[ ID] Interval           Transfer     Bitrate         Total Datagrams
[  5]   0.00-1.00   sec  5.96 MBytes  50.0 Mbits/sec  4379
[  5]   1.00-2.00   sec  5.96 MBytes  50.0 Mbits/sec  4377
[  5]   2.00-3.00   sec  5.96 MBytes  50.0 Mbits/sec  4376
[  5]   3.00-4.00   sec  5.96 MBytes  50.0 Mbits/sec  4377
[  5]   4.00-5.00   sec  5.96 MBytes  50.0 Mbits/sec  4377
[  5]   5.00-6.00   sec  5.96 MBytes  50.0 Mbits/sec  4377
[  5]   6.00-7.00   sec  5.96 MBytes  50.0 Mbits/sec  4376
[  5]   7.00-8.00   sec  5.96 MBytes  50.0 Mbits/sec  4378
[  5]   8.00-9.00   sec  5.96 MBytes  50.0 Mbits/sec  4377
[  5]   9.00-10.00  sec  5.96 MBytes  50.0 Mbits/sec  4376
[  5]  10.00-11.00  sec  5.96 MBytes  50.0 Mbits/sec  4376
[  5]  11.00-12.00  sec  5.96 MBytes  50.0 Mbits/sec  4377
[  5]  12.00-13.00  sec  5.96 MBytes  50.0 Mbits/sec  4377
[  5]  13.00-14.00  sec  5.96 MBytes  50.0 Mbits/sec  4377
[  5]  14.00-15.00  sec  5.96 MBytes  50.0 Mbits/sec  4376
[  5]  15.00-16.00  sec  5.96 MBytes  50.0 Mbits/sec  4378
[  5]  16.00-17.00  sec  5.96 MBytes  50.0 Mbits/sec  4376
[  5]  17.00-18.00  sec  5.96 MBytes  50.0 Mbits/sec  4377
[  5]  18.00-19.00  sec  5.96 MBytes  50.0 Mbits/sec  4377
[  5]  19.00-20.00  sec  5.96 MBytes  50.0 Mbits/sec  4377
[  5]  20.00-21.00  sec  5.96 MBytes  50.0 Mbits/sec  4376
[  5]  21.00-22.00  sec  5.96 MBytes  50.0 Mbits/sec  4377
[  5]  22.00-23.00  sec  5.96 MBytes  50.0 Mbits/sec  4376
[  5]  23.00-24.00  sec  5.96 MBytes  50.0 Mbits/sec  4377
[  5]  24.00-25.00  sec  5.96 MBytes  50.0 Mbits/sec  4377
[  5]  25.00-26.00  sec  5.96 MBytes  50.0 Mbits/sec  4377
[  5]  26.00-27.00  sec  5.96 MBytes  50.0 Mbits/sec  4379
[  5]  27.00-28.00  sec  5.96 MBytes  50.0 Mbits/sec  4374
[  5]  28.00-29.00  sec  5.96 MBytes  50.0 Mbits/sec  4380
[  5]  29.00-30.00  sec  5.96 MBytes  50.0 Mbits/sec  4374
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Jitter    Lost/Total Datagrams
[  5]   0.00-30.00  sec   179 MBytes  50.0 Mbits/sec  0.000 ms  0/131305 (0%)  sender
[  5]   0.00-30.00  sec   179 MBytes  50.0 Mbits/sec  0.002 ms  0/131305 (0%)  receiver

iperf Done.
PC2:/#
```

## Iperf3 single-threaded 

The default `iperf3` server (`iperf3 -s`) can only handle one client test at a time per server process. It accepts a single client connection at once, so multiple simultaneous test sessions are not supported on the same port.

### Details:

- `iperf3` server is single-threaded and allows just one test connection at a time on the listening port (default 5201).
- The `--parallel` option applies to client-side streams (multiple streams inside one client test), but the server itself still handles just one client session at a time.
- To run multiple simultaneous tests, you need to start multiple `iperf3` server instances, each listening on a different port.
- Example for multiple server instances:
  ```bash
  iperf3 -s -p 5201 &
  iperf3 -s -p 5202 &
  ```
- Clients connect to different server ports accordingly.
- Some users build load balancers or brokers to schedule multiple iperf3 tests, but this is outside of default iperf3 functionality.
- `iperf2` supports multiple clients simultaneously, but has other limitations compared to `iperf3`.

### Summary:

- **One iperf3 server process = one simultaneous client connection.**
- Use multiple server processes on different ports to handle multiple tests in parallel.

### References:
- Discussions and issues in iperf3 repository confirming single-client server behavior.[1][3][5][6][7]

[1](https://www.reddit.com/r/networking/comments/sku8cy/iperf_for_multi_streams/)
[2](https://www.jeffgeerling.com/blog/2025/benchmarking-multiple-network-interfaces-once-linux-iperf3)
[3](https://github.com/esnet/iperf/issues/327)
[4](https://github.com/esnet/iperf/discussions/1276)
[5](https://fasterdata.es.net/performance-testing/network-troubleshooting-tools/iperf/multi-stream-iperf3/)
[6](https://iperf.fr/iperf-doc.php)
[7](https://engineering.qubecinema.com/2020/08/08/load-balancing-iperf3-servers.html)
