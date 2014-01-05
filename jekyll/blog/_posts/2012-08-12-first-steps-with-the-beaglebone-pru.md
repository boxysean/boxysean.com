---
layout: blog-item
title: First steps with the BeagleBone PRU
show: True
---

<em>Update July 5 2013: I haven't been able to test this code on the Beaglebone Black yet. If you are running into issues, I suggest discussing them in the comments at the bottom of the page.</em>

The goal of this post is to rehash the lessons I learned with my first steps working with the [BeagleBone's](http://beagleboard.org/static/beaglebone/latest/README.htm) pretty awesome Programmable Real-time Unit (PRU -- also refered to as the Programmable Real-time Unit Subsystem, PRUSS). <em>Prior to this post, I looked up conversations on the BeagleBoard Google Group and AM335x discussion boards and patched together what I needed to know in order to successfully compile, assemble, and run code to blink the onboard BeagleBone LEDs via the PRU.</em>

Getting started
---------------

The BeagleBoard team [released a nice package](https://github.com/beagleboard/am335x_pru_package) to develop code to run on the BeagleBone's PRU. There isn't much documentation on what to do with this package when you get it, but here's what I did that worked.

First, SSH into your BeagleBone.

{% highlight bash %}
root@beaglebone:/tmp# git clone git://github.com/beagleboard/am335x_pru_package.git
Cloning into 'am335x_pru_package'...
...
root@beaglebone:/tmp# cd am335x_pru_package/pru_sw/app_loader/interface
root@beaglebone:/tmp/am335x_pru_package/pru_sw/app_loader/interface# make CROSS_COMPILE="" # we're compiling right on the system, so no need to cross compile
...
root@beaglebone:/tmp/am335x_pru_package/pru_sw/app_loader/interface# cd ../../utils/pasm_source
root@beaglebone:/tmp/am335x_pru_package/pru_sw/utils/pasm_source# ./linuxbuild
root@beaglebone:/tmp/am335x_pru_package/pru_sw/utils/pasm_source# cd ../../example_apps
root@beaglebone:/tmp/am335x_pru_package/pru_sw/example_apps# make CROSS_COMPILE=""
...
root@beaglebone:/tmp/am335x_pru_package/pru_sw/example_apps# cd bin
root@beaglebone:/tmp/am335x_pru_package/pru_sw/example_apps/bin# modprobe uio_pruss # so very important, load the kernel module or else  the code will fail
root@beaglebone:/tmp/am335x_pru_package/pru_sw/example_apps/bin# ./PRU_memAccessPRUDataRam # one of the examples provided by Beagle / TI
INFO: Starting PRU_memAccessPRUDataRam example.
AM33XX
        INFO: Initializing example.
        INFO: Executing example.
File ./PRU_memAccessPRUDataRam.bin open passed
        INFO: Waiting for HALT command.
        INFO: PRU completed transfer.
INFO: Example executed succesfully.
root@beaglebone:/tmp/am335x_pru_package/pru_sw/example_apps/bin# 
{% endhighlight %}

<em>Reminder #1: always run `modprobe uio_pruss` before running any code for the PRU! You only need to do it once per bootup. If you search the Google Groups BeagleBoard list you'll notice many people forgetting this step. I asked for help on IRC (#beagle on freenode) and received the same response.</em>

Go ahead and check out how the examples works, they're pretty illustrative. Basically there's a C program for each example that uses the `prussdrv` library to expose functions to load the PRU with code, memory map the PRU's RAM, and elegantly complete the PRU's execution. The `*.p` file is AM335x assembly and runs directly on the PRU.

AM335x PRU assembly, in my limited experience, is pretty friendly. Check out the [AM335x PRU reference guide (PDF)](https://github.com/beagleboard/am335x_pru_package/blob/master/am335xPruReferenceGuide.pdf?raw=true). The thing I liked the most is found on page 22, where it describes the Execution Model of the architecture: "Pipelining: None (Purposefully)". This simplifies the process of writing assembly (for the journeyman assembly coder), meaning you don't need to worry about operations taking more than one clock cycle for a result. There are 29 registers (`r1-30`) at your disposal, which is more than the 6 or so I had when I first learned assembly.

Making the PRU blink the BeagleBone
-----------------------------------

Now that we've got example code running on the PRU and hopefully have some idea of what it's doing, it's time to add a new PRU example app: blinking the BeagleBone's LEDs. This was done by Lyren Brown in a [buried post](https://groups.google.com/forum/?fromgroups#!topic/beagleboard/35ZXP82EQjA[1-25]) on the BeagleBoard's mailing list. I've reposted the code here.

{% highlight asm %}
    #define GPIO1 0x4804c000
    #define GPIO_CLEARDATAOUT 0x190
    #define GPIO_SETDATAOUT 0x194
        MOV r1, 10
    BLINK:
        MOV r2, 7<<22
        MOV r3, GPIO1 | GPIO_SETDATAOUT
        SBBO r2, r3, 0, 4
        MOV r0, 0x00a00000
    DELAY:
        SUB r0, r0, 1
        QBNE DELAY, r0, 0
        MOV r2, 7<<22
        MOV r3, GPIO1 | GPIO_CLEARDATAOUT
        SBBO r2, r3, 0, 4
        MOV r0, 0x00a00000
    DELAY2:
        SUB r0, r0, 1
        QBNE DELAY2, r0, 0
        SUB r1, r1, 1
        QBNE BLINK, r1, 0
{% endhighlight %}

The code is illustrative on how to use the PRU to write to the BeagleBone's pins. Lyren uses the address `0x4804c000` which refers to the memory space mapped to the `GPIO1` registers (see Texas Instrument's [AM335x technical reference manual (PDF)](http://www.ti.com/lit/ds/symlink/am3358.pdf). Writing bits to the `GPIO_CLEARDATAOUT` and `GPIO_SETDATAOUT` registers sets the BeagleBone's pins low and high respectively. In particular, writing `7<<22` to `GPIO_SETDATAOUT` sets the 22nd, 23rd, and 24th pins high (excercise to reader: why does it set all three pins high?), these pins being the LEDs on the BeagleBone. Very cool.

To write our LED blinking application, lets use Lyren's code and make it work in the same way the examples are structured (a C harness file to load the PRU assembly above). We can take advantage of the Makefile structure the BeagleBoard people gave us in the `am335x_pru_package` by creating a new folder for the code in `am335x_pru_package/pru_sw/example_apps` and adding new lines to the `am335x_pru_package/pru_sw/example_apps/DIRS` files.

In the process of creating this app, I was tripped up by another common snag for a new AM335x PRU developer: clearing the `STANDBY_INIT` bit in the `SYSCFG` register.

<em>Reminder #2: always make sure to clear the `STANDBY_INIT` bit in the `SYSCFG` register, otherwise the PRU will not be able to write outside the PRU memory space and to the BeagleBone's pins. The following three lines at the top of a PRU assembly file will accomplish this.</em>

    LBCO r0, C4, 4, 4
    CLR r0, r0, 4
    SBCO r0, C4, 4, 4

Great! That's basically it, with some handwaving on my part. Our blink application is complete. You can grab it from my [github fork of am355x_pru_package](https://github.com/boxysean/am335x_pru_package/tree/master/pru_sw/example_apps/blink).

Using the PRU as a realtime interface
-------------------------------------

My goal is to use the BeagleBone to directly output DMX, a fairly [simple protocol](http://www.bnoack.com/lighting/DMX512.html) developed in the 80s for controlling professional lighting systems and still in use today. I believe the PRU can easily send these data frames with low jitter. If implemented correctly, the BeagleBone then can become a start-to-finish controller and interface for DMX lighting systems, reducing complexity and cost.

To make this, the last thing I want to do is to write lots of assembly (especially [without a debugger](https://github.com/wz2b/prude)). My idea is to map the 8KB of PRU memory space to a user-space program to update lighting values and load the PRU with a program to constantly sending out the appropriate DMX with those lighting values.

Memory mapping the PRU memory space to the C harness program is easy thanks to the `prussdrv` lib and is illustrated in the `PRU_memAccessPRUDataRam` example (see all available functions [on TI's wiki](http://processors.wiki.ti.com/index.php/PRU_Linux_Application_Loader_API_Guide#prussdrv_map_prumem)).

My first step in exploring the PRU as a realtime interface was to use the C harness program to exchange data with the PRU to control the BeagleBone's LEDs. The assembly I wrote has the PRU continually check the shared memory space to determine the desired state of the LEDs. Meanwhile, the C program running on the Bone's CPU happily flips the bits of the shared memory on and off in a step sequence. I made this in an example called `blinkslave`, [you can grab it on github](https://github.com/boxysean/am335x_pru_package/tree/master/pru_sw/example_apps/blinkslave) and see in action below.

![blinkslave]({{ site.url }}/media/images/beaglebone-blinkslave.gif)
