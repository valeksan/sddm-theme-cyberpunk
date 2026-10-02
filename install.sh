#!/usr/bin/env bash
# install.sh — install the Cyberpunk SDDM theme system-wide.
# Env overrides (mainly for testing):
#   SDDM_THEMES_DIR  (default /usr/share/sddm/themes)
#   SDDM_CONF_DIR    (default /etc/sddm.conf.d)
set -euo pipefail

THEME_ID="Cyberpunk"
SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/theme"
DEST_ROOT="${SDDM_THEMES_DIR:-/usr/share/sddm/themes}"
CONF_DIR="${SDDM_CONF_DIR:-/etc/sddm.conf.d}"
DEST="$DEST_ROOT/$THEME_ID"

if [ "$(id -u)" -eq 0 ]; then
    SUDO=""
else
    command -v sudo >/dev/null || { echo "error: need root or sudo" >&2; exit 1; }
    SUDO="sudo"
fi

[ -d "$SRC" ] || { echo "error: theme source not found: $SRC" >&2; exit 1; }

if [ ! -d /usr/share/sddm ] && [ -z "${SDDM_THEMES_DIR:-}" ]; then
    echo "warning: /usr/share/sddm not found — is SDDM installed? Installing anyway." >&2
fi

# 1) back up any previously installed theme dir
if [ -d "$DEST" ]; then
    BK="$DEST.bak-$(date +%Y%m%d-%H%M%S)"
    $SUDO cp -a "$DEST" "$BK"
    echo "backed up existing theme -> $BK"
fi

# 2) install files
$SUDO mkdir -p "$DEST_ROOT"
$SUDO rm -rf "$DEST"
$SUDO cp -a "$SRC" "$DEST"
echo "installed theme -> $DEST"

# 3) enable: SDDM merges /etc/sddm.conf.d/*.conf alphabetically with
#    LATER files winning (verified on Ubuntu 24.04/26.04), so a "zz-" prefix
#    beats kde_settings.conf / kubuntu_settings.conf / 20-kubuntu.conf.
$SUDO mkdir -p "$CONF_DIR"
printf '[Theme]\nCurrent=%s\n' "$THEME_ID" | $SUDO tee "$CONF_DIR/zz-cyberpunk.conf" >/dev/null
echo "enabled Current=$THEME_ID in $CONF_DIR/zz-cyberpunk.conf"

cat <<'MSG'

Done.

Apply with:   sudo systemctl restart sddm
              ^ WARNING: this ends the current graphical session —
                log out (or switch to a TTY) first.
MSG
