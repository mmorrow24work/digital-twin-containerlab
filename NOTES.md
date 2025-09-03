# NOTES

## SQL backup in Zabbix

``` bash
root@PC2:/# mysqldump -u zabbix -p --single-transaction --quick --lock-tables=false zabbix | gunzip > /home/zabbix_backup.sql.gz
root@PC2:/# ls -lh /home
total 28M
-rw-r--r-- 1 ubuntu 1001  24M Sep  3 20:27 2_zabbix_backup.sql
-rw-r--r-- 1 ubuntu 1001 4.2M Sep  3 20:24 zabbix_backup.sql.gz
root@PC2:/#
```
## SQL restore in Zabbix
``` bash
root@PC2:/# service zabbix-server stop
 * Stopping Zabbix server zabbix_server                                                                              [ OK ]
root@PC2:/# gunzip < /home/zabbix_backup.sql.gz | mysql -u zabbix -p zabbix
root@PC2:/# service zabbix-server start
root@PC2:/#
```
## SQL restore in Zabbix
``` yml

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
