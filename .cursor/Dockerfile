FROM ubuntu:24.04

ARG FLUTTER_VERSION=3.32.4

ENV FLUTTER_VERSION=$FLUTTER_VERSION

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

RUN id -u ubuntu >/dev/null 2>&1 || useradd -m -s /bin/bash ubuntu && \
    echo 'ubuntu ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN curl -o flutter.tar.xz https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_$FLUTTER_VERSION-stable.tar.xz \
    && mkdir -p /usr/local/flutter \
    && tar -xf flutter.tar.xz -C /usr/local/flutter --strip-components=1 \
    && rm flutter.tar.xz

RUN chown -R ubuntu:ubuntu /usr/local/flutter

ENV PATH="/usr/local/flutter/bin:$PATH"

USER ubuntu

WORKDIR /home/ubuntu

RUN mkdir -p /home/ubuntu/.pub-cache

RUN git config --global init.defaultBranch main && \
    git config --global --add safe.directory /usr/local/flutter

RUN flutter doctor --android-licenses || true && flutter doctor || true

RUN flutter pub global activate katana_cli

ENV PATH="$PATH:/home/ubuntu/.pub-cache/bin"

RUN flutter --version || echo "Setup complete"

CMD ["/bin/bash"]
