FROM ubuntu:20.04

ARG MPLABX_VERSION=5.45
ARG XC8_VERSION=1.34
ARG USERNAME=mplab
ARG USER_UID=1000
ARG USER_GID=$USER_UID

USER root

# Install the dependencies
# See https://microchipdeveloper.com/install:mplabx-lin64
RUN dpkg --add-architecture i386 \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    libc6:i386 \
    libx11-6:i386 \
    libxext6:i386 \
    libstdc++6:i386 \
    libexpat1:i386 \
    ca-certificates \
    make \
    sudo \
    wget \
  && apt-get clean \
  && apt-get autoremove \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp

# Download and install XC8
RUN wget -nv -O /tmp/xc8 "https://ww1.microchip.com/downloads/en/DeviceDoc/xc8-v${XC8_VERSION}-full-install-linux-installer.run" \
  && chmod +x /tmp/xc8 \
  && /tmp/xc8 --mode unattended --unattendedmodeui none --netservername localhost --LicenseType FreeMode --prefix "/opt/microchip/xc8/v${XC8_VERSION}" \
  && rm /tmp/xc8

# Download and install MPLAB X
# hadolint ignore=DL3004
RUN wget -nv -O /tmp/mplabx "https://ww1.microchip.com/downloads/en/DeviceDoc/MPLABX-v${MPLABX_VERSION}-linux-installer.tar" \
  && tar -xf mplabx \
  && rm mplabx \
  && mv "MPLABX-v${MPLABX_VERSION}-linux-installer.sh" mplabx \
  && sudo ./mplabx --nox11 -- --unattendedmodeui none --mode unattended --ipe 0 --collectInfo 0 --installdir /opt/mplabx --16bitmcu 0 --32bitmcu 0 --othermcu 0 \
  && rm mplabx

COPY build.sh /build.sh

WORKDIR /app

# Add application (non-root) user and group
RUN groupadd --gid "${USER_GID}" "${USERNAME}" \
    && useradd --uid "${USER_UID}" --gid "${USER_GID}" -m "${USERNAME}" \
    && chown -R "${USER_UID}:${USER_GID}" /app /build.sh

USER $USERNAME

ENTRYPOINT [ "/build.sh" ]
