# Based on https://github.com/Gerharddc/verilator-devcontainer/blob/main/Dockerfile
# License of original in LICENSE.verilator-devcontainer

FROM ubuntu:noble

ARG VERILATOR_VERSION=v5.028
ARG VERIBLE_VERSION=v0.0-3798-ga602f072

# Install dependencies (mostly for verilator)
RUN apt-get -y update && apt-get install -y \
    git help2man perl python3 make autoconf g++ flex bison ccache gdb \
    libgoogle-perftools-dev numactl perl-doc \
    libfl2 libfl-dev \
    zlib1g zlib1g-dev \
    curl clang-format \
    gtkwave cmake \
    libspdlog-dev \
    zsh

# Fix git issues with the container running as root
RUN git config --global --add safe.directory '*'

# # Clone and build Verilator from source as to have the latest version
# RUN git clone https://github.com/verilator/verilator.git /tmp/verilator && \
#     cd /tmp/verilator && \
#     git checkout ${VERILATOR_VERSION} && \
#     autoconf && \
#     ./configure && \
#     make -j$(nproc) && \
#     make install && \
#     rm -rf /tmp/verilator

RUN apt-get -y update && apt-get install -y verilator

# Reference for setting up VSCode extension for Verible
# https://igorfreire.com.br/2023/06/18/vscode-setup-for-systemverilog-development/

# Install Verible to enhance the IDE experience
RUN curl -L -o verible.tar.gz https://github.com/chipsalliance/verible/releases/download/${VERIBLE_VERSION}/verible-${VERIBLE_VERSION}-linux-static-x86_64.tar.gz
RUN tar -xzf verible.tar.gz
RUN mv verible-${VERIBLE_VERSION}/bin/* /usr/local/bin/
RUN rm -rf verible.tar.gz verible-${VERIBLE_VERSION}

# Install neovim
RUN curl -sSL https://github.com/neovim/neovim/releases/download/v0.10.2/nvim-linux64.tar.gz | tar xz -C /usr/local && ln -sf /usr/local/nvim-linux64/bin/nvim /usr/local/bin

USER ubuntu
