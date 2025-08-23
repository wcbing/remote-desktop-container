ARG TAG=13

# Build xrdp pulseaudio modules
# https://github.com/scottyhardy/docker-remote-desktop/blob/master/Dockerfile
FROM debian:$TAG AS pulseaudio_builder

RUN sed -i 's/deb.debian.org/mirrors.cernet.edu.cn/g' /etc/apt/sources.list.d/debian.sources && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        autoconf \
        build-essential \
        ca-certificates \
        dpkg-dev \
        libpulse-dev \
        lsb-release \
        git \
        libtool \
        libltdl-dev \
        sudo \
        doxygen && \
    rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/neutrinolabs/pulseaudio-module-xrdp.git /pulseaudio-module-xrdp
WORKDIR /pulseaudio-module-xrdp
RUN scripts/install_pulseaudio_sources_apt.sh && \
    ./bootstrap && \
    ./configure PULSE_DIR=$HOME/pulseaudio.src && \
    make && \
    make install DESTDIR=/tmp/install


FROM debian:$TAG

RUN sed -i 's/deb.debian.org/mirrors.cernet.edu.cn/g' /etc/apt/sources.list.d/debian.sources && \
    apt-get update && apt-get install -y ca-certificates && \
    sed -i 's/http/https/g' /etc/apt/sources.list.d/debian.sources && \
    apt-get update && apt-get install -y --no-install-recommends \
        locales \
        sudo \
        xfce4 \
        xfce4-terminal \
        adwaita-icon-theme-legacy \
        desktop-base \
        dbus-x11 \
        xorgxrdp \
        xrdp \
        pulseaudio \
        pavucontrol \
        firefox-esr \
        firefox-esr-l10n-zh-cn \
        fonts-noto-cjk \
        curl \
        vim && \
    rm -rf /var/lib/apt/lists/* && \
    # Locale setting
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo 'Asia/Shanghai' > /etc/timezone && \
    echo 'zh_CN.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen && \
    echo 'LANG=zh_CN.UTF-8' > /etc/default/locale

RUN sed -i 's/^WebBrowser.*/WebBrowser=firefox/g' /etc/xdg/xfce4/helpers.rc
# Custom UI (only bottom panel)
COPY Xfce/xfce4-panel.xml /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/

# xrdp PulseAudio
COPY --from=pulseaudio_builder /tmp/install /
RUN sed -i 's|^Exec=.*|Exec=/usr/bin/pulseaudio|' /etc/xdg/autostart/pulseaudio-xrdp.desktop

COPY entrypoint.sh /usr/bin
ENTRYPOINT ["/usr/bin/entrypoint.sh"]

EXPOSE 3389
