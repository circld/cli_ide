# TODO

*   `.tmux.conf` points to `/usr/local/bin/fish`, whereas `fish` is installed to `/usr/bin/fish`... how to best retain consistency across environments?
    *   should the default user *really* be `root`?
*   add extra `LanguageClient-neovim` install step (`$ sh install.sh`)
    *   see [this link](https://github.com/autozimu/LanguageClient-neovim/blob/next/INSTALL.md) for more info
*   move python reqs into requirements file?
*   create repo and push existing work up
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

# Installation

`$ git clone <TODO> && cd <TODO>`

`$ docker build . -t cli_dev:latest`

# Usage

`$ docker run --name ide --rm -it --mount type=bind,src=(pwd),dst=/src cli_dev:latest`

or with `fish` utility function:

`$ dev`
