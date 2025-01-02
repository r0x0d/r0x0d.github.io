---
author: r0x0d
layout: post
slug: writting-gh-extension-with-ai
title: Writting a GH extension with AI
description: I have just recently discovered about deepsek-coder, and I had to try it.
date: 2025-01-01 21:50 -0300
tags:
  - ai
  - github
  - gh
  - extension
  - bash
---

I was looking out for some github repositories in my home page recently, with
the hopes to find some interesting project or just to browse out the updates
from the people that I follow. While I was looking out for those updates, I
bumped into [DeekSeek-Coder](https://github.com/deepseek-ai/DeepSeek-Coder). 

At first, I thought to myself that it was just another AI experimental project,
but to my fortune, I discovered gold here.

## My history with AI

I was always the type of person who didn't care too much about AI as I felt
that it was not worth it to use it to do the job that I was supposed to do.
That changed drastically when I started using [zed](https://zed.dev/) and it's
awesome AI integration.

Zed makes interacting with AI pretty simple and straightforward. You just need
to configure either a local LLM provider, an API Key to a service (like
OpenAI), or you could just use the out-of-the-box Zed solution with Claude.

The later was my choice for diving into the AI world. I felt that Claude had
good code generation and was driving giving me good answers here and there.

When I bumped into the free tier limit with this integration, I started using
other providers like [ChatGPT](https://chatgpt.com) or even [GitHub
Copilot](https://github.com/features/copilot).

ChatGPT, of course, had the best results when you ask the question using that
limited amout of tokens for the good model they provide, and GitHub Copilot on
the free tier was... Strange...

With the bad experience with GitHub Copilot I had and not wanting to pay for a
subscription in ChatGPT, `DeepSeek-Coder` felt like a good option for myself.

## Writting some code with it

So, to test this out, I asked `DeepSeek-Coder` to write some code for me. It
couldn't be just some random code, but something that I really wanted. I asked
`DeepSeek-Coder` to write me a bash script to interact with `gh api` command
and retrieve the stargazer from a user.

Why this matters, you may think? Well, I've grown to use stargazers in github a
lot recently, and every time that I wanted to clone a particular repository or
a set of repositories from a tag or a topic, it was a pain to do that all by
hand. So I asked `DeepSeek-Coder` to help me out with that and write some
simple bash script that could do the following:

1. Fetch the user starred repositories
1. Filter the repositories by a "tag"
1. Show it using TUI (mainly fzf) the repositories for the user to select which repo they want to download
1. If the repo already exists, skip it.

A pretty simple challenge, and something that an AI can do.

All of the questions I asked in that chat window, `DeepSeek-Coder` did it
amazingly well. The code itself was not that difficult and did not contain
trick regex expressions and stuff like that, but it managed to handle all my
use case above pretty nicely.

I need to test it a bit more and try to generate some more complex use cases,
but `DeepSeek-Coder` was on point with what I wanted and was able to generate
for me a single bash script that could do all the above. Something that `GitHub
Copilot` failed to do.

## Conclusion

If you want to take a look at what I did using `DeepSeek-Coder`, please feel
free to check out the gh extension repository I created:
[r0x0d/gh-stargazer-clone](https://github.com/r0x0d/gh-stargazer-clone).