# Avvia il desktop solo sulla tty1
if [ -z "$WAYLAND_DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
  export XDG_SESSION_TYPE=wayland XDG_CURRENT_DESKTOP=labwc
  exec dbus-run-session labwc
fi
