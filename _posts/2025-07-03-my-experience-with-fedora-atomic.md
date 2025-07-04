---
author: r0x0d
layout: post
title: My experience with Fedora Atomic
tags:
  - fedora
  - atomic
  - containers
image:
  path: https://fedoramagazine.org/wp-content/uploads/2017/04/fedora-atomic.png
  alt: fedora atomic logo
date: 2025-07-03 21:36 -0300
---
## Backstory

I've beeng using Linux for the past couple of years now as my mainly driver.
Started using Debian, Ubuntu, Gentoo, and now, I have estabilished Fedora as my
main OS.

My experience was always using the classic RPM-based Fedora daily for the past
5-6 years now. And, you know, it's been good and I never had any problems with
it for the most part. Out of all the systems I have tried before, Fedora was
the only one I really felt that I liked using. From package manager, to
community, decisions and everything else.

A year or two ago, a colleague from work introduced me the concept of [Atomic
desktops](https://fedoraproject.org/atomic-desktops/). It felt weird at first,
but I liked the idea of having my "core" system separated from my applications. 

When I tried to use [Fedora
Silverblue](https://fedoraproject.org/atomic-desktops/silverblue/) for the
first time, it was a shock. I didn't know how to install the development
packages I needed, the system had problems upgrading from one version to
another, and man, everything felt so broken and clumsy that I gave up. The
concept still looked very cool to me, but it was too much for me to learn back
then.

Up recently, I decided to give it another go, since a few years have passed, I
thought that my experience would be different now.

## What version have I chosen now?

For my current experience, I went with [Fedora
Kinoite](https://fedoraproject.org/atomic-desktops/kinoite/) due to be more
familiar with the interface and feeling that it was more responsive than GNOME.

GNOME UI still looks better in my opinion, but the performance of KDE looks way
better.

## How good (or bad) is to use such desktop daily?

To be honest, it still feels a bit weird having to use `rpm-ostree` than `dnf`
when I need to install a package, but overral, I really like the separation of
"layers" that we have due to the entire OS being run in a container. 

Knowing that most of the applications that I need to use (VSCode, Slack,
Firefox, etc...) are available through Flatpaks is also great. Not all of them
are official, but the support is good enough.

So far, I haven't figured out any blockers that a flatpak or a layer rebase
couldn't do it for my system.

## Will I keep using it?

It's very possible that I will adopt Fedora Kinoite as my main OS from now on.
I like the separation of concerns here, the gpg verified updates, automatic
updates, and the ability to "force" me to be more creative to solve daily
problems.

> Those problems are not complex, though. For instance, I've been dealing a lot
> with [toolbox](https://github.com/containers/toolbox) to create development
> boxes or default boxes with the most used tools I use daily.

It's hard for me to say "Yeah, I will go back to rpm based because it is way
better" for now, so, I will give this experience a couple more months.

## Closing thoughts

If you are looking for a change in your personal machines and want to try
something new and exciting, I really recommend trying out any distribution of
Fedora Atomic available. You don't have to go with Fedora Kinoite like I did,
maybe GNOME or [Sway](https://fedoraproject.org/atomic-desktops/sway/) is your
thing.

Maybe start with a VM so you don't lose your sanity on the first couple of days
:)