+++
title = "nixos-config"
weight = 2

[extra]
repo = "https://github.com/kronberger-droid/nixos-config"
language = "Nix"
role = "author"
+++

A single flake describing every machine I run: desktops, laptops, a homeserver,
a Raspberry Pi media box, and an Android phone through nix-on-droid.

Deploys go out with `deploy-rs`, secrets are encrypted at rest with agenix, and
the homeserver doubles as a binary cache and aarch64 remote builder for the
weaker hosts.
