---
author: r0x0d
layout: post
title: Debugging a problem with my fish shell.
tags:
  - fish
  - debugging
image:
  path: assets/img/posts/ocean_fish.jpg
  alt: >
    lots of fishes in the ocean. (image ref: https://www.universityofcalifornia.edu/news/exit-dinosaurs-enter-fishes)
date: 2025-06-09 11:56 -0300
---
Recently I made the switch on all my devies to use the great [fish
shell](https://fishshell.com/). It was amazing since it remembered all the
commands I executed previously, was fast as bash and had inline completion.

However, one problem appeared and was bothering me too much. I need to use
[poetry](https://python-poetry.org) for some projects at work, and everything
worked great while I was using it in `bash`, whoever, when I made the switch to
`fish`, all of the sudden `poetry` stopped working for me.

That seems a bit odd since it was working with `bash` previously without
problems. Where should we look first to understand the problem?

If you never experienced this before, well, `fish` can't really handle `~` in
paths for your $PATH variable.

While digging this and talking with [Sam Doran](https://github.com/samdoran),
which is a colleague from my team at [Red Hat](https://www.redhat.com/), we
discovered that the problem was in `fish` handling '~' in the $PATH environment
variable by simply testing the following:

Take a look at the following test he conducted with me:

```bash
> env -v -i PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin  HOME=$HOME TERM=$TERM /bin/bash

#env clearing environ
#env setenv:	PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
#env setenv:	HOME=/Users/$USER
#env setenv:	TERM=xterm-256color
#env executing:	/bin/bash
#env    arg[0]=	'/bin/bash'

bash-3.2$
bash-3.2$ echo $PATH
/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin

bash-3.2$ export PATH='~/bin':"$PATH"

bash-3.2$ echo $PATH
~/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin

bash-3.2$ command -v simple.sh
/Users/$USER/bin/simple.sh

bash-3.2$ simple.sh
Running a simple script
```

and

```bash
> env -v -i PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin SHELL=$SHELL HOME=$HOME TERM=$TERM /opt/homebrew/bin/fish -l
#env clearing environ
#env setenv:	PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
#env setenv:	SHELL=/opt/homebrew/bin/fish
#env setenv:	HOME=/Users/$USER
#env setenv:	TERM=xterm-256color
#env executing:	/opt/homebrew/bin/fish
#env    arg[0]=	'/opt/homebrew/bin/fish'
#env    arg[1]=	'-l'
$USER@rhmbp-2021 ~>
$USER@rhmbp-2021 ~> set -x PATH /usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin

$USER@rhmbp-2021 ~> echo $PATH
/usr/local/bin /usr/bin /bin /usr/sbin /sbin

$USER@rhmbp-2021 ~> set -x PATH '~/bin' $PATH
$USER@rhmbp-2021 ~> echo $PATH
~/bin /usr/local/bin /usr/bin /bin /usr/sbin /sbin

$USER@rhmbp-2021 ~> command -v simple.sh
$USER@rhmbp-2021 ~ [127]>
```
Credits: [Sam Doran](https://github.com/samdoran)

No matter how you tested it, `fish` would never recognize that you had valid
binaries inside your `~/.local/bin` folder (or any other folder that you had
set in your $PATH that starts with '~').

The reason behind this is really simple. `fish` does not expand the $PATH
variables when it has '~' in it[^fish-issue]. If you want `fish` to recognize your path
where you install your binaries, you have to either use the full path in it,
like:

```bash
export $PATH="$PATH:/home/$USER/.local/bin"
```

or, you can use the following `fish` snippet to add the folder to the
`fish_user_paths` global variable.

```bash
set -U fish_user_paths ~/.local/bin
```

And it got reported/covered in here
https://github.com/fish-shell/fish-shell/issues/7568#issuecomment-749200158.

# References

[^fish-issue]: [fish-shell#7568](https://github.com/fish-shell/fish-shell/issues/7568#issuecomment-749200158)