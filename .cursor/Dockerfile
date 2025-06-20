FROM ubuntu:24.04

ARG FLUTTER_VERSION=3.32.4

ENV FLUTTER_VERSION=$FLUTTER_VERSION

# 基本的な開発ツールのインストール
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    wget \
    software-properties-common \
    build-essential \
    sudo \
    vim \
    nano \
    && rm -rf /var/lib/apt/lists/*

# 非rootユーザーの作成
RUN useradd -m -s /bin/bash ubuntu && \
    echo 'ubuntu ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Flutterのインストール
RUN curl -o flutter.tar.xz https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_$FLUTTER_VERSION-stable.tar.xz \
    && mkdir -p /usr/local/flutter \
    && tar -xf flutter.tar.xz -C /usr/local/flutter --strip-components=1 \
    && git config --global --add safe.directory /usr/local/flutter \
    && rm flutter.tar.xz

# PATHの設定
ENV PATH="/usr/local/flutter/bin:$PATH"

# Flutterの初期設定
RUN flutter doctor --android-licenses || true && flutter doctor || true

# Katana CLIのインストール
RUN flutter pub global activate katana_cli

# グローバルパッケージのPATH追加
ENV PATH="$PATH:/home/ubuntu/.pub-cache/bin"

# ubuntuユーザーに切り替え
USER ubuntu

# ワークディレクトリの設定
WORKDIR /home/ubuntu

# .pub-cacheディレクトリの所有権設定
RUN mkdir -p /home/ubuntu/.pub-cache

# Gitの基本設定
RUN git config --global init.defaultBranch main

# 動作確認
RUN flutter --version && katana --version || echo "Setup complete"

CMD ["/bin/bash"]
