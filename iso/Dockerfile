FROM archlinux:base-devel

RUN sed -i '/^ParallelDownloads/a DisableSandbox' /etc/pacman.conf \
  && pacman -Syy --noconfirm archlinux-keyring \
  && pacman -Syu --noconfirm \
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
