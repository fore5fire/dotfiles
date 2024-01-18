#!/bin/sh

xdg-mime default org.qutebrowser.qutebrowser.desktop x-scheme-handler/http
xdg-mime default org.qutebrowser.qutebrowser.desktop x-scheme-handler/https

sudo rc-update add seatd default
sudo rc-update add dhcpcd default
sudo rc-update add iwd default
sudo rc-update add bluetooth default
sudo rc-update add sysklogd default

git config --global user.email "l@sturdyhippo.com"
git config --global user.name "Landon Smith"

// Install bass
mkdir -p ~/src
(cd ~/src; git clone https://github.com/edc/bass.git; cd bass; make install)

# Install vim plug
curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

sudo usermod -a -G pipewire -G netdev -G seat -G video -G audio -G seat l
