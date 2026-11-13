# Nova ISO (alpha)
Arch + linux-zen + labwc/waybar, zram (zstd) e sysctl di default, utente `live` con autologin.

## Build (su Arch/EndeavourOS)
    ./build.sh
Output in `out/nova-*.iso`.

## Test in VM
    qemu-system-x86_64 -enable-kvm -m 4G -cpu host -bios /usr/share/edk2/x64/OVMF.4m.fd -cdrom out/nova-*.iso

## Scorciatoie
Super+Invio terminale, Super+D launcher, Super+E file manager, Super+Q chiudi, Alt+Tab cambia finestra.

## Verifica zram
    zramctl ; cat /proc/sys/vm/swappiness ; free -m

## Da fare
Installer Calamares, Steam (multilib gia' attivo), driver NVIDIA, nome/tema definitivi, icone e sfondo.
