FROM debian:10.4

RUN apt-get update && \
    apt-get install --no-install-recommends -y wget=1.20.1-1.1 unzip=6.0-23+deb10u1 ca-certificates=20190110 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
RUN useradd -ms /bin/bash terraria
RUN mkdir /world && chown terraria:terraria /world

USER terraria
WORKDIR /home/terraria

# https://terraria.gamepedia.com/Server#Downloads
ARG DOWNLOAD_LINK=https://www.terraria.org/system/dedicated_servers/archives/000/000/038/original/terraria-server-1404.zip?1590253816
RUN wget --quiet -O /tmp/terraria-server.zip "${DOWNLOAD_LINK}" && \
  unzip -qq /tmp/terraria-server.zip -d terraria-server && \
  rm /tmp/terraria-server.zip && \
  mv terraria-server/*/Linux ./ && \
  rm -rf terraria-server && \
  chmod +x ./Linux/TerrariaServer.bin.x86* && \
  mkdir -p /home/terraria/.local/share/Terraria && \
  ln -s /world /home/terraria/.local/share/Terraria/Worlds

VOLUME /world
EXPOSE 7777

WORKDIR /home/terraria/Linux
ENTRYPOINT ["./TerrariaServer.bin.x86_64"]
