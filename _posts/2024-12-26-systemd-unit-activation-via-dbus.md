---
author: r0x0d
layout: post
slug: systemd-unit-activation-via-dbus
title: Systemd unit activation via dbus
description: 'Have you ever felt the need to activate your systemd unit on the fly via dbus publish? No? Well, I did. Let''s see how this can be accomplished.'
date: '2024-12-26 00:00 -0300'
tags:
  - systemd
  - dbus
id: 2180057
canonical_url: 'https://r0x0d.com/posts/systemd-unit-activation-via-dbus'
---


# The problem

Recently a co-worker of my team has asked me this trivial question:
> Hey, the users will need to call `systemctl ...` on their own to activate our
> daemon?

Well, this is a simple question, right? I mean, it implies that we want to
reduce friction from the user point of view to use our tool. If they call any
commands we have in our terminal client, it should activate the daemon on it's
own.

In my full ignorance, I thought to myself
> Yeah, that's pretty easy. I think I can just change this setting in the
> service level and we are done...

What a fool I am.

We all know that [systemd](https://github.com/systemd/systemd) and
[dbus](https://gitlab.freedesktop.org/dbus/dbus/) are beast of their own, but
what I didn't know was that just a simple change on our own service files would
lead me to hours of exploration, some documentations that are not properly
documentated (don't judge, we all have done that.), and to my surprise, the
answer again was very simple.

## Why this is important?

Well, let me try to be real quick and conscise here. I work on a tool that will
ship a client and a daemon that will work together to deliver some answer to
the user in their own terminal. The tool is called
[command-line-assistant](https://github.com/rhel-lightspeed/command-line-assistant).
The daemon encapsulates all the core logic behind the operations we do and the
client is just a regular client. It show stuff on the terminal.

To reduce the user friction and adoption, we thought that it would be a good
idea that after you install the tool with:

```bash
sudo dnf install command-line-assistant
```

You could just easily do:

```bash
c "why systemd is so complex?"
```

And that would give you a real answer.

Pretty good, right? You don't need to tweak any configuration file, any
settings, nothing. We deal with that stuff for you.

## And why this was so difficult?

Well, to begin with, I'm not that experienced with systemd and dbus. This is my
first time working with it, and it's been amazing. I'm loving all the
challenges and knowledge I'm gaining, but dude... Sometimes I wonder why those
things exists.

The main problem (besides the one above) is that we decided to split our dbus
objects into two main categories:

- query - `com.redhat.lightspeed.query`
- history - `com.redhat.lightspeed.history`

The query category is responsabile for exporting and managing all stuff related
to user queries, like the example above about systemd. The history category, on
the other hand, serve the purpose to store, read and manage the user
conversation cache. This is mainly used for users to remember the interactions
they had with the tool.

## Coulnd't you just follow a tutorial?

Well. I tried. And that was mainly my source of confusion...

See the below snippet:

```systemd
[D-BUS Service]
Name=org.example.simple-dbus-service
Exec=/usr/sbin/simple-dbus-service
User=root
SystemdService=simple-dbus-service.service
```

Now, approach this with the idea of "I don't know what I'm doing" and your
first guess, if you're like me, would be that this is something managed by
systemd, right?

The docs for systemd gives you this nice paragraph:

> For bus-activatable services, do not include a [Install] section in the
> systemd service file, but use the SystemdService= option in the corresponding
> DBus service file, for example
> (/usr/share/dbus-1/system-services/org.example.simple-dbus-service.service):

Self-explanatory, right? I know...

The deal with that is that this small snippet I pasted above is actually a unit
service... for `dbus`... Yeah, that's right. It turns our that dbus can have
"units like" files just like systemd.

Any time that you end up seeing a path that begins with
`/usr/share/dbus-1/system-services`, you know that this will be a dbus service,
not `systemd` service.

In short, the purpose of this file is: Act as a intermediate service for
activating your systemd unit.

What does the trick for activating the systemd unit is this part right here:

```systemd
SystemdService=simple-dbus-service.service
```

By specifying the name of the systemd service it needs to trigger, whenever you
publish a new message to your dbus object, it will trigger the systemd unit
start for you.

What they don't tell you is, if you have a multi-object daemon, one service
like that won't ever trigger your systemd unit.

## Alright! And how did you overcome this?

The fix is pretty simple. For every object (or in this case, I'm calling "sub"
object), you have to create a new dbus service file to hold the trigger for
you.

Using the above categories I mentioned about my project, `query` and `history`,
I would need to have two dbus services that would look something like this:

File: `/usr/share/dbus-1/system-services/com.redhat.lightspeed.query.service`

```systemd
[D-BUS Service]
Name=com.redhat.lightspeed.query
Exec=/bin/false
User=root
SystemdService=simple-dbus-service.service
```

File: `/usr/share/dbus-1/system-services/com.redhat.lightspeed.history.service`

```systemd
[D-BUS Service]
Name=com.redhat.lightspeed.history
Exec=/bin/false
User=root
SystemdService=simple-dbus-service.service
```

They can (and often will, in that setup) point to the same systemd unit file.
The deal is that dbus will use the name of the service, in this case:

```systemd
...
Name=com.redhat.lightspeed.history
...
```

To know that you sent a message from a client and dbus needs to trigger your
systemd unit.

# Conclusion

That's mainly it! It took me some long hours debugging and trying stuff out.
Working with systemd/dbus is not easy, but when you learn something new about
those huge systems, you feel so good.

That's it! Hope you liked the reading so far, and see you in the next post.

# References

- [systemd service docs](https://www.freedesktop.org/software/systemd/man/latest/systemd.service.html)
- [How to define a d-bus activated systemd service?](https://stackoverflow.com/a/31725112)
- [GH PR#72](https://github.com/rhel-lightspeed/command-line-assistant/pull/72)

