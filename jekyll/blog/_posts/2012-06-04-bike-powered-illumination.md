---
layout: blog-item
title: Bike-Powered Illumination
show: True
---

My bike is bright and shiny!

<object>
    <param name="movie" value="http://www.youtube.com/v/GSZaWNels7E?version=3&amp;feature=player_detailpage" />
    <param name="allowFullScreen" value="true" />
    <param name="allowScriptAccess" value="always" />
    <embed src="http://www.youtube.com/v/GSZaWNels7E?version=3&amp;feature=player_detailpage" type="application/x-shockwave-flash" allowfullscreen="true" allowScriptAccess="always" width="640" height="360" />
</object>

This past semester I had a bicycle wheel built with a hub dynamo for a class project. After the project wrapped up, the dynamo was left to look pretty on my hub without much of a job. So I decided to put it to use with some forgotten EL wire.

Inside an Altoids tin, I put a rectifier to convert the dynamo's AC output to DC, [DC-DC converter](http://www.ebay.com/itm/LM2577-DC-DC-Power-Supply-Step-up-Module-25W-Heatsink-/260775477112?pt=LH_DefaultDomain_0&hash=item3cb76dff78) to change 9-36V to 5V, and [a small EL wire inverter](http://www.coolight.com/product-p/ifw-3294.htm) to change the DC back to AC. I drilled two small holes in the tin and fed through the input and output wires.

![Altoids tin with components]({{ site.url }}/media/images/illuminate-altoids-tin.png)

The dynamo output is hooked up to the rectifer input, and the inverter output is hooked up to the EL wire.

When I generate less than 9V, there's a neat blinking effect which I think is because it's outside the expected range of the DC-DC converter.

Next, I'd like to learn how to replace the project tin contents with a transformer to take the dynamo hub AC output and step it down to 3-5V for which works with the EL wire.
