This project remains work in progress so it will be updated on a regular basis.

The initial project scope is to build a digital twin environment with a focus on the core and edge of NRTS2 / NRTS3 network which can be discovered and managed by a generic SNMP manager.

I started off using Kathara but now I’ve moved on to Containerlab – which is a Nokia sponsored open-source project - it's like Kathara but way better – so I expect Containerlab will be our digital twin environment of choice going forward.

At the same time I am also learning how to use GitHub, Docker, AI, and Azure.

I'm using [ISSUES](https://github.com/mmorrow24work/digital-twin-containerlab/issues) to track progress and capture requirements.

I'm using this [README](https://github.com/mmorrow24work/digital-twin-containerlab/blob/main/README.md) as a blog for now. 

I'm not sure how best to to that yet - the recommended options are :

1. Start simple with README for essentials.
1. Use Wiki if you want quick multipage docs/blog with minimal setup - To use the Wiki feature on a private repo needs GitHub PRO ( Note : 2025/09/03 ) 
1. For professional blogging, invest in GitHub Pages with Jekyll/Hugo.
1. Keep blog and docs content in source control to track history.
1. Link blog prominently from README and Wiki for ease of discovery.

I will be using AI as much as possible to accelerate things - here's an example of my interactions with [claude.ai](https://claude.ai/) - see [frr-snmp README](https://github.com/mmorrow24work/digital-twin-containerlab/blob/main/docker_custom_image/frr-snmp/readme.md)

For the record - here are some links to various resources, I will be using and referring to going forward...

* [FRRouting github](https://github.com/FRRouting)
* [Containerlab github](https://github.com/srl-labs/containerlab)
* [Containerlab-io-draw github](https://github.com/srl-labs/clab-io-draw)
* [Nokia SR Linux Streaming Telemetry Lab](https://github.com/srl-labs/srl-telemetry-lab)
* [KatharaFramework github](https://github.com/KatharaFramework)

* [Containerlab](https://containerlab.dev)
* [Docker](https://docs.docker.com/)
* [Kathara homepage](https://www.kathara.org/)
* [Nokia SR Linux - YANG models](https://yang.srlinux.dev)
* [Nokia SR Linux - DEV](https://srlinux.dev)

## Blog - 2025/09/02

* After spending several weeks using Kathara I switched over to Containerlab for the following reasons:

1. access to a wide range on containers and VM's from Nokia that will allow us to core and edge of NRTS2 / NRTS3 network
1. better documentation, ongoing support from Nokia and other vendors
1. more features

Note: The containerized Service Router Simulator, known as SR-SIM, is a cloud-native version of the SR OS software that runs on hardware platforms. The image can be downloaded from the [Nokia Support Portal](https://customer.nokia.com/support/s/) and requires an active SR-SIM license to operate. I have requested this from Nokia [SROS vSIM license from Nokia - uuidgen email](https://github.com/mmorrow24work/digital-twin-containerlab/issues/1)

* I worked on creating a custom image to [create FRR image with SNMP and AgentX protocol support](https://github.com/mmorrow24work/digital-twin-containerlab/blob/main/frr-snmp.md)

## Blog - 2025/09/03

* Started using the [issues](https://github.com/mmorrow24work/digital-twin-containerlab/issues) log in github to track progress and capture requirements.
* Started this blog and exploring github best practices
* Had a tidy up of this repo to create subfolders for my docker images - which I have previously created using multiple repos for ... having everything under one seems to make more sense 
