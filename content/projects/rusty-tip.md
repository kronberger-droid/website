+++
title = "rusty-tip"
weight = 3

[extra]
repo = "https://github.com/kronberger-droid/rusty-tip"
language = "Rust"
role = "author"
+++

Automated STM/AFM tip preparation for Nanonis SPM systems. Conditioning a tip
by hand is slow and inconsistent, so this drives the pulse strategies and the
stability checks itself, behind a hardware abstraction that lets a workflow be
scripted rather than clicked. Ships a CLI and an egui frontend.
