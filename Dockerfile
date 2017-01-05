FROM fedora:25

# Packaged dependencies
RUN dnf -y update && dnf -y install \
        curl \
        tar \
        passwd \
        docker \
        vim \
        tmux \
        git \
        gcc

# Install dropbox
RUN curl -fsSL "https://www.dropbox.com/download?plat=lnx.x86_64" | tar -xzf - \
        && mv .dropbox-dist /opt/dropbox

# Install Go
ENV GO_VERSION 1.7.4
RUN curl -fsSL "https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz" | tar -C /opt -xzf -
ENV PATH /opt/go/bin:$PATH

# Install Node.js
ENV NODE_VERSION v7.3.0
RUN curl -fsSL "https://nodejs.org/dist/${NODE_VERSION}/node-${NODE_VERSION}-linux-x64.tar.xz" | tar -Jxf - \
        && mv node-${NODE_VERSION}-linux-x64 /opt/node
ENV PATH /opt/node/bin:$PATH

# Install TypeScript
RUN npm install -g typescript

# Add user
ARG username
RUN useradd -m $username
USER $username
RUN  cd ~ \
        && mkdir -p Documents/go/src Documents/c \
        && curl -fsSL "https://www.dropbox.com/s/nzaif2ssd85mmr3/.vimrc?dl=1" >.vimrc \
        && curl -fsSL "https://www.dropbox.com/s/d6kbhzl8yb0sttx/.tmux.conf?dl=1" >.tmux.conf \
        && git clone "https://github.com/fatih/vim-go.git" .vim/pack/plugins/start/vim-go \
        && git clone "https://github.com/leafgarland/typescript-vim.git" .vim/pack/plugins/start/typescript-vim \
        && mkdir -p .config/systemd/user && cd .config/systemd/user \
        && curl -fsSL "https://www.dropbox.com/s/1ar7stmzcr0491g/dropbox.service?dl=1" >dropbox.service
ENV GOPATH ~/Documents/go

WORKDIR ~
ENTRYPOINT /bin/bash
