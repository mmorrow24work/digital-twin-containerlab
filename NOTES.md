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
docker compose -f ./docker-compose_v3_alpine_mysql_latest.yaml down
```
```bash
docker compose -f ./docker-compose_v3_alpine_mysql_latest.yaml up -d
```
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
## Zabbix agent - Verify package is installed

```bash 
mickm@mickm-Latitude-7410:~/git/containerlab/lab-examples/frr01$ docker exec -it clab-frr01-PC1 bash
PC1:/# apk list
WARNING: opening from cache https://dl-cdn.alpinelinux.org/alpine/v3.22/main: No such file or directory
WARNING: opening from cache https://dl-cdn.alpinelinux.org/alpine/v3.22/community: No such file or directory
alpine-baselayout-3.7.0-r0 x86_64 {alpine-baselayout} (GPL-2.0-only) [installed]
alpine-baselayout-data-3.7.0-r0 x86_64 {alpine-baselayout} (GPL-2.0-only) [installed]
alpine-keys-2.5-r0 x86_64 {alpine-keys} (MIT) [installed]
alpine-release-3.22.1-r0 x86_64 {alpine-base} (MIT) [installed]
apk-tools-2.14.9-r2 x86_64 {apk-tools} (GPL-2.0-only) [installed]
bash-5.2.37-r0 x86_64 {bash} (GPL-3.0-or-later) [installed]
brotli-libs-1.1.0-r2 x86_64 {brotli} (MIT) [installed]
busybox-1.37.0-r18 x86_64 {busybox} (GPL-2.0-only) [installed]
busybox-binsh-1.37.0-r18 x86_64 {busybox} (GPL-2.0-only) [installed]
c-ares-1.34.5-r0 x86_64 {c-ares} (MIT) [installed]
ca-certificates-bundle-20250619-r0 x86_64 {ca-certificates} (MPL-2.0 AND MIT) [installed]
iperf3-3.19.1-r0 x86_64 {iperf3} (BSD-3-Clause-LBNL) [installed]
iproute2-6.15.0-r0 x86_64 {iproute2} (GPL-2.0-or-later) [installed]
iproute2-minimal-6.15.0-r0 x86_64 {iproute2} (GPL-2.0-or-later) [installed]
iproute2-ss-6.15.0-r0 x86_64 {iproute2} (GPL-2.0-or-later) [installed]
iproute2-tc-6.15.0-r0 x86_64 {iproute2} (GPL-2.0-or-later) [installed]
iputils-20240905-r0 x86_64 {iputils} (BSD-3-Clause AND GPL-2.0-or-later) [installed]
iputils-arping-20240905-r0 x86_64 {iputils} (BSD-3-Clause AND GPL-2.0-or-later) [installed]
iputils-clockdiff-20240905-r0 x86_64 {iputils} (BSD-3-Clause AND GPL-2.0-or-later) [installed]
iputils-ping-20240905-r0 x86_64 {iputils} (BSD-3-Clause AND GPL-2.0-or-later) [installed]
iputils-tracepath-20240905-r0 x86_64 {iputils} (BSD-3-Clause AND GPL-2.0-or-later) [installed]
libapk2-2.14.9-r2 x86_64 {apk-tools} (GPL-2.0-only) [installed]
libcap2-2.76-r0 x86_64 {libcap} (BSD-3-Clause OR GPL-2.0-only) [installed]
libcrypto3-3.5.1-r0 x86_64 {openssl} (Apache-2.0) [installed]
libcurl-8.14.1-r1 x86_64 {curl} (curl) [installed]
libelf-0.193-r0 x86_64 {elfutils} (GPL-3.0-or-later AND ( GPL-2.0-or-later OR LGPL-3.0-or-later )) [installed]
libidn2-2.3.7-r0 x86_64 {libidn2} (GPL-2.0-or-later OR LGPL-3.0-or-later) [installed]
libmnl-1.0.5-r2 x86_64 {libmnl} (LGPL-2.1-or-later) [installed]
libncursesw-6.5_p20250503-r0 x86_64 {ncurses} (X11) [installed]
libpcap-1.10.5-r1 x86_64 {libpcap} (BSD-3-Clause) [installed]
libpsl-0.21.5-r3 x86_64 {libpsl} (MIT) [installed]
libssl3-3.5.1-r0 x86_64 {openssl} (Apache-2.0) [installed]
libunistring-1.3-r0 x86_64 {libunistring} (GPL-2.0-or-later OR LGPL-3.0-or-later) [installed]
libxtables-1.8.11-r1 x86_64 {iptables} (GPL-2.0-or-later) [installed]
musl-1.2.5-r10 x86_64 {musl} (MIT) [installed]
musl-utils-1.2.5-r10 x86_64 {musl} (MIT AND BSD-2-Clause AND GPL-2.0-or-later) [installed]
ncurses-terminfo-base-6.5_p20250503-r0 x86_64 {ncurses} (X11) [installed]
net-snmp-5.9.4-r1 x86_64 {net-snmp} (Net-SNMP) [installed]
net-snmp-agent-libs-5.9.4-r1 x86_64 {net-snmp} (Net-SNMP) [installed]
net-snmp-libs-5.9.4-r1 x86_64 {net-snmp} (Net-SNMP) [installed]
net-snmp-tools-5.9.4-r1 x86_64 {net-snmp} (Net-SNMP) [installed]
nghttp2-libs-1.65.0-r0 x86_64 {nghttp2} (MIT) [installed]
pcre2-10.43-r1 x86_64 {pcre2} (BSD-3-Clause) [installed]
readline-8.2.13-r1 x86_64 {readline} (GPL-3.0-or-later) [installed]
scanelf-1.3.8-r1 x86_64 {pax-utils} (GPL-2.0-only) [installed]
softflowd-1.1.0-r0 x86_64 {softflowd} (BSD-2-Clause) [installed]
ssl_client-1.37.0-r18 x86_64 {busybox} (GPL-2.0-only) [installed]
zabbix-agent-7.2.11-r1 x86_64 {zabbix} (AGPL-3.0-only) [installed]
zlib-1.3.1-r2 x86_64 {zlib} (Zlib) [installed]
zstd-libs-1.5.7-r0 x86_64 {zstd} (BSD-3-Clause OR GPL-2.0-or-later) [installed]
PC1:/# exit
exit
mickm@mickm-Latitude-7410:~/git/containerlab/lab-examples/frr01$ 
```

## Zabbix agent - test it's working and open to connections from the Zabbix server

```bash
mickm@mickm-Latitude-7410:~/git/containerlab/lab-examples/frr01$ docker exec -it clab-frr01-PC1 bash
PC1:/# grep Server  /etc/zabbix/zabbix_agentd.conf
### Option: Server
#       Example: Server=127.0.0.1,192.168.1.0/24,::1,2001:db8::/32,zabbix.example.com
# Server=
Server=192.168.10.7
### Option: ServerActive
#       Server/proxy address is IP address or DNS name and optional port separated by colon.
#               ServerActive=127.0.0.1:10051
#               ServerActive=127.0.0.1:20051,zabbix.domain,[::1]:30051,::1,[12fc::1]
#               ServerActive=zabbix.cluster.node1;zabbix.cluster.node2:20051;zabbix.cluster.node3
#               ServerActive=zabbix.cluster.node1;zabbix.cluster.node2:20051,zabbix.cluster2.node1;zabbix.cluster2.node2,zabbix.domain
# ServerActive=
ServerActive=127.0.0.1
#       all collected data to Zabbix Server or Proxy if the buffer is full.
#       Maximum number of new lines the agent will send per second to Zabbix Server
### Option: TLSServerCertIssuer
# TLSServerCertIssuer=
### Option: TLSServerCertSubject
# TLSServerCertSubject=
PC1:/#
```
## Zabbix agent - change server

To configure a Zabbix agent so it can accept connections and send data to any Zabbix server IP, you need to:

### 1. Modify the agent configuration file, usually:
- `/etc/zabbix/zabbix_agentd.conf` for the classic agent
- or `/etc/zabbix/zabbix_agent2.conf` for agent2

### 2. Set the `Server` and `ServerActive` parameters as follows:
- `Server` is a comma-separated list of IP addresses or hostnames of Zabbix servers or proxies allowed to connect to the agent (passive checks).
- `ServerActive` is a list of servers to which the agent should send data (active checks).

To allow any server IP, you can use `0.0.0.0/0` (whole IPv4) or not restrict this, but this is a **security risk**.

Example:

```ini
Server=0.0.0.0/0
ServerActive=0.0.0.0/0
```

Or specify multiple IPs:

```ini
Server=192.168.1.10,192.168.1.11
ServerActive=192.168.1.10,192.168.1.11
```

### 3. Set `Hostname` parameter:
- This should be the unique hostname the agent uses when registering or reporting to the server.
- Ensure this hostname matches the host configured in the Zabbix frontend.

### 4. Restart the Zabbix agent service to apply changes:
```bash
sudo systemctl restart zabbix-agent
```

***

### Important security note:
- Allowing `0.0.0.0/0` effectively lets any host communicate with the agent, which can expose monitored hosts to potential malicious access.
- Ideally, restrict `Server` and `ServerActive` to specific trusted Zabbix server or proxy IPs/subnets.
- Use firewalls and network segmentation to protect your agent endpoints.

***

### Summary:
| Parameter     | Purpose                             | Example                       |
|---------------|-----------------------------------|-------------------------------|
| `Server`      | IP(s) allowed to connect (passive)| `0.0.0.0/0` or `192.168.1.10` |
| `ServerActive`| IP(s) agent sends active checks to| `0.0.0.0/0` or `192.168.1.10` |
| `Hostname`    | Unique hostname for the agent      | `myhost.example.com`           |

For detailed steps and examples, see Zabbix agent configuration documentation and forum discussions.[1][2][4][8][9]

[1](https://www.zabbix.com/forum/zabbix-troubleshooting-and-problems/47581-zabbix-agent-configuration)
[2](https://www.devopsschool.com/blog/how-to-install-configure-zabbix-agent/)
[3](https://kalpchobisa.hashnode.dev/step-by-step-guide-setting-up-a-zabbix-server-and-understanding-key-terminologies)
[4](https://www.reddit.com/r/zabbix/comments/1kgsgga/how_should_i_configure_zabbix_agent_when_i_have/)
[5](https://www.zabbix.com/forum/zabbix-troubleshooting-and-problems/440691-how-to-change-zabbix-server-ip-address)
[6](https://www.zabbix.com/documentation/current/en/manual/concepts/agent)
[7](https://www.zabbix.com/forum/zabbix-help/454938-zabbix-configuration-change-server-ip-address)
[8](https://gist.github.com/devops-school/64a6b4a8aca5461c48d11d11fbfa901c)
[9](https://www.zabbix.com/forum/zabbix-help/450578-monitor-agent-host-through-2-ip-addresses)


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

## Zabbix agent

To configure a Zabbix agent so it can accept connections and send data to any Zabbix server IP, you need to:

### 1. Modify the agent configuration file, usually:
- `/etc/zabbix/zabbix_agentd.conf` for the classic agent
- or `/etc/zabbix/zabbix_agent2.conf` for agent2

### 2. Set the `Server` and `ServerActive` parameters as follows:
- `Server` is a comma-separated list of IP addresses or hostnames of Zabbix servers or proxies allowed to connect to the agent (passive checks).
- `ServerActive` is a list of servers to which the agent should send data (active checks).

To allow any server IP, you can use `0.0.0.0/0` (whole IPv4) or not restrict this, but this is a **security risk**.

Example:

```ini
Server=0.0.0.0/0
ServerActive=0.0.0.0/0
```

Or specify multiple IPs:

```ini
Server=192.168.1.10,192.168.1.11
ServerActive=192.168.1.10,192.168.1.11
```

### 3. Set `Hostname` parameter:
- This should be the unique hostname the agent uses when registering or reporting to the server.
- Ensure this hostname matches the host configured in the Zabbix frontend.

### 4. Restart the Zabbix agent service to apply changes:
```bash
sudo systemctl restart zabbix-agent
```

***

### Important security note:
- Allowing `0.0.0.0/0` effectively lets any host communicate with the agent, which can expose monitored hosts to potential malicious access.
- Ideally, restrict `Server` and `ServerActive` to specific trusted Zabbix server or proxy IPs/subnets.
- Use firewalls and network segmentation to protect your agent endpoints.

***

### Summary:
| Parameter     | Purpose                             | Example                       |
|---------------|-----------------------------------|-------------------------------|
| `Server`      | IP(s) allowed to connect (passive)| `0.0.0.0/0` or `192.168.1.10` |
| `ServerActive`| IP(s) agent sends active checks to| `0.0.0.0/0` or `192.168.1.10` |
| `Hostname`    | Unique hostname for the agent      | `myhost.example.com`           |

For detailed steps and examples, see Zabbix agent configuration documentation and forum discussions.[1][2][4][8][9]

[1](https://www.zabbix.com/forum/zabbix-troubleshooting-and-problems/47581-zabbix-agent-configuration)
[2](https://www.devopsschool.com/blog/how-to-install-configure-zabbix-agent/)
[3](https://kalpchobisa.hashnode.dev/step-by-step-guide-setting-up-a-zabbix-server-and-understanding-key-terminologies)
[4](https://www.reddit.com/r/zabbix/comments/1kgsgga/how_should_i_configure_zabbix_agent_when_i_have/)
[5](https://www.zabbix.com/forum/zabbix-troubleshooting-and-problems/440691-how-to-change-zabbix-server-ip-address)
[6](https://www.zabbix.com/documentation/current/en/manual/concepts/agent)
[7](https://www.zabbix.com/forum/zabbix-help/454938-zabbix-configuration-change-server-ip-address)
[8](https://gist.github.com/devops-school/64a6b4a8aca5461c48d11d11fbfa901c)
[9](https://www.zabbix.com/forum/zabbix-help/450578-monitor-agent-host-through-2-ip-addresses)


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

# Docker 

## Docker stats

When containers show 100% CPU usage but the host CPU usage is low (e.g., 2%), especially on a bare metal host, this usually means:

1. **CPU Usage Measurement Differences:**
   - Container CPU % is often shown relative to a single CPU core.
   - If your host has multiple cores, container 100% means fully loaded on one core, but host % is averaged over all cores.
   - So a container can be pegged at 100% CPU on 1 core while host CPU % remains low overall.

2. **Containers may be CPU bound or running busy loops:**
   - Container workloads might be maxing out CPU on one or more cores.
   - Inspect container processes for infinite loops or polling.

3. **No resource limits by default:**
   - By default, containers can use **all available CPU** on the host.
   - If you want to **limit** container CPU usage or allocate more resources, Docker/Podman allows setting CPU constraints.

***

### How to Allocate or Limit CPU resources to containers

- Docker run options to limit or allocate CPUs:

| Option           | Description                                         | Example                            |
|------------------|-----------------------------------------------------|----------------------------------|
| `--cpus`         | Limit number of CPUs available to container          | `--cpus="2.5"` (2 and a half CPUs) |
| `--cpu-shares`   | Relative CPU weight (default 1024)                     | `--cpu-shares=512` (half priority) |
| `--cpuset-cpus`  | Pin container to specific CPUs                          | `--cpuset-cpus="0,1"` (cores 0 and 1) |

Example:

```bash
docker run --cpus="1.5" ...
```

- Podman supports similar flags.

***

### Additional tips:

- Monitor container CPU usage with:
  ```bash
  docker stats
  ```
- Investigate process inside container (e.g., top, htop).
- Optimize application workload to avoid busy waiting.
- On bare metal, containers may compete for CPU differently than VMs, causing high usage visible on containers but low averaged host load.
- You can also assign CPU quotas and shares to control container CPU usage more granularly.
- Monitor for runaway processes or scripts inside containers.

***

### Summary

- Containers by default can use all CPUs on the host unless limited.
- 100% CPU in container usually means one core is fully utilized.
- Limit CPU allocation using Docker `--cpus`, `--cpu-shares`, or `--cpuset-cpus`.
- Monitor and optimize container workloads for CPU usage.

This explains why your containers may show full CPU utilization independently of low host-wide average CPU load and how to allocate or constrain resources effectively.[1][4][5][8]

[1](https://stackoverflow.com/questions/53322102/docker-container-cpu-usage-exceeds-100-sometimes-when-streaming-from-docker-st)
[2](https://answers.ros.org/question/298364)
[3](https://forums.docker.com/t/dockerd-using-100-cpu/94962)
[4](https://www.reddit.com/r/docker/comments/uy8nvn/docker_and_using_maximum_cpu_from_host_in_a/)
[5](https://phoenixnap.com/kb/docker-memory-and-cpu-limit)
[6](https://www.scoutapm.com/blog/docker-performance)
[7](https://github.com/docker/for-mac/issues/7643)
[8](https://community.adminforge.de/t/troubleshooting-high-cpu-usage-in-docker-containers-on-linux/828)
[9](https://www.atlantic.net/dedicated-server-hosting/how-to-check-docker-container-ram-and-cpu-usage/)

### Example docker stats

```bash
mickm@mickm-Latitude-7410:~$ docker stats
CONTAINER ID   NAME                                     CPU %     MEM USAGE / LIMIT     MEM %     NET I/O          BLOCK I/O         PIDS
3bac7ee40d45   clab-frr01-router1                       0.27%     17.09MiB / 15.29GiB   0.11%     476kB / 1.13MB   4.1kB / 152kB     17
e01a5f87795e   clab-frr01-router3                       0.13%     17.13MiB / 15.29GiB   0.11%     480kB / 1.14MB   4.1kB / 168kB     17
4155ed1d3cde   clab-frr01-router2                       0.30%     17.07MiB / 15.29GiB   0.11%     469kB / 1.11MB   0B / 160kB        17
f1541e0f9a06   clab-frr01-PC1                           0.09%     13.38MiB / 15.29GiB   0.09%     587MB / 1.13MB   139kB / 69.6kB    15
f75c1930d1e5   clab-frr01-PC3                           0.06%     12.72MiB / 15.29GiB   0.08%     490kB / 197MB    209kB / 69.6kB    14
5c10a64d718d   clab-frr01-PC2                           0.11%     13.42MiB / 15.29GiB   0.09%     473kB / 392MB    0B / 73.7kB       15
35b052a9d407   zabbix-docker-zabbix-server-1            0.39%     66.7MiB / 1GiB        6.51%     976MB / 52.3MB   9.83MB / 16.4kB   84
ff4d059fc199   zabbix-docker-zabbix-web-nginx-mysql-1   18.69%    255.7MiB / 512MiB     49.93%    248MB / 178MB    26MB / 28.7kB     22
2e207fec6db8   zabbix-docker-mysql-server-1             3.43%     716.9MiB / 15.29GiB   4.58%     160MB / 1.2GB    104MB / 3.55GB    71
```

## CPU stats reported by Zabbix using SNMP v2 and CPU stats reported directly by Docker

The discrepancy between CPU stats reported by Zabbix using SNMP v2 and CPU stats reported directly by Docker is a common issue due to differences in how these metrics are collected and interpreted:

### Reasons for difference:

1. **Different data sources and granularity:**
   - Zabbix via SNMP queries system-level CPU OIDs (e.g., from devices or hosts) which represent overall CPU usage or per-core metrics according to SNMP MIBs.
   - Docker reports CPU usage from cgroups and container runtime info, reflecting container-specific CPU utilization.
   - SNMP CPU values reflect host or device perspective; Docker stats reflect container resource usage.

2. **SNMP v2 MIB limitations:**
   - SNMP v2 CPU usage counters may have different update intervals or calculation methods than Docker's real-time CPU usage.
   - SNMP polling intervals and aggregation can cause delays and lower resolution in CPU usage reports.
  
3. **Containers abstract CPU use:**
   - Docker containers share the host kernel; their CPU stats come from cgroups and namespaces.
   - From SNMP perspective (host level), CPU might seem underutilized while a container process is actively using CPU time.
   - SNMP metrics are usually for the whole host, not containerized environments unless specific container SNMP agents or extensions are used.

4. **Monitoring docker via Zabbix native Docker plugins or agent inside container:**
   - Using Zabbix agent (or Zabbix agent 2 docker plugin) inside or on the host to monitor Docker metrics provides more accurate container CPU stats.
   - SNMP is better suited for physical devices, network gear, and non-containerized hosts.

### Recommendations:

- Use Zabbix Docker monitoring templates/plugins designed to collect container CPU and resource stats directly from the Docker engine or with the Zabbix agent.
- Supplement SNMP host-level CPU monitoring with Docker-specific metrics to get a full picture.
- Ensure polling frequency and timeout settings are configured to minimize delays or stale data.

### Useful resource:

- Zabbix Docker monitoring documentation explains how to monitor Docker engines and containers using native methods rather than SNMP.[1][2][9]

This explains why CPU statistics don't align exactly and how to improve monitoring accuracy for Docker container CPU usage in Zabbix.

[1](https://www.youtube.com/watch?v=QNdsWp_X9-c)
[2](https://www.zabbix.com/documentation/current/en/manual/config/items/itemtypes/snmp)
[3](https://www.reddit.com/r/zabbix/comments/103e5o5/zabbix_as_container_vs_vm/)
[4](https://www.zabbix.com/documentation/current/en/manual/discovery/low_level_discovery/examples/cpu)
[5](https://www.zabbix.com/documentation/current/en/manual/appendix/config/zabbix_agent2_plugins/d_plugin)
[6](https://www.reddit.com/r/zabbix/comments/1inogbi/zabbix_on_ubuntu_server_or_docker/)
[7](https://wiki.teltonika-networks.com/index.php?diff=109857&mobileaction=toggle_view_desktop)
[8](https://www.zabbix.com/integrations/snmp)
[9](https://www.zabbix.com/integrations/docker)
[10](https://blog.devops.dev/dockerizing-monitoring-tools-b2744e9b5f98)
