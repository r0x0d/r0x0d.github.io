---
author: r0x0d
layout: post
slug: system-bus-vs-session-bus
title: SystemBus vs SessionBus
description: Do you know the difference between the two?
date: 2024-12-27 16:07 -0300
tags:
  - dbus
canonical_url: https://r0x0d.com/posts/system-bus-vs-session-bus
---

Have you ever tried to develop an entire application that relies on d-bus
(without knowing too much of d-bus) and when you had to run that application in
a headless server, all of the sudden everything stops to work?

Well... That's basically what I did.

Today, we gonna talk about the differences between system bus and session bus,
and why it is important for you to develop your application with the correct
term in mind.

## Session Bus

Session bus is a special term for d-bus that identifies a message bus
(communication) between processes, and is tied to user connnection. You can use
a session bus if your application has the necessity to run for this single user
and is tied to that environment, the _session_. But keep in mind that it will
require that your application runs on a server that has graphical display
capabilities

Examples of that:

- KDE
- GNOME
- etc...

## System Bus

System bus, on the other hand, is used for system-wide process communication,
they do not require a graphical session (like the Session Bus), and can be
executed in headless servers without any problems.

System bus is indicated for you to use whenever you have to develop an
application that needs to communicate with another service in that
server/computer, and does not necessarily depends on anything graphical. 

## Why the difference between the two matters?

The difference between the two is important to know mainly when developing a
new application. If you want to develop something that will run in a
server/cloud/ephemeral environment, you need to keep this in mind as those type
of machines won't have a graphical display available for you. You need to know
which type of message bus to connect before you can publish your code to
production.

In the end, you won't have a lot of headache if you choose to develop your
service in with the "wrong" kind of message bus, but, that could mean that you
will have to patch, delay, and possibily adapt your workflow to make it work
with the correct bus.

## How do I choose the correct bus?

Essentially, you should follow a very simple rule. If you are developing a new
daemon that needs to notify the user about something (that is running in the
backend), your daemon needs graphical access or to communicate with KDE, GNOME
and etc.. That is the perfect use case for a `session bus`.

If you are developing a service that will talk with a external backend service
(let's say an API), do some calculations, won't need to update any UI elements
or, and will need to communicate with more system services, then you can go
with a `system bus`.

It's that simple.

## A specific note about the system bus option

System bus has a particularity that it needs to be told here. If you are
running your service with a regular `session bus`, you won't need any extra
tweaks or tricks, as you are already authenticated and using the user session,
the bus will be automatically set that your user will be able to intecract with
it.

However, for the `system bus`, since that doesn't require a graphical session,
you will need to create a `.conf` file under a specific folder managed by dbus
to allow your service to own the name in the bus, and also, specify which users
can send and receive messages from your dbus.

The file looks like this:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE busconfig PUBLIC "-//freedesktop//DTD D-Bus Bus Configuration 1.0//EN"
 "http://www.freedesktop.org/standards/dbus/1.0/busconfig.dtd">
<busconfig>
  <!-- Allow the service to own the name -->
  <policy context="default">
    <allow own="com.example.service"/>
  </policy>

  <!-- Allow any user to invoke methods -->
  <policy context="default">
    <allow send_destination="com.example.service"/>
    <allow receive_sender="com.example.service"/>
  </policy>
</busconfig>
```

And it should be placed under: `/etc/dbus-1/system.d/com.example.service.conf`

By doing that, you will be able to let your service to acquire the bus name you
want and make also allow the specific users to communicate with it.

## References

- [Chapter 01 - DBus The Message Bus System](https://maemo.org/maemo_training_material/maemo4.x/html/maemo_Platform_Development_Chinook/Chapter_01_DBus_The_Message_Bus_System.html)