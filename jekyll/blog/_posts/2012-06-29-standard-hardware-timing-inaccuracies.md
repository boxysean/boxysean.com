---
layout: blog-item
title: Standard hardware timing inaccuracies
show: True
---

Don't bother trying to find the difference of two events occurring on standard computer hardware if you are looking for sub-microsecond precision.

I learned this today after putting two of my WNDR3700v2 routers running OpenWRT into [monitor mode](http://www.aircrack-ng.org/doku.php?id=airmon-ng) to look at the packets floating in the air around me. My goal was to triangulate the origin of the packets.

I managed to measure the arrival time of a packet on the router down to the microsecond. Unfortunately, the processors report times accurate up to about 1 ms. Light can travel 300 km in 1 ms, so there's no real chance that I'll be able to pinpoint where a signal originates using this method!

I'm not the first person to realize that timing is inaccurate without dedicated hardware keeping track of time. See [this thread](https://forum.openwrt.org/viewtopic.php?id=21965).

![Jitter plot]({{ site.url }}/media/images/banff-jitter-plot.png)

The above graph plots the delta in microseconds (Y-axis) between many packet receive times (X-axis) on two separate routers. The bulk of the packets are between -7000 and -8000, with a few outliers. I used libpcap and gettimeofday() to measure this, comparing hashes of packet payloads to check if the packets are the same.
