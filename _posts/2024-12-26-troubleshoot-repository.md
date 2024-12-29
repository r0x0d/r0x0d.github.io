---
author: r0x0d
layout: post
slug: troubleshoot-repository
date: '2024-12-30T01:25:00Z'
title: How to keep track of day-to-day workflow problems?
description: 'Troubleshooting can be difficult, but luckily we have simple ways of making it easy.'
tags:
  - github
id: 2180055
canonical_url: 'https://r0x0d.com/posts/troubleshoot-repository'
---

TLDR; Here's the repository: https://github.com/r0x0d/troubleshoot

# What I'm even talking about?

So, recently I decided to start out a repository in GitHub to track out all the
workarounds/solutions for common problems that I faced regularily in my
machines. Problems like: "Why is my RDP in gnome not working?" or "I have
configured fingerprintd, but it does not work"  

Such problems are very common when you reset your machines and start from zero,
or things just break when are you are sleeping. I was tired of losing countless
hours looking around the internet to find that one answer from a forum in 2002
that solved the issue, hence, I created this new repository with the idea of
tracking all those solutions.

# How do you even structure something like that?

Well, the repository structure is quite simple. Is just a markdown file with
well-defined headers. I choose to go simple here to avoid custom tooling or
getting myself a new problem and make this the chicken-egg problem.

```markdown
## <Operating system>
### <Category of the problem>
- <A small description>
-- <The solution>
```

This helps me to keep track of specific problems by category and by operating
system. On my day to day, I usually use Linux for my work/development, and
Windows for gaming. 

# Exceptions to the simple structure

Recently, I started to track out problems that are not OS specifics, but rather
_tooling_ specifics. With that in mind, I had to add an exception to my simple
structure:

```markdown
## <Operating system>
### <Category of the problem>
- <A small description>
-- <The solution>

## Tooling
```

The `Tooling` header is platform agnostic. It is used for problems that could
be seen either in Linux or Windows.

