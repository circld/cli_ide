FROM alpine:latest as base

MAINTAINER Paul Garaud (https://github.com/circld)

ENV HOME /
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
    git                                                          \
    git-perl                                                     \
    less                                                         \
    make                                                         \
    man-pages                                                    \
    mandoc                                                       \
    ncurses                                                      \
    neovim                                                       \
    openssh-client                                               \
    # https://stackoverflow.com/questions/30624829 #             \
    musl-dev                                                     \
    gcc                                                          \
    ################################################             \
    python3-dev                                                  \
    py-pip                                                       \
    ripgrep                                                      \
    tmux                                                         \
    ;                                                            \
    # personal dotfiles/configurations                           \
    git clone https://github.com/circld/Prefs                    \
    && ln -fs $HOME/Prefs/.config/fish .config/fish              \
    && ln -s $HOME/Prefs/.gitconfig .gitconfig                   \
    && ln -s $HOME/Prefs/git-personal.conf git-personal.conf     \
    && ln -s $HOME/Prefs/pycodestyle pycodestyle                 \
    && ln -s $HOME/Prefs/.tmux.conf .tmux.conf

# space-vim
RUN pip install msgpack pynvim;                                            \
    git clone https://github.com/liuchengxu/space-vim.git $HOME/.space-vim \
    # && ln -s $HOME/.space-vim/init.vim $HOME/.config/nvim/init.vim;      \
    && cd $HOME/.space-vim && make neovim && cd $HOME                      \
    && ln -fs $HOME/Prefs/.spacevim .spacevim

# install neovim plugins
RUN nvim -V0 +'PlugInstall' +'qa' \
    || nvim --headless -V0 +'UpdateRemotePlugins' +'PlugInstall! --sync' +'qa' \
    || true

# LanguageClient-neovim needs its own step
WORKDIR $HOME/.vim/plugged/LanguageClient-neovim
RUN sh ./install.sh
WORKDIR $HOME/src

# cleanup
# RUN apk del gcc musl-dev

ENV EDITOR nvim
ENV SHELL /usr/bin/fish

ENTRYPOINT ["fish"]
