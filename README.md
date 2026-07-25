# website

Personal site: CV frontpage, blog, publications with downloadable PDFs, and
project write-ups.
Built with [Zola](https://www.getzola.org/), packaged as a Nix flake, served off
the homeserver through a Cloudflare Tunnel.

## Layout

```
content/
├── _index.md              # the CV frontpage
├── blog/                  # one file per post, sorted by date
├── publications/          # one file per paper, summary in the body
└── projects/              # one file per project, ordered by `weight`
templates/                 # Tera templates, one per section type
static/
├── style.css              # the whole stylesheet
└── publications/          # PDFs live here
```

## Working on it

```nu
nix develop        # drops you into a shell with zola
zola serve         # live-reloading preview on localhost:1111
nix build          # produce the site exactly as the server will
```

## Adding content

**A blog post.**
A file in `content/blog/` with `title` and `date` set.
The filename becomes the URL slug.

**A publication.**
A file in `content/publications/`.
Drop the PDF in `static/publications/` and point `extra.pdf` at it.
The markdown body is the plain-language summary, and every `extra` field is
optional, so an entry with no DOI yet just renders without that link.

```toml
+++
title = "Paper title"
date = 2026-03-14

[extra]
authors = "M. Kronberger, A. Coauthor"
venue = "Journal of Something 12(3), 45–67"
pdf = "/publications/paper-slug.pdf"
doi = "10.1000/xyz123"
arxiv = "2603.01234"
code = "https://github.com/kronberger-droid/some-analysis"
+++

Two or three sentences for someone outside the field.
```

**A project.**
A file in `content/projects/` with `extra.repo` set and a `weight` controlling
where it lands in the list.
Projects carry no date, so they are ordered by `weight` alone.

## Publishing

The nixos config consumes this repo as a flake input, so a change is live once
the input is bumped and the server is redeployed:

```nu
git add -A; git commit -m "..."; git push
cd ~/.config/nixos
nix flake update website
deploy .#homeserver
```

`nix build .#packages.x86_64-linux.default` reads from **git**, not the working
tree.
An untracked file is invisible to the build and produces no error, it just
silently does not appear on the site.
So `git add` before building.
