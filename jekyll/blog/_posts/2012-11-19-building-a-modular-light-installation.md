---
layout: blog-item
title: Building a Modular Light Installation
show: True
---

[Reid](http://www.reidbingham.com) and I built [our largest light installation yet](http://doubleonedesign.com/public-constructions.html) last month called Public Constructions. *I want to explain a few early design decisions that made the project a huge success for us.*

Reid is always talking about how he can modularize his life -- he is especially proud of his stackable milk crate shelves at our work studio and his bedframe at home made from pipes ([via Lady Ada](http://www.instructables.com/id/ECJONI2CSCEP2863F3/)). His influence made us collectively think about all the ways the project could be modularized, and, in the end, *designing for modularity is what made the project work*.

Modular decision #1: Breaking it down
-------------------------------------

This is the biggest installation we've ever made. Spanning 30 feet across and weighing over 600 lbs, Public Constructions had to fit in the cargo van we rented and be driven from our studio in Brooklyn to [DLECTRICITY](http://www.dlectricity.com/) in Detroit. Everything -- the frame, the ballast, the flower stems, the lights, the cabling -- was designed to break down and disconnect from each other. Reid even used parts of the sculpture frame (2x4s) to create a false floor in the van to ease the packing process.

![Packing the van]({{ site.url }}/media/images/public-constructions/packing-the-van.jpg)

Modular decision #2: Visualizing the installation
-------------------------------------------------

As with most art projects I've worked on, Public Constructions came together in the last few moments and never really had a full run-through before it was installed. That didn't really worry us, however, because I designed a 3D sketch of the installation written in OpenFrameworks that talks with the light sequencer the same way the sequencer talks with the installation software. (UDP client-server decoupling.) This allowed us to see what the installation looked like in advance and gave us confidence in our setup.

![animation of 3D sketch]({{ site.url }}/media/images/public-constructions/ofx-model.gif)

Modular decision #3: Reliablity and control
-------------------------------------------

As I was researching how to design a custom lighting system that kept us within budget, I realized I could make a BeagleBone sequence the whole installation by talking [DMX](http://en.wikipedia.org/wiki/DMX512) with tried-and-tested, high-amperage, opto-isolated [DMX LED light controllers](http://www.celestialaudio.com/ca_dmx_32_V2_nfet/index.html). The DMX interface in the BeagleBone was coded in assembly language, but living in assembly is no fun at all. I found a way to sequence the light values in python and pass them to the assembly code ([see here](http://blog.boxysean.com/2012/08/12/first-steps-with-the-beaglebone-pru/)). Choosing highly reliable software and electronics systems and making them work together resulted in an effortless system that never failed.

[![system diagram]({{ site.url }}/media/images/public-constructions/system-diagram-800.jpg)]({{ site.url }}/media/images/public-constructions/system-diagram.jpg)

Keep it modular
---------------

The way Reid and I work is modular. We've worked together long enough to know how to plug in our individual abilities to design and create the whole installation. In some ways, we are able to replace each other when the other is busy with another task. I foresee a lot of modularity in my future work with him. Modular4LYFE.

![Night flower]({{ site.url }}/media/images/public-constructions/night-flower.jpg)

