# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.191.0/containers/jekyll/.devcontainer/base.Dockerfile

FROM mcr.microsoft.com/vscode/devcontainers/jekyll:0.0.2

# [Choice] Node.js version: none, lts/*, 16, 14, 12
ARG NODE_VERSION="none"
RUN if [ "${NODE_VERSION}" != "none" ]; then su vscode -c "umask 0002 && . /usr/local/share/nvm/nvm.sh && nvm install ${NODE_VERSION} 2>&1"; fi

# [Optional] Uncomment this section to install additional OS packages.
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install librsvg2-bin

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install imagemagick

RUN gem install webrick

# [Optional] Uncomment this line to install global node packages.
# RUN su vscode -c "source /usr/local/share/nvm/nvm.sh && npm install -g <your-package-here>" 2>&1