---
layout: blog-item
title: My LAN has a Clock Tower
show: True
---

<i>This post is part of a continuing series of posts for my masters thesis project, Brooklyn Net, a wireless rooftop network that aims to connect artists and neighbors without using the Internet. The [last post](http://blog.boxysean.com/2013/02/18/rooftop-tour-of-brooklyn/) discussed possible rooftops for the network. This post discusses the technical network details.</i>

Last week, my friend Glen helped me directly connect my home in Brooklyn with a clock tower in Queens using WiFi. The link was the result of about a month of work and a few failed attempts.  Not only was this good practice for me, but we also now have remote connectivity to the IP camera we placed in the clock tower to observe [CJ's installation](http://www.seej.net/create/2012/12/12/locost-queue/) in the clock tower to see if it needs repairs.

![clock tower setup]({{ site.url }}/media/images/clocktower-lan/web/Scan1024.jpg)

Clock tower network technical setup
-----------------------------------

We used two NanoStation M2s running the default [AirOS firmware](http://www.ubnt.com/airos) with connected to each other in bridge mode. Working with the bridged NanoStations was analogous to my experience working with [ZigBees](http://en.wikipedia.org/wiki/ZigBee), which added transparent wireless links to digital circuits, passing electrical signals through as though both ends were physically connected.

Behind the scenes, a virtual network interface is created on the NanoStation that links the LAN and WLAN (wireless LAN) physical interfaces. The protocols that run on the network, such as the [Address Resolution Protocol](http://en.wikipedia.org/wiki/Address_Resolution_Protocol), have their discovery packets forwarded and emulated by the NanoStations on either end, acting as transparent middlemen if the destination happens to be on the other side of the network.

We reduced the frequency of the 802.11 signal from 20 MHz to 5 MHz, lowering maximum link throughput (less oscillations mean fewer encoded bits) but boosting the signal to ensure that data travels reliably (same amount of energy powering the radio, so higher amplitude for the signal).

Bridging the clock tower LAN with my home LAN meant that two DHCP (Dynamic Host Configuration Protocol) servers were running on the shared LAN. DHCP servers provide IP addresses to devices connecting to the LAN, and typically each LAN has only one. Our fix for the colliding DHCP service was to block DHCP messages from crossing the wireless link using a firewall and to give each DHCP server different address ranges to ensure they do not assign the same IP to two devices.

One snag we had with the setup was the PoE injector for the NanoStation M2. It turns out that [Ubiquiti](http://ubnt.com/) has a variety of PoE injectors that all look the same, but with different output voltages for different pieces of hardware.

Brooklyn Net topology
---------------------

Completing the clock tower link got me thinking about the implementation details of Brooklyn Net. Bridging LANs is a simple application of wireless technology, now I need to think deeper, about precisely how the locations of Brooklyn Net will talk with each other; what equipment they need and what protocols they will run.

![internet]({{ site.url }}/media/images/clocktower-lan/web/current_internet.gif)

<i>A visual interpretation of the Internet ([source](http://cheswick.com/ches/map/))</i>

The topology of the Internet topology is something like a hierarchical tree structure of nodes (e.g., computers and network equipment). This structure scales well because the average number of hops packets needed to travel in order to reach their destination is reduced by having a edge nodes (e.g., your home Internet connection) reasonably close to the highly connected nodes of the backbone at the top of the tree.

![internet]({{ site.url }}/media/images/clocktower-lan/web/mesh.gif)

In contrast, networks with a mesh topology are non-hierarchical and connected without an explicit child-parent relationship. Packets on the network are passed from node to node to reach their destination, and mesh protocols are constantly trying to determine the best path between nodes behind the scenes. A positive side-effect of this is mesh networks are "self-healing", meaning that if a node disappears from the network, packets relayed on that node will be dynamically given a new route around the missing node. Or, if a new node is added, it will automatically be discovered.

In theory, no node in a random mesh deployment is any more important than any other node, but in reality that is not the case. There will be a number of very important nodes in Brooklyn Net: those that are geographically central and those that are highly connected to other nodes. In the beginning, each node in the network will be important, but, in the future, creating redundant links in the network will be important for network resiliency.

Present day mesh network technology is fairly advanced. Physically deploying a mesh network is easy for a technical end user: buy a few consumer routers, load them with mesh firmware, and place them in places close enough for their wireless signals to overlap. The routers are then mesh peers and computers on each of the routers can connect to each other over the mesh.

It's important to think about what Brooklyn Net could become. If it were to grow outside of Brooklyn, then it would be a "last mile" subnetwork of a larger network, like the Internet. A couple of network nodes on Brooklyn Net will be gateways to the larger infrastructure, funneling network traffic from and to terminating nodes in Brooklyn. The larger network must be hierarchical to scale effectively, ensuring less hops across longer distances. A disproportionate number of hops may happen within Brooklyn Net, but network speed shouldn't be too hampered.

Brooklyn Net will use a mesh network. I am going down the avenue of mesh networks despite the announcement of [DarkNetPlan](http://arstechnica.com/information-technology/2011/11/the-darknet-plan-netroots-activists-dream-of-global-mesh-network/) on Reddit last year and [the valuable criticism it received](http://sha.ddih.org/2011/11/26/why-wireless-mesh-networks-wont-save-us-from-censorship/). Mesh networks don't scale very well and tend to cause management headaches for network operators. The lesson from this article is that it's important to not commit to a particular network topology, but instead use the best choice for the occasion. The goal for the remainder of my thesis is to deploy Brooklyn Net rapidly and that is why choosing a mesh topology is appropriate for now.

Testing out a batman-adv mesh
-----------------------------

I've worked with the [Commotion](https://commotionwireless.net/) firmware which employs the OLSR mesh routing protocol. I was suggested to play with the [batman-adv](http://www.open-mesh.org/) protocol, which operates on layer 2 of [OSI model](http://en.wikipedia.org/wiki/OSI_model) and makes the whole network seem like a big network switch (with some magic under the hood). I've [played with batman-adv](http://www.boxysean.com/projects/mesh4lyfe.html) before and it was fun to revisit.

I set up a test network on my studio tables in a configuration similar to what I could imagine the first links in Brooklyn Net to be. I wanted to make sure that nodes on either end of the network could talk to each other through the middleman node.

[<img src="/images/clocktower-lan/web/P1010225.JPG" onmouseover="this.src='/images/clocktower-lan/web/P1010225-annotated.png'" onmouseout="this.src='/images/clocktower-lan/web/P1010225.JPG'" />]({{ site.url }}/media/images/rooftop/full/P1010225.JPG)

The black Netgear WNDR3700v2 routers acted as the WLAN providers that end users on Brooklyn Net will connect to, and the white NanoStation M2s acted as wireless network links that connect remote Brooklyn Net locations.

![internet]({{ site.url }}/media/images/clocktower-lan/web/dot1024.png)

Indeed, by setting up the [OpenWrt](https://openwrt.org/) firmware and [following batman-adv the instructions](http://www.open-mesh.org/projects/batman-adv/wiki/Quick-start-guide) on all the devices, the network was fully connected, as shown in the visual diagnostic tool.

Refocusing on the main goal
---------------------------

This week I dove deep into the network hardware and topology. Not only did I get hands-on experience with networks, I learned about cool features that could push the limits of the network infrastructure.

However, my thesis goal is to create applications for local networks. It's important for me to focus on creating a network infrastructure that is reliable and manageable without getting caught up in features that don't benefit applications.

My main focus is to get the network in the hands of the people. Once it's there, an honest conversation can begin about applications and end user experience.

![sean in the clocktower]({{ site.url }}/media/images/clocktower-lan/web/IMG_2923.JPG)

