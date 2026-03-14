FROM archlinux:base-devel

RUN pacman -Syu --noconfirm \
  archiso \
  git \
  rsync \
  jq \
  curl \
  dosfstools \
  grub \
  libisoburn \
  mtools \
  squashfs-tools \
  xorriso \
  && pacman -Scc --noconfirm

WORKDIR /workspace
