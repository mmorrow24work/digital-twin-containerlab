# Let's install the essentials 

These instructions are the same for various hosting environments including ...

- Bare metal - I have a dual boot PC running Ubuntu desktop
- Cloud hosted VM - Google, AWS, Azure etc.
- Locally hosted VM - e.g. an Ubuntu VM running under Hyper-V
- WSL - i like this method, but I have had some issues with it - which might be my bad - or it could be the Telent PC build ( Cisco Umberella etc ) that's messing me up ???

# Clone github repo's

```bash
mickm@mickm-Latitude-7410:~/$ mkdir -p git
mickm@mickm-Latitude-7410:~/$ cd git
mickm@mickm-Latitude-7410:~/git$ git clone https://github.com/zabbix/zabbix-docker.git
mickm@mickm-Latitude-7410:~/git$ git clone https://github.com/srl-labs/containerlab.git
mickm@mickm-Latitude-7410:~/git$ git clone https://github.com/mmorrow24work/digital-twin-containerlab/
mickm@mickm-Latitude-7410:~/git$ ls -l
total 12
drwxrwxr-x 27 mickm mickm 4096 Sep  4 11:19 containerlab
drwxrwxr-x  4 mickm mickm 4096 Sep  4 11:18 digital-twin-containerlab
drwxrwxr-x  9 mickm mickm 4096 Sep  4 11:45 zabbix-docker
mickm@mickm-Latitude-7410:~/git$
```
