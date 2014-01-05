---
layout: blog-item
title: "Internet on Governors Island"
show: True
---

I'm working with [CJ](http://www.seej.net]) to put up a WiFi network on Governors Island for the [FIGMENT Interactive Sculpture Garden](http://newyork.figmentproject.org/long-term-exhibitions/2012-interactivesculpture-garden/). Two of the sculptures, including his called [BucketCraft](http://www.bucketcraft.org/) are using network cameras to enhance interactivity.

![Governors Island]({{ site.url }}/media/images/govs-island.png)

We decided to go with [Clear](http://www.clear.net) as our wireless service provider and picked up one of their WIXFBR-117 models. I've used Verizon for wireless Internet before and used their "month-to-month" service, but ended up paying cancellation fees and so on. Clear is by far the most consumer-friendly cell-network Internet provided in NYC!

Our Clear plan provides 1.5 Mbps down and 0.5 Mbps up plan. There are supposed to be 4 or 5 video streams coming from the sculptures and that much data may push the limits of the upload speed. We'll see!

The signal range of the WIXFBR-117 is about 30' outdoors, but we wanted to cover roughly 200'. I brought a [Ubiquity NanoStation M2](http://www.ubnt.com/nanostation), which plugged directly into the WIXFBR-117 uplink and provided a second hotspot with Internet. We had some issues setting up the NanoStation, you can [read out installation steps below](#nanostation). The range of the NanoStation is far superior, and easily reaches the far end of the park.

![Governors Island Sculpture Garden area]({{ site.url }}/media/images/govs-island-wifi-area.png)

CJ's project uses one network camera to stream video to the Internet. We wanted to make it accessible from the Internet, so we signed up for a free [DynDNS pro](http://www.dyndns.com) account so that the Governors Island network had a reachable place on the Internet. On the WIXFBR-117, we added the DynDNS credentials to the dynamic DNS menu, disabled the firewall, and set up port forwarding on the WIXFBR-117 so that any communication to the camera's web interface port is redirected to the camera.

![Tree house]({{ site.url }}/media/images/govs-island-tree-house.jpg)

Next steps are to set up a solar panel, which will power CJ's network camera, and a DIY power-monitoring device so we can keep tabs on how well it performs over the summer (and in case there are any issues!).


<a name="nanostation"></a>Setting up the NanoStation M2
-----------------------------

It was nontrivial to set up the NanoStation M2 after resetting it, so here are instructions on how we got it up and running using an OS X 10.5 MacBook Pro (but the commands should work on any Unix-based system).

Gaining access to the web interface
===================================

* Power up your NanoStation.
* Plug an Ethernet cable between your computer and the LAN port of the NanoStation PoE injector box.
* The default NanoStation IP is 192.168.1.20. Your computer needs to understand that this IP address is reachable, so we must add a static route.
* Run this command `sudo ifconfig eth0 192.168.1.21 netmask 255.255.255.0` (`eth0` is your Ethernet interface -- replace `eth0` if yours is something else).

This should be enough to populate the routing table. You can verify by running `netstat -rn`. Here's what my output looked like.

    $ netstat -rn
    Kernel IP routing table
    Destination     Gateway         Genmask         Flags   MSS Window  irtt Iface
    10.0.0.0        0.0.0.0         255.255.255.0   U         0 0          0 eth1
    192.168.1.0     192.168.1.20    255.255.255.0   UG        0 0          0 eth0
    192.168.1.0     0.0.0.0         255.255.255.0   U         0 0          0 eth0
    169.254.0.0     0.0.0.0         255.255.0.0     U         0 0          0 eth1
    0.0.0.0         10.0.0.1        0.0.0.0         UG        0 0          0 eth1

The important line is the destination network 192.168.1.0 with gateway 192.168.1.20 on interface `eth0`.

If that line isn't there, try running this command to add it manually.

    sudo route add -net 192.168.1.0 netmask 255.255.255.0 gw 192.168.1.20

Now you should be able to access the router via your browser, go ahead and navigate to 192.168.1.20.

Setting the device to be an access point
========================================

When making the NanoStation an access point (think normal wireless consumer router), there were a couple of settings I had to change that don't entirely make sense to me.

- Set up the device as an access point by changing settings in the Wireless menu.
- Still within the Wireless menu, change the Channel Width from 40MHz to 20MHz.
- Select the left-most menu that is an icon. By default the AirMAX setting is enabled. Disable this.

Thanks to [Jonathan Baldwin](http://www.jrbaldwin.com/) for helping me troubleshoot the NanoStation!
