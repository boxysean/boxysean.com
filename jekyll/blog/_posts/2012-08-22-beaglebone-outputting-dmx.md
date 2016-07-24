---
layout: blog-item
title: BeagleBone outputting DMX
show: True
---

Last weekend [I started playing with the BeagleBone PRU](http://blog.boxysean.com/2012/08/12/first-steps-with-the-beaglebone-pru/) and ended my post by saying that my goal with this powerful chip was to make the BeagleBone bitbang the DMX protocol.

Well it's been 10 days or so and I've done it! Here is a quick video to show the setup in action.

<iframe width="640" height="360" src="http://www.youtube.com/embed/Gl-g03SivUs?feature=player_detailpage" frameborder="0"></iframe>

I'm off to Europe for the next month to participate in [Interactivos?](http://medialab-prado.es/article/interactivos12_liubliana_tecnologias_obsoletas_del_futuro). After I'm back I'll package and release the code so I'm not the only one with these powers. I'll be using this code for my light installation with [Reid](http://www.reidbingham.com) at Detroit's [DLECTRICITY](http://www.dlectricity.com/) light festival.

[dantheman](https://twitter.com/thedantheman) suggested what I'm doing is a little overkill. He thinks future implementations should use serial libraries and system interrupts instead of dedicating a co-processor to bitbang DMX, [like this Arduino implementation](http://arduino.cc/playground/Learning/DMXSerial). This could be the right approach to Raspberry Pi users who want to output DMX.
