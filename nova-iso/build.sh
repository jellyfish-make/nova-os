#!/usr/bin/env bash
# Nova ISO - build script (da eseguire su Arch/EndeavourOS come utente con sudo)
set -euo pipefail
cd "$(dirname "$0")"
sudo pacman -S --needed --noconfirm archiso

sudo rm -rf profile work out
cp -r /usr/share/archiso/configs/releng profile

# --- profiledef: nome ISO, permessi extra
sed -i 's/^iso_name=.*/iso_name="nova"/; s/^iso_label=.*/iso_label="NOVA_$(date +%Y%m)"/' profile/profiledef.sh
sed -i 's|^file_permissions=(|file_permissions=(\n  ["/etc/shadow"]="0:0:400"\n  ["/etc/gshadow"]="0:0:400"\n  ["/etc/sudoers.d/10-live"]="0:0:440"\n  ["/home/live"]="1000:1000:750"\n  ["/home/live/.bash_profile"]="1000:1000:644"|' profile/profiledef.sh

# --- pacchetti e pacman.conf (aggiunge multilib per Steam/32 bit)
cp overlay/packages.x86_64 profile/packages.x86_64
cat >> profile/pacman.conf <<'PC'

[multilib]
Include = /etc/pacman.d/mirrorlist
PC

# --- kernel linux-zen al posto di linux: boot loader + preset
rm -f profile/airootfs/etc/mkinitcpio.d/linux.preset
rm -rf profile/airootfs/etc/systemd/system/*
grep -rlE 'vmlinuz-linux|initramfs-linux' profile/syslinux profile/grub profile/efiboot 2>/dev/null | \
  xargs sed -i 's/vmlinuz-linux/vmlinuz-linux-zen/g; s/initramfs-linux\.img/initramfs-linux-zen.img/g'

# --- utente live (aggiunto ai file esistenti, senza sovrascriverli)
echo 'live:x:1000:1000::/home/live:/bin/bash' >> profile/airootfs/etc/passwd
echo 'live::19000:0:99999:7:::'               >> profile/airootfs/etc/shadow
echo 'live:x:1000:'                           >> profile/airootfs/etc/group
echo 'live:!::'                               >> profile/airootfs/etc/gshadow

# --- overlay con le nostre configurazioni
cp -a overlay/airootfs/. profile/airootfs/

# abilita NetworkManager all'avvio
mkdir -p profile/airootfs/etc/systemd/system/multi-user.target.wants
ln -sf /usr/lib/systemd/system/NetworkManager.service profile/airootfs/etc/systemd/system/multi-user.target.wants/NetworkManager.service

sudo mkarchiso -v -w "$(pwd)/work" -o out profile
echo "ISO pronta in: $(pwd)/out"
