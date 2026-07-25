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

**A blog post** — a file in `content/blog/` with `title` and `date` set.
The filename becomes the URL slug.

**A publication** — copy `content/publications/example-publication.md`, put the
PDF in `static/publications/`, and point `extra.pdf` at it.
The markdown body is the plain-language summary.

**A project** — a file in `content/projects/` with `extra.repo` set and a
`weight` controlling where it lands in the list.

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
tree — an untracked file is invisible to the build and produces no error, it
just silently does not appear on the site.
`git add` before building.
