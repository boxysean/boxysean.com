---
layout: blog-item
title: Fluxtime Photobooth
show: True
---

Last year, Reid and I set up [a photobooth](http://www.flickr.com/photos/rainbroz/sets/72157632306602848/) at the Flux Factory 2013 Benefit using our [Rainbow Machine technology](http://www.therainbowmachine.com/). This year, [Jason](http://jasoneppink.com/), [Reid](http://reidbingham.com/), and I made a photobooth for the [2014 edition of the event](http://www.fluxfactory.org/events/2014-benefit/) that built on the idea we started playing with [last month]({{ site.url }}/blog/2014/01/05/raspi-photography-controller/). [Flux Factory](http://www.fluxfactory.org/) is such a great organization, it was an honor participate yet again.

*The animated GIFs were made using three Rebel T3i cameras automated with Raspberry Pis to take and stitch the stills together in less than 10 seconds.* Below I've outlined how that was done below, but first here are some of my favorite images from the night!

![gif]({{ site.url }}/media/images/fluxtime-photobooth/gif_1389831874.gif)

![gif]({{ site.url }}/media/images/fluxtime-photobooth/gif_1389836828.gif)

![gif]({{ site.url }}/media/images/fluxtime-photobooth/gif_1389838773.gif)

![gif]({{ site.url }}/media/images/fluxtime-photobooth/gif_1389840442.gif)

![gif]({{ site.url }}/media/images/fluxtime-photobooth/gif_1389839576.gif)

The Setup and Code
------------------

Each camera was tethered to a Raspberry Pi running a simple [Flask](http://flask.pocoo.org/) web server. I exposed two routes in the web server: `preview`, which simply returns the digital view finder image of the camera; and `snap`, which invokes the shutter and returns the image from the camera.

To control the cameras this way, I used [libgphoto2](http://www.gphoto.org/) bindings exposed in python by [piggyphoto](https://github.com/alexdu/piggyphoto). It is remarkably simple to control the Canon T3i's that Reid provided.

{% highlight python %}

from flask import Flask, send_file
import piggyphoto
app = Flask(__name__)

image = 'photo.jpg'

@app.route("/preview")
def preview():
    C.capture_preview(image)
    return send_file(image)

@app.route("/snap")
def snap():
    C.capture_image(image)
    return send_file(image)

if __name__ == "__main__":
    C = piggyphoto.camera()
    C.leave_locked()
    C.capture_preview(image)
    app.run(host='0.0.0.0')

{% endhighlight %}

I made the Raspberry Pis run the Flask webserver [on boot using crontab](http://www.cyberciti.biz/faq/linux-execute-cron-job-after-system-reboot/), which made it easy to reset the software if ever there was an issue.

Each Raspberry Pi was connected to a wifi router so they were on the same LAN. The master computer that the photographer used to take the photo was wirelessly connected to the same LAN.

<img title="Reid, photographer" src="{{ site.url }}/media/images/fluxtime-photobooth/DSC04865.JPG" style="float: left; padding-right: 20px" />

<img title="camera and pi" src="{{ site.url }}/media/images/fluxtime-photobooth/DSC04864.JPG" style="clear: left" />

<div style="text-align: center; font-style: italic"><p>Setup photos courtesy of <a href="http://nicknormal.com/">Nick Normal</a>, #smudgefilter</p></div>

To take a photo, a simple bash script was run to curl each camera (more-or-less simultaneously, room for improvement possible -- but [not sure if it's worth it](http://xkcd.com/1319/)), convert the images to GIFs, and make an animated GIF using [gifsicle](http://www.lcdf.org/gifsicle/). I ran this script on an Apple laptop running OS X 10.9.

{% highlight bash %}

#!/bin/bash

# Define all the variables in advance
RASPBERRY_PI_1=192.168.77.200
RASPBERRY_PI_2=192.168.77.146
RASPBERRY_PI_3=192.168.77.230

TIME=$(date +%s)

RPI_IMAGE_1=stills/image_${TIME}_1.jpg
RPI_IMAGE_2=stills/image_${TIME}_2.jpg
RPI_IMAGE_3=stills/image_${TIME}_3.jpg

RPI_GIF_1=stills/image_${TIME}_1.gif
RPI_GIF_2=stills/image_${TIME}_2.gif
RPI_GIF_3=stills/image_${TIME}_3.gif

OUTPUT=gifs/gif_$TIME.gif

# Grab the images "concurrently"
curl -o $RPI_IMAGE_1 http://$RASPBERRY_PI_1:5000/snap &
curl -o $RPI_IMAGE_2 http://$RASPBERRY_PI_2:5000/snap &
curl -o $RPI_IMAGE_3 http://$RASPBERRY_PI_3:5000/snap &

# Wait the time it takes to transmit the images
echo "developing..."
sleep 4

# Convert the JPGs to GIFs for gifsicle
sips -Z 1024 -s format gif $RPI_IMAGE_1 --out $RPI_GIF_1
sips -Z 1024 -s format gif $RPI_IMAGE_2 --out $RPI_GIF_2
sips -Z 1024 -s format gif $RPI_IMAGE_3 --out $RPI_GIF_3

# Stitch together the GIFs to make them animated
gifsicle --delay=24 --loop $RPI_GIF_1 --delay=12 $RPI_GIF_2 --delay=24 $RPI_GIF_3 --delay=12 $RPI_GIF_2 > $OUTPUT

echo $OUTPUT

{% endhighlight %}

The animated GIF result was sent over to a viewing computer using `scp` that ran a PHP gallery script Jason hacked together, so that within 10 seconds the animated GIF photo result was viewable. This quick turnaround time is crucial for keeping your customers happy!

That's it! Sounds easy, but there was a lot of moving parts in play to make this work. Each Raspberry Pi has three cables coming out of it (Ethernet, power, and USB) and we used two power strips worth of plugs to keep everything running. At one point a Raspberry Pi stopped booting, but I was lucky enough to have an extra SD card with a freshly flashed version of Raspbian on it, phew!

The lighting, backdrop, and focal point of the shots were well-considered. The balloons were a great addition from Jason to have something fun for the participants to do while having their photo taken. During operation, the batteries in cameras needed to be swapped and camera settings needed to be tuned to get great results.

Having a good team to work with was probably the most key feature of making this photobooth succesful!

Below are some more of my favourite photos from the evening. The entire set can be found [here](https://www.dropbox.com/sh/gd9wa55jg7ae9hb/NcDWyqJb_4).

More Photos
-----------

![gif]({{ site.url }}/media/images/fluxtime-photobooth/gif_1389830400.gif)

![gif]({{ site.url }}/media/images/fluxtime-photobooth/gif_1389831081.gif)

![gif]({{ site.url }}/media/images/fluxtime-photobooth/gif_1389832786.gif)

![gif]({{ site.url }}/media/images/fluxtime-photobooth/gif_1389834439.gif)

![gif]({{ site.url }}/media/images/fluxtime-photobooth/gif_1389836108.gif)

![gif]({{ site.url }}/media/images/fluxtime-photobooth/gif_1389836376.gif)

![gif]({{ site.url }}/media/images/fluxtime-photobooth/gif_1389838147.gif)

![gif]({{ site.url }}/media/images/fluxtime-photobooth/gif_1389838842.gif)

![gif]({{ site.url }}/media/images/fluxtime-photobooth/gif_1389839308.gif)

![gif]({{ site.url }}/media/images/fluxtime-photobooth/gif_1389839396.gif)

![gif]({{ site.url }}/media/images/fluxtime-photobooth/gif_1389839496.gif)

![gif]({{ site.url }}/media/images/fluxtime-photobooth/gif_1389839986.gif)

![gif]({{ site.url }}/media/images/fluxtime-photobooth/gif_1389840198.gif)

![gif]({{ site.url }}/media/images/fluxtime-photobooth/gif_1389840288.gif)

![gif]({{ site.url }}/media/images/fluxtime-photobooth/gif_1389840965.gif)

![gif]({{ site.url }}/media/images/fluxtime-photobooth/gif_1389841126.gif)

![gif]({{ site.url }}/media/images/fluxtime-photobooth/gif_1389841463.gif)

![gif]({{ site.url }}/media/images/fluxtime-photobooth/gif_1389841710.gif)

![gif]({{ site.url }}/media/images/fluxtime-photobooth/gif_1389842145.gif)

![gif]({{ site.url }}/media/images/fluxtime-photobooth/gif_1389842282.gif)

![gif]({{ site.url }}/media/images/fluxtime-photobooth/gif_1389843179.gif)