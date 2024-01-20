#!/bin/sh

xdg-mime default org.qutebrowser.qutebrowser.desktop x-scheme-handler/http
xdg-mime default org.qutebrowser.qutebrowser.desktop x-scheme-handler/https

sudo rc-update add acpid default
sudo rc-update add seatd default
sudo rc-update add dhcpcd default
sudo rc-update add iwd default
sudo rc-update add bluetooth default
sudo rc-update add sysklogd default
sudo rc-update add ntpd default

# Install bass
mkdir -p ~/src
(cd ~/src; git clone https://github.com/edc/bass.git; cd bass; make install)

# Install vim plug
curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

sudo usermod -a -G pipewire -G netdev -G seat -G video -G audio -G seat -G plugdev l

# Add system specific cpu flags
echo "*/* $(cpuid2cpuflags)" > /etc/portage/package.use/00cpu-flags

# Build and install kernel
make -j16 && make modules_install && make install && cp /efi/efi/gentoo/linuz-signed{,-backup}.efi && cp /boot/vmlinuz-6.6.9-gentoo /efi/efi/gentoo/linuz-signed.efi

# Add efi boot entry
sudo efibootmgr  --create --disk /dev/nvme0n1 --part 1 --label "gentoo resume" --loader "/efi/gentoo/linuz-signed.efi" --unicode log_buf_len=1M apic=verbose try-resume

# Upload hardware probe
hw-probe -all -upload
