# TODO

## Near-term

*   add specific versions to installs for a more deterministic build
    *   specific alpine version

## Longer-term

*   expose a range of ports (but then... cannot be interactive? think this through)
    *   take port mappings as an optional argument
*   should the default user *really* be `root`?
    *   https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
    *   https://linoxide.com/linux-how-to/create-home-directory-existing-user-linux/
    *   https://medium.com/better-programming/docker-best-practices-and-anti-patterns-e7cbccba4f19
*   install linters and fixers
    *   longer-term: consider creating language-specific images using cli_dev as a base (update `Installation` section below)
*   how to handle `pyenv`?
    *   if installing, check `https://github.com/jfloff/alpine-python` for ideas
    *   otherwise, address `.spacevim` and `config.fish` references to `pyenv`
*   optimize image size
    *   build dependency identification and cleanup
    *   python/intermediate artifact cleanup

# Installation

`$ git clone https://github.com/circld/cli_ide && cd cli_ide`

`$ docker build . -t cli_dev:latest`

# Usage

`$ docker run --name cli_ide --rm -it --mount type=bind,src=(pwd),dst=/src cli_dev:latest`

or with `fish` utility function:

`$ dev`
