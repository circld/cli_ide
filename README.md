# TODO

*   `tmux` broken: `.tmux.conf` points to `/usr/local/bin/fish`, whereas `fish` is installed to `/usr/bin/fish`... how to best retain consistency across environments?
    *   should the default user *really* be `root`?
        *   https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
        *   https://linoxide.com/linux-how-to/create-home-directory-existing-user-linux/
        *   https://medium.com/better-programming/docker-best-practices-and-anti-patterns-e7cbccba4f19
*   move python reqs into requirements file
*   decide whether to include all linters/fixers or have separate images
    *   pros: better modularity, size advantages (TODO how big is the all-in-one vs python vs rust images?)
    *   cons: need to retain some build dependencies for downstream installs (e.g., `pyls` needs C build tools)
    *   separate: create language-specific images using cli_dev as a base (update `Installation` section below)
        *   install language-specific linters and fixers
*   how to handle `pyenv`?
    *   if installing, check `https://github.com/jfloff/alpine-python` for ideas
    *   otherwise, address `.spacevim` and `config.fish` references to `pyenv`
*   optimize image size
    *   build dependency identification and cleanup
    *   python/intermediate artifact cleanup
*   add specific versions to installs (e.g., base image) for a more deterministic build

# Installation

`$ git clone https://github.com/circld/cli_ide && cd cli_ide`

`$ docker build . -t cli_dev:latest`

# Usage

`$ docker run --name cli_ide --rm -it --mount type=bind,src=(pwd),dst=/src cli_dev:latest`

or with `fish` utility function:

`$ dev`
