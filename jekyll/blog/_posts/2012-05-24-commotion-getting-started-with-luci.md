---
layout: blog-item
title: "Commotion: Getting Started With LuCI"
show: True
---

Commotion's web front-end is a fork of LuCI with Commotion modules and themes. Two pages I found helpful when learning how to develop under the LuCI web interface for Commotion were these:

- the [LuCI project page](http://luci.subsignal.org/trac) provides a brief history of the LuCI project
- the [modules howto page](http://luci.subsignal.org/trac/wiki/Documentation/ModulesHowTo) is a clear look at the structure the file structure of the code and the advantages to using LuCI

The takeaway from these pages is that LuCI is an MVC system written in LUA ([don't let the colons scare you](http://lua-users.org/wiki/ColonForMethodCall)). LuCI was specifically designed to bind with UCI, the OpenWrt cross-platform command line tool for performing system settings. The "user > LuCI > UCI > system" workflow is rather powerful and modular for giving end-users significant control over the system through the web interface.

The LUA source files in the controller directory each have an `index` function that are individually responsible for building the URI tree for navigating the website.

Doing some sleuthing I found that the landing page for Commotion LuCI is found in `controller/commotion/commotion.lua`. In particular, this code appears to make it the landing page:

    local page  = node()
    page.lock   = true
    page.target = alias("commotion")
    page.subindex = true
    page.index = false

    local root = node()
    if not root.lock then
        root.target = alias("commotion")
        root.index = true
    end

Adding new pages to LuCI is easy by following the format of the `entry` functions.

