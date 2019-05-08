#!/bin/bash

# Enable nonfree repo for NVIDIA drivers
#xbps-install -Sy void-repo-nonfree
# XXX: Not installing nvidia because it breaks scdaemon/gpg in initramfs

xbps-install -Sy \
  compton redshift scrot transset xbacklight xclip xdg-utils xdotool \
  xf86-video-intel xhost xinput xfontsel xmessage xorg-fonts xorg-minimal \
  xprop xrandr xrdb xsel xset xsetroot xterm xtitle xwinwrap \
|| true

# Blacklist nouveau driver since it causes kernel panic
sed -i 's:\(^GRUB_CMDLINE_LINUX.*\)"$:\1 modprobe.blacklist=nouveau":' /etc/default/grub

# Make surf the default web browser
if [ -n "${USERACCT}" ]; then
  install -o "$USERACCT" -g "$USERACCT" -Dm755 \
    /tmp/custom/files/www /home/${USERACCT}/.local/bin/www
  install -o "$USERACCT" -g "$USERACCT" -Dm644 \
    /tmp/custom/files/www.desktop /home/${USERACCT}/.local/share/applications/www.desktop
  chown -R ${USERACCT}: /home/${USERACCT}/.local
  su - "${USERACCT}" bash -c \
    'mkdir -p ~/.config; PATH=$HOME/.local/bin:$PATH xdg-settings set default-web-browser www.desktop'
fi
