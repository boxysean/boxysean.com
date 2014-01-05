---
layout: blog-item
title: Stream a slideshow of images with VLC 1.1.x
show: True
---

A task I've found myself having to complete over and over again is streaming a slideshow of images over a LAN. Today, I've found yet another solution to do this using the VLC server.

The VLC approach
================

The basic idea of this is to host a streaming media server to send encoded video of the slideshow images to whomever requests it using their computer's media player.

The [VLC project](http://www.videolan.org/) includes a [handy streaming server](http://www.videolan.org/vlc/streaming.html) that makes this magic happen. (At first I researched [ffserver](http://ffmpeg.org/ffserver.html), but was pointed to VLC by [this post](http://www.goeszen.com/ffserver-guide#header).)

We use the VLC [fake module](http://wiki.videolan.org/Documentation:Modules/fake) to have the streaming server reload a specified image once a second and encode it into an H264 video stream.

This is the script I used to launch my VLC streaming server. `e.jpg` is my specified file.

		#!/bin/bash
		
		host=boxysean.com
		port=8090
		file=/home/boxysean/slideshow/e.jpg
		
		bitrate=1024
    
    # option --fake-fps will not work with value less than 4
		
		vlc -vv  --sout "#transcode{vcodec=h264,vb=$bitrate}:standard{access=http,mux=ts,dst=$host:$port}"  fake:// --fake-file=$file --fake-file-reload 1 --fake-fps 4 -I dummy

Instead of making `e.jpg` a real file, I made it a symlink that I'm constantly changing. The following script looks inside the present working directory and cycles `e.jpg` through all the images in the directory.

    #!/bin/bash
    
    while [[ 1 ]]; do
      for i in *.jpg; do
        ln -fs $i e.jpg
        sleep 1
      done
    done

Every time VLC reloads `e.jpg`, the stream produces another image.  The stream can be opened up by a client video player to see the slideshow. Voila!

Pros and cons
=============

Advantages to using VLC for this are:

- You can assume any host will have a media player and ability to open up the stream. For instance, when you are borrowing a computer onsite to run the slideshow.
- Because VLC is constantly reloading one image file, a simple bash script can update the image file symlink to produce arbitrary output streams.
- Most slideshow software out there doesn't reload its file list mid-slideshow. So the most recent photos will not appear in most slideshow software.
- Full screen mode is built into media players.

Disadvantage of using this approach:

- You cannot update the stream faster than once per second because `fake-file-reload` is an integer in the VLC code. There is [a patch](http://comments.gmane.org/gmane.comp.video.videolan.vlc.devel/56072) for that if you'd like to compile from source.

Versions
========

Let it be known what my computer setup looks like.

    $ cat /etc/lsb-release 
    DISTRIB_ID=Ubuntu
    DISTRIB_RELEASE=11.04
    DISTRIB_CODENAME=natty
    DISTRIB_DESCRIPTION="Ubuntu 11.04"
    $ vlc --verison
    VLC media player 1.1.9 The Luggage (revision exported)

This trick may not work with VLC 2.x because they moved away from the [fake module](http://wiki.videolan.org/Documentation:Modules/fake) to the image demuxer[*](http://forum.videolan.org/viewtopic.php?f=11&t=98515).

My original (inferior) approach 
===============================

I would use bash scripts to automatically resize images using imagemagick and rsync files across the LAN to the slideshow host computer. I hacked a Processing application to play a slideshow of the images, and reload the file list.

This approach was cumbersome due to juggling configurations on multiple computers, the need to install Processing on the slideshow host computer, and the jankiness of my Processing app because of memoryleaks (crashing occasionally) and the inconsistency of fullscreen.

I don't blame Processing for all of the problems, the "easy solution" is just not as straightforward as it appears.

