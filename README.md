# website

Personal site: CV frontpage, blog, science write-ups, and project write-ups.
Built with [Zola](https://www.getzola.org/), packaged as a Nix flake, served off
the homeserver through a Cloudflare Tunnel.

## Layout

```
content/
├── _index.md              # the CV frontpage
├── blog/                  # one file per post, sorted by date
├── science/               # one file per paper or thesis, summary in the body
└── projects/              # one file per project, ordered by `weight`
templates/                 # Tera templates, one per section type
static/
├── style.css              # the whole stylesheet
└── science/               # PDFs live here, when one is hosted rather than linked
```

The directory name under `content/` **is** the URL.
`content/science/` serves `/science/`, so renaming a section means renaming the
directory, not just its `title`, and the matching `config.extra.nav` entry.

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

**A science entry.**
A file in `content/science/`.
The markdown body is the summary, and every `extra` field is optional, so an
entry with no DOI yet just renders without that link.

```toml
+++
title = "Paper title"
date = 2026-03-14

[extra]
authors = "M. Kronberger, A. Coauthor"
venue = "Journal of Something 12(3), 45–67"
pdf = "https://github.com/.../releases/download/v1.0/thesis.pdf"
source = "https://github.com/kronberger-droid/some-thesis"
doi = "10.1000/xyz123"
arxiv = "2603.01234"
code = "https://github.com/kronberger-droid/some-analysis"
+++

The summary, as long as it needs to be.
```

`source` is where the document itself is written, `code` is the analysis behind
it.
When there is no `pdf`, `source` renders as the button instead, so an entry
always has one obvious way in.

### Where the PDF goes

`extra.pdf` takes either a path under `static/` (`/science/paper-slug.pdf`) or a
full URL, and the template branches on which it got.

Prefer a **GitHub release asset** on the repo the document is written in:

```nu
gh release create v1.0 -R kronberger-droid/some-thesis --title "..." --notes "..." thesis.pdf
```

Release assets never enter git history, so they do not bloat this repo, and this
repo is consumed as a `github:` flake input, which fetches a **tarball** from
codeload.
That matters more than it looks: a tarball export does not resolve git-lfs
pointers, so an LFS-tracked PDF would arrive as its ~130 byte pointer stub, get
copied into the output, and be served as a PDF that no reader opens, with the
build reporting success.
So do not reach for `git lfs` here.

Committing a small PDF into `static/science/` is fine when it is a megabyte or
two.
Just remember every `nix flake update website` refetches the whole tarball, so
anything large is paid for on each deploy, forever.

Name the asset descriptively before uploading.
The filename in the URL is what lands in the visitor's Downloads folder, and
`main.pdf` is not a useful thing to find there later.

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
