---
layout: blog-item
title: Raspberry Pi as a Photography Controller
show: True
---

This past Sunday, [Jason](http://jasoneppink.com/), [Reid](http://reidbingham.com/) and I tested out a bullet-time animated GIF photobooth we are working on for a couple of upcoming parties. [Reid's work](http://www.nysci.org/) was having a holiday party so it was the perfect place to test out our idea on real people!

<img title="camera array" src="{{ site.url }}/media/images/bullet-time-photobooth/4cams.jpg" style="float: left; padding-right: 20px" />

<img title="camera and pi" src="{{ site.url }}/media/images/bullet-time-photobooth/cam-and-pi.jpg" style="clear: left" />

<div style="text-align: center; font-style: italic"><p>Our camera setup at the New York Hall of Science</p></div>

I'm interested in automating all aspects of the photobooth, from triggering the shutter to stitching together the images to displaying the final animated GIF to posting the GIF online. Adafruit has been sending me a lot of free Raspberry Pis at work because we've recently been placing some large orders, so I wanted to put them to good work as cheap photography controllers.

I'll release the code when it's cleaned up, but in short I used [libgphoto2](http://www.gphoto.org/), [Flask](http://flask.pocoo.org/), [gifsicle](http://www.lcdf.org/gifsicle/), and bash to stitch everything together.

Our design is inspired by other photobooths, such as the [Wobble Booth](http://thisisdk.com/protobooth/behind/) and the [Frozen Pi](http://www.raspberrypi.org/archives/5464) setup, but is extensible and cheap because it uses cameras we can borrow for temporary setups.

![Jason, Sean, and Reid]({{ site.url }}/media/images/bullet-time-photobooth/nyhs-jason_sean_reid.gif)


![Jason]({{ site.url }}/media/images/bullet-time-photobooth/nyhs-jason.gif)

![Reid]({{ site.url }}/media/images/bullet-time-photobooth/nyhs-reid.gif)

![Kickers]({{ site.url }}/media/images/bullet-time-photobooth/nyhs-kickers.gif)

![Sean]({{ site.url }}/media/images/bullet-time-photobooth/nyhs-sean.gif)

![Jumpers]({{ site.url }}/media/images/bullet-time-photobooth/nyhs-jumpers.gif)

