---
layout: blog-item
title: The state of testing in dbt
show: True
---

On 31 March 2021 I spoke at the [Analytics Engineering Meetup](https://www.meetup.com/analytics-engineering/events/276687573) with a talk called "The state of testing in dbt".

Testing is the part of an analytics project that people skip. There is always another model to ship, and the tests can come later, which usually means never. My argument was that the useful question is not whether you have tests. The useful question is which assumptions in your models are actually covered. Every model rests on assumptions about the data it is built from, and some of those assumptions are checked by a test while others are only held in someone's head. Going through a project and asking which assumptions are written down as tests, and which are not, tells you much more about how far you can trust it than knowing that tests exist at all.

The meetup page is the record of the event.

This talk moved on from delivering data, the subject of my 2020 Coalesce talk, to trusting it. Data that arrives on time still has to be right, and tests are how you know which parts of it you can rely on.

Read it: <https://www.meetup.com/analytics-engineering/events/276687573>
