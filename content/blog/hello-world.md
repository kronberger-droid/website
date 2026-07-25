+++
title = "Setting up this site"
date = 2026-07-25
description = "A static site built by Zola, packaged as a Nix flake, served off a homeserver through a Cloudflare Tunnel."

[taxonomies]
tags = ["nix", "self-hosting"]
+++

This site is a Zola build wrapped in a Nix flake.
The homeserver pulls it in as a flake input, nginx serves the resulting store
path on localhost, and a Cloudflare Tunnel carries it to the internet without
opening a single inbound port on the router.

The nice property is that publishing and rolling back are the same operation as
any other system change: bump the flake input, `deploy-rs`, done.
If a post breaks the build, the deploy fails and the live site keeps serving the
previous store path.

## Writing a post

Drop a markdown file in `content/blog/`, set `title` and `date` in the front
matter, write.
`zola serve` gives a live preview on `localhost:1111`.
