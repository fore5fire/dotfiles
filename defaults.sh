#!/bin/sh

xdg-mime default org.qutebrowser.qutebrowser.desktop x-scheme-handler/http
xdg-mime default org.qutebrowser.qutebrowser.desktop x-scheme-handler/https

sudo usermod -a -G pipewire -G netdev -G seat -G video -G audio l
