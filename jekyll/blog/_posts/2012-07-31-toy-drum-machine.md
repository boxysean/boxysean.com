---
layout: blog-item
title: Toy Drum Machine
show: True
---

Last weekend [Reid](http://www.reidbingham.com) and I joined forces to participate in the first [Monthly Music Hackathon](http://monthlymusichackathon.org/) hosted by the dudes over at [exfm](http://ex.fm).

Reid and I went with our laptops and a couple sacks full of electrical gear to add a MIDI interface and beat sequencer to one of Reid's wonderful circuit bent creations, the child's four-button drum toy pictured below.

![toy drum]({{ site.url }}/media/images/toy-drum-machine/toy-drum.png)

I'll spare the suspense, we were successful in adding the MIDI interface. After the hacking portion of the hackathon concluded, we had a performance and demo session to show everybody what else we made. Check out the following video.

<iframe width="640" height="360" src="https://www.youtube.com/embed/4MBHX4e2kkA?feature=player_detailpage" frameborder="0" allowfullscreen></iframe>

We also have audio recorded from the drum machine's lineout. It sounds completely different, probably because it's just grabbing the raw signal and no reverb from the space.

<iframe width="100%" height="166" scrolling="no" frameborder="no" src="http://w.soundcloud.com/player/?url=http%3A%2F%2Fapi.soundcloud.com%2Ftracks%2F54595215&show_artwork=true"></iframe>

Other cool stuff at the hackathon were HTML5/JavaScript apps to do realtime audio processing in your browser, an app to map one song's timbre onto another song's pitch (??? crazy stuff), and, my favourite, a web app that drops a beat on the Google translate robot voice rapping the words you type.

How it works
------------

![circuit and arduino]({{ site.url }}/media/images/toy-drum-machine/circuit-and-arduino.png)

We used an Arduino microcontroller with a [MIDI shield](https://www.sparkfun.com/products/9595) to act as a MIDI interface to the circuit bent toy. The toy has four samples, so we mapped C4 (middle C) to D#4 to trigger those samples. A non-zero velocity on the MIDI message turns the sample on, and a zero velocity turns the sample off.

Reid extended two leads from each (normally open) button of the toy drum. Once the leads touch each other (i.e., the button is depressed), the sample is triggered. So we used 2N3904 transistors to act as a digital switch controlled by the Arduino.

With the Arduino's digital out connected to the base and each of the buttons' leads attached to the collector and emitter, we were able to trigger the toy drum samples when we sent HIGH (then LOW) to the transistor base from the Arduino.

We replicated this pattern for all four buttons, created a simple sequencer in MaxMSP, then plugged our laptop into the MIDI interface, and voila! sick beats and a child's toy.

We had our hiccups along the way. Reid inserted a 1 Megaohm potentiometer somewhere in the circuit to speed up and slow down the internal clock on the toy drum. This feature works great in standalone mode, but the pot range was limited once we started sequencing. I can't help but wonder if this is because of the extra volts sent from the Arduino to the toy drum via the transistor.

The nice thing about the pattern of using the Arduino and MIDI shield is that we were not reliant on the laptop to be our sequencer. In the end, that's what we ended up using, but this device could be packaged up and controlled by using someone's standalone sequencer.

Grab the code for the Arduino and MaxMSP sequencer used for this on [Github](https://github.com/boxysean/ToyDrumMachine).
