FROM alpine:3.12 as base

MAINTAINER Paul Garaud (https://github.com/circld)

ENV HOME /root
WORKDIR $HOME

RUN mkdir -p .config/nvim;                                       \
    apk add -U --no-cache                                        \
    --repository http://nl.alpinelinux.org/alpine/edge/community \
    bash                                                         \
    bat                                                          \
    curl                                                         \
    entr                                                         \
    fish                                                         \
    fzf                                                          \
    g++                                                          \
    gcc                                                          \
    git                                                          \
    git-perl                                                     \
    less                                                         \
    make                                                         \
    man-pages                                                    \
    mandoc                                                       \
    musl-dev                                                     \
    ncurses                                                      \
    neovim                                                       \
    neovim-doc                                                   \
    openssh-client                                               \
    py-pip                                                       \
    python3-dev                                                  \
    ripgrep                                                      \
    tmux

# symlinks
RUN ln -s /usr/bin/fish /usr/local/bin/fish

# install rustup + components
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \
    | sh -s -- -y -c rls

# python dependencies
RUN pip install -U wheel && pip install msgpack pynvim

# personal dotfiles/configurations
RUN git clone https://github.com/circld/Prefs                    \
    && ln -fs $HOME/Prefs/.config/fish .config/fish              \
    && ln -s $HOME/Prefs/.gitconfig .gitconfig                   \
    && ln -s $HOME/Prefs/.ripgreprc .ripgreprc                   \
    && ln -s $HOME/Prefs/.tmux.conf .tmux.conf                   \
    && ln -s $HOME/Prefs/git-personal.conf git-personal.conf     \
    && ln -s $HOME/Prefs/pycodestyle .config/pycodestyle

# space-vim
RUN git clone https://github.com/liuchengxu/space-vim.git $HOME/.space-vim \
    && cd $HOME/.space-vim && make neovim && cd $HOME                      \
    && ln -fs $HOME/Prefs/.spacevim .spacevim

# install neovim plugins
RUN mkdir -p $HOME/.vim/plugged \
    && nvim -V0 +'PlugInstall' +'qa' \
    || nvim --headless -V0 +'UpdateRemotePlugins' +'PlugInstall! --sync' +'qa' \
    || true

# LanguageClient-neovim needs its own step
WORKDIR $HOME/.vim/plugged/LanguageClient-neovim
RUN sh install.sh
WORKDIR $HOME/src

# LSP, linters, & formatters

# bash
RUN apk add shellcheck shfmt

# python
RUN pip install --ignore-installed distlib black \
                isort                            \
                mypy                             \
                pre-commit                       \
                python-language-server[all]

# vim
RUN apk add vint

ENV EDITOR nvim
ENV SHELL /usr/bin/fish

ENTRYPOINT ["fish"]
