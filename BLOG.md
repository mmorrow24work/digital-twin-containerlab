I'm not sure how best to blog yet - the recommended options are :

1. Start simple with README for essentials
2. Use Wiki if you want quick multipage docs/blog with minimal setup - I found that to use the Wiki feature on a private repo needs GitHub PRO ( Note : 2025/09/03 )
3. For professional blogging, invest in GitHub Pages with Jekyll/Hugo.
4. Keep blog and docs content in source control to track history.
5. Link blog prominently from README and Wiki for ease of discovery.
  
# 2025/09/02

* After spending several weeks using Kathara I switched over to Containerlab for the following reasons:
- Access to a wide range on containers and VM's from Nokia that will allow us to core and edge of NRTS2 / NRTS3 network
- Better documentation, ongoing support from Nokia and other vendors
- More features
- Note: The containerized Service Router Simulator, known as SR-SIM, is a cloud-native version of the SR OS software that runs on hardware platforms. The image can be downloaded from the [Nokia Support Portal](https://customer.nokia.com/support/s/) and requires an active SR-SIM license to operate. I have requested this from Nokia [SROS vSIM license from Nokia - uuidgen email](https://github.com/mmorrow24work/digital-twin-containerlab/issues/1)
* I worked on creating a custom image to [create FRR image with SNMP and AgentX protocol support](https://github.com/mmorrow24work/digital-twin-containerlab/blob/main/frr-snmp.md)

# 2025/09/03

* Start day 09.00
* Started using the [issues](https://github.com/mmorrow24work/digital-twin-containerlab/issues) log in github to track progress and capture requirements.
* Started this blog and exploring github best practices
* Had a tidy up of this repo to create subfolders for my docker images - which I have previously created using multiple repos for ... having everything under one seems to make more sense
* Worked on getting SNMP traps to work in Zabbix - see [NOTES](https://github.com/mmorrow24work/digital-twin-containerlab/blob/main/NOTES.md)
* Worked on getting SQL backup and restore to work in Zabbix - see [NOTES](https://github.com/mmorrow24work/digital-twin-containerlab/blob/main/NOTES.md)
* End day 22.00
 
# 2025/09/04

* Start day 07.00
* Had a re-think ! Instead of creating custom images for Zabbix and including the Zabbix container in my containerlab network - I switched to the standard docker containers and attached them to my containerlab networks
* [Stop Using Docker. Use Open Source Instead](https://www.youtube.com/watch?v=Z5uBcczJxUY&t) - advises us to use Podman ( opensource alternative to Docker ) instead of Docker Compose ( which apparently not free for commercial use )
* [Zabbix Installation from containers](https://www.zabbix.com/documentation/current/en/manual/installation/containers) - shows us how to use Docker Compose or Podman ( opensource alternative to Docker )
* I did some tests with docker compose or podman compose but I gave up on podman because it didn't work first time - see [NOTES](https://github.com/mmorrow24work/digital-twin-containerlab/blob/main/NOTES.md)
* Worked on merging Github repo's - still not sure what the best approach is
* After lots of trial and error... switching to the standard docker containers is definately the best way forward for several reasons
- Images are updated and maintained by Zabbix - not by us !
- Zabbix containers are independant from the Containerlab containers, which has several benefits inc. not having to backup and restore the SQL database eveytime we stop / start the Containerlab network
* Worked on adding SNMP and Zabbix Agent support to the container images I'm using with Containerlab - got both working, and then managed to break them both so I will need to back track and fix both
* Eventually managed to get SNMP traps working using Zabbix container deployment ... well, kind of - they are not dhowing up in the UI - but I do see them in the logs - see [docker-compose/README](https://github.com/mmorrow24work/digital-twin-containerlab/blob/main/docker-compose/README.md)
* End day 00.00

# 2025/09/05

* Start day 08.45
* First job is to fix my Alpine_PC and FRR containers to get SNMP and Zabbix Agent support working again
* Prep for call with Steve & Paul at 13.00 - my actions from last from last week were to focus on these 4 requirements:
1. Simulate sending / receiving SNMP traps using Actelis MIB IOD's - but also generic link up / down SNMP traps
2. Look at how we can automate bulk software upgrades - e.g. using Ansible, Event-Driven Ansible (EDA) using webhooks ???
3. Look for ways to simulate L1 outages / cable cuts so we don't have to down an router / switch / camera network interface
4. Work with Containerlab to manage Nokia SR-OS and SR-LINUX nodes
* 
