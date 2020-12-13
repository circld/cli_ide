# TODO clean up, move python reqs into separate file
FROM alpine:latest as base

MAINTAINER Paul Garaud (https://github.com/circld)

ENV HOME /
ENV XDG_DATA_HOME $HOME/.config
WORKDIR $HOME

RUN mkdir -p .config/nvim                                                     \
    apk add -U --no-cache                                                     \
    --repository http://nl.alpinelinux.org/alpine/edge/community              \
    bash                                                                      \
    bat                                                                       \
    curl                                                                      \
    entr                                                                      \
    fish                                                                      \
    fzf                                                                       \
    git                                                                       \
    git-perl                                                                  \
    less                                                                      \
    man-pages                                                                 \
    mandoc                                                                    \
    ncurses                                                                   \
    neovim                                                                    \
    openssh-client                                                            \
    # https://stackoverflow.com/questions/30624829                            \
    musl-dev                                                                  \
    gcc                                                                       \
    python3-dev                                                               \
    py-pip                                                                    \
    ripgrep                                                                   \
    tmux                                                                      \
    # vim-plug
    && sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    # space-vim                                                                  \
    && pip install pynvim                                                     \
    && git clone https://github.com/liuchengxu/space-vim.git $HOME/.space-vim \
    && ln -s $HOME/.space-vim/init.vim $HOME/.config/nvim/init.vim            \
    # personal dotfiles/configurations                                        \
    && git clone https://github.com/circld/Prefs                              \
    # symlink                                                                 \
    && ln -fs $HOME/Prefs/.config/fish .config/fish                           \
    && ln -s $HOME/Prefs/.spacevim .spacevim                                  \
    && ln -s $HOME/Prefs/.gitconfig .gitconfig                                \
    && ln -s $HOME/Prefs/pycodestyle pycodestyle                              \
    && ln -s $HOME/Prefs/git-personal.conf git-personal.conf                  \
    # cleanup                                                                 \
    # TODO can remove pip?                                                   \
    && apk del gcc musl-dev

# TODO install LanguageClient-neovim; needs to happen manually:
# https://github.com/autozimu/LanguageClient-neovim/blob/next/INSTALL.md

# FIXME pyenv: install it orremove refs from .spacevim + config.fish?

# TODO
# - python
#   - ipython?
# - rust (clippy? rls? rustfmt? incl by default?)
# - linters
#   - pyls
#   - sh: language_server, shellcheck, shfmt
#   - mypy
# - fixers
#   - black

ENV EDITOR nvim
ENV SHELL /usr/bin/fish

ENTRYPOINT ["fish"]
