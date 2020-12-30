FROM centos/python-36-centos7:1

MAINTAINER Paul Garaud (https://github.com/circld)

ENV HOME /root
WORKDIR $HOME

RUN yum -y update
ENV LANG=en_US.UTF-8
RUN localedef --quiet --force -i en_US -f UTF-8 en_US.UTF-8
RUN yum clean all

# add repos
RUN yum-config-manager                                                                                                 \
    --add-repo=https://copr.fedorainfracloud.org/coprs/carlwgeorge/ripgrep/repo/epel-7/carlwgeorge-ripgrep-epel-7.repo \
    --add-repo=https://download.opensuse.org/repositories/shells:/fish:/release:/3/RedHat_RHEL-6/shells:fish:release:3.repo

RUN mkdir -p .config/nvim;               \
    yum reinstall -y --setopt=tsflags='' \
    man                                  \
    curl                                 \
    git                                  \
    less                                 \
    yum

RUN yum install -y --setopt=tsflags='' \
    fish                               \
    ripgrep                            \
    tmux

# bat
RUN wget https://github.com/sharkdp/bat/releases/download/v0.7.1/bat-v0.7.1-x86_64-unknown-linux-musl.tar.gz -O - \
    | tar -xvzf - -C /usr/local/bin \
    && mv /usr/local/bin/bat-v0.7.1-x86_64-unknown-linux-musl/bat /usr/local/bin/bat

# entr
RUN git clone https://github.com/eradman/entr ~/entr \
    && cd ~/entr                                     \
    && ./configure                                   \
    && make install

# neovim
RUN curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage \
    && chmod u+x nvim.appimage                                                       \
    && ./nvim.appimage --appimage-extract                                            \
    && ./squashfs-root/AppRun --version                                              \
    && mv squashfs-root /                                                            \
    && ln -s /squashfs-root/AppRun /usr/bin/nvim

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

# fzf
RUN git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf \
    && ~/.fzf/install --no-zsh

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
# FIXME
# RUN apk add shellcheck shfmt

# python
RUN pip install black                            \
                isort                            \
                mypy                             \
                pre-commit                       \
                python-language-server[all]

# vim
# FIXME
# RUN apk add vint

ENV EDITOR nvim
ENV SHELL /usr/bin/fish

ENTRYPOINT ["fish"]
