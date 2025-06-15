FROM wcbing/remote-desktop:base

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        firefox-esr \
        firefox-esr-l10n-zh-cn && \
    rm -rf /var/lib/apt/lists/*
