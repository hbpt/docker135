FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /chromium
RUN echo "deb-src http://deb.debian.org/debian bookworm main" > /etc/apt/sources.list \
    && apt-get update \
    && apt install build-essential devscripts equivs git -y \
    && apt source chromium \
    && mv chromium-* src && cd src \
    && mk-build-deps -i -r -t "apt-get -y" debian/control \
    && (DEB_BUILD_OPTIONS="parallel=64" debuild -us -uc -b) || true \
    && apt-get clean && rm -rf /var/lib/apt/lists/* \
    && rm -rf ../chromium* && rm -rf ../*.deb \
    && find out/Release/ -type f -size +160M  -exec rm {} \;

WORKDIR /chromium/src
CMD ["/bin/bash"]
