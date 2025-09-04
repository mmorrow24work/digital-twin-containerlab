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
 
## 2025/09/03

* Start day 07.00
* Had a re-think ! Instead of creating custom images for Zabbix and including the Zabbix container in my containerlab network - switch to the standard docker containers and attach them to my containerlab networks
* [Stop Using Docker. Use Open Source Instead](https://www.youtube.com/watch?v=Z5uBcczJxUY&t) - advises us to use Podman ( opensource alternative to Docker ) instead of Docker Compose ( which apparently not free for commercial use )
* [Zabbix Installation from containers](https://www.zabbix.com/documentation/current/en/manual/installation/containers) - shows us how to use Docker Compose or Podman ( opensource alternative to Docker )
* I did some tests with docker compose or podman compose but I gave up on podman because it didn't work first time - see [NOTES](https://github.com/mmorrow24work/digital-twin-containerlab/blob/main/NOTES.md)
