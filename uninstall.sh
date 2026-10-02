#!/usr/bin/env bash
# uninstall.sh — remove the Cyberpunk SDDM theme and the config that enables it.
# Timestamped backups created by install.sh (Cyberpunk.bak-*) are left in place.
set -euo pipefail

THEME_ID="Cyberpunk"
DEST_ROOT="${SDDM_THEMES_DIR:-/usr/share/sddm/themes}"
CONF_DIR="${SDDM_CONF_DIR:-/etc/sddm.conf.d}"

if [ "$(id -u)" -eq 0 ]; then
    SUDO=""
else
    command -v sudo >/dev/null || { echo "error: need root or sudo" >&2; exit 1; }
    SUDO="sudo"
fi

if [ -d "$DEST_ROOT/$THEME_ID" ]; then
    $SUDO rm -rf "$DEST_ROOT/$THEME_ID"
    echo "removed $DEST_ROOT/$THEME_ID"
else
    echo "theme dir not found (already removed?)"
fi

if [ -f "$CONF_DIR/zz-cyberpunk.conf" ]; then
    $SUDO rm -f "$CONF_DIR/zz-cyberpunk.conf"
    echo "removed $CONF_DIR/zz-cyberpunk.conf"
else
    echo "enable-config not found (already removed?)"
fi

echo
echo "Backups (Cyberpunk.bak-*) under $DEST_ROOT were kept."
echo "Apply with: sudo systemctl restart sddm (ends the current session!)"
