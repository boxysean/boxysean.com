---
layout: blog-item
title: VirtualBox and commotion-openwrt
show: True
---

These are the steps I took to get a VirtualBox instance of Commotion. Prior to this, I hadn't used VirtualBox nor Commotion.

- Clone the [commotion-openwrt project](https://code.commotionwireless.net/projects/commotion-openwrt).
- Either download my Commotion image [from May 23 2012](http://blog.boxysean.com/downloads/openwrt-x86-generic-combined-jffs2-128k.img) or go ahead and build your own (following steps).
- Run the `setup.sh` script in the root directory of `commotion-openwrt` until it a further prompt.
- Enter the openwrt directory and do a `make menuconfig` and change the build target to x86.
- Go ahead and build openwrt with `make V=99`. This took me roughly 1.5 hours on my Ubuntu Linode instance (make sure you have enough disk space).
- In the meantime, install VirtualBox on your local computer. I did this by searching for it in the Ubuntu Software Center app because I kept on downloading the wrong version of VirtualBox from their website.
- Also in the meantime, download an image of [Ubuntu 12.04](http://releases.ubuntu.com/12.04/). You'll need this for VirtualBox.
- Once you've completed your openwrt build, locate the openwrt image at `openwrt/bin/x86/openwrt-x86-generic-combined-jffs2-128k.img`. I'm not sure what the difference between the images are, but just went ahead and tried one and it worked. ;)
- Now go ahead and follow the surprisingly helpful instructions as shown in [this YouTube video](http://www.youtube.com/watch?v=cL81DQk4WL8). In it, you will launch a virtual machine that appears to have the Ubuntu Live CD, which will load a kernel for you. Then, from within the VM, you will grab the image you previously compiled and mount it (?? not sure what the proper term is) on another disk. Rebooting the VM will attempt to load from this disk, and if successful, you will have a VM with Commotion.

It took me awhile to come to get this working, so have patience. Other things I tried and failed:

- The [OpenWRT VirtualBox guide](http://wiki.openwrt.org/doc/howto/virtualbox) expects that the bridge adapter setting in the VM configuration is sufficient for network access to the VM. Not in my case, however. I couldn't figure out how to get networking working in the Commotion VM without first going through the Ubuntu Live CD. So, yes, you can load Commotion VM directly into VirtualBox without an Ubuntu VM, but it's nontrivial to get the network up. Beware.
- Similarly, I could launch Commotion VM with qemu, but couldn't get the networking working.
- VirtualBox emulation seems to be faster in Ubuntu than OS X 10.5 by a significant amount.
