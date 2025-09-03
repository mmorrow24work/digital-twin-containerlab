# NOTES

## 

```
root@PC2:/# mysqldump -u zabbix -p --single-transaction --quick --lock-tables=false zabbix | gunzip > /home/zabbix_backup.sql.gz
root@PC2:/# service zabbix-server stop
 * Stopping Zabbix server zabbix_server                                                                              [ OK ]
root@PC2:/# gunzip < /home/zabbix_backup.sql.gz | mysql -u zabbix -p zabbix
root@PC2:/# service zabbix-server start
```
