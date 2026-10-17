#!/usr/bin/env bash
# One-time server setup for deploys of the landing. Run once, as root:
#   - installs rsync (rrsync comes with it)
#   - user "landing": GitHub Actions logs in with its key, and that key can
#     only upload files into /var/www/stayintouch.site
#   - /var/www/stayintouch.site now belongs to that user
# Only adds things: nginx, the app, other users and their keys stay as they
# are. Safe to re-run.
#
# Usage: sudo bash bootstrap.sh <deploy-public-key-file>
set -euo pipefail

DEPLOY_USER=landing
SITE_DIR=/var/www/stayintouch.site
HERE=$(cd "$(dirname "$0")" && pwd)
LOG=$HERE/bootstrap.log

step() { printf '\n==> %s\n' "$*"; }
fail() { printf '!! %s\n' "$*" >&2; exit 1; }

[ "$(id -u)" -eq 0 ] || fail "Run with sudo: sudo bash $0 <deploy-public-key-file>"
pubkey_file=${1:?usage: sudo bash bootstrap.sh <deploy-public-key-file>}
pubkey=$(cat "$pubkey_file")
[[ $pubkey == ssh-ed25519\ * ]] || fail "Not an ed25519 public key: $pubkey_file"
[ -d "$SITE_DIR" ] || fail "$SITE_DIR not found: nginx serves the landing from there"

: > "$LOG"
[ -z "${SUDO_USER:-}" ] || chown "$SUDO_USER:" "$LOG"
exec > >(tee -a "$LOG") 2>&1
trap 'echo "!! FAILED at line $LINENO"' ERR

step "rsync"
if ! command -v rsync >/dev/null; then
  apt-get update
  DEBIAN_FRONTEND=noninteractive apt-get install -y rsync
fi
# sed, not head: head would quit early and fail the pipe under pipefail.
rsync --version | sed -n 1p
rrsync=$(command -v rrsync) || fail "rrsync not found: it should come with the rsync package"
echo "rrsync: $rrsync"

step "User $DEPLOY_USER"
id "$DEPLOY_USER" >/dev/null 2>&1 || useradd --create-home --shell /bin/bash "$DEPLOY_USER"
# No password at all: the only way in is the key.
usermod --password '*' "$DEPLOY_USER"
id "$DEPLOY_USER"

step "SSH key for GitHub Actions"
home=$(getent passwd "$DEPLOY_USER" | cut -d: -f6)
keys=$home/.ssh/authorized_keys
install -d -m 700 -o "$DEPLOY_USER" -g "$DEPLOY_USER" "$home/.ssh"
[ -e "$keys" ] || install -m 600 -o "$DEPLOY_USER" -g "$DEPLOY_USER" /dev/null "$keys"
# The key runs nothing but rrsync: upload-only into the site folder, no shell,
# no terminal, no forwarding; uploaded symlinks are made harmless (-munge).
grep -qF "$pubkey" "$keys" ||
  printf 'restrict,command="%s -wo -munge %s" %s\n' "$rrsync" "$SITE_DIR" "$pubkey" >> "$keys"
ssh-keygen -lf "$keys"

step "Site folder $SITE_DIR"
# Until now owned by crmapp; from here on only deploys write into it.
chown -R "$DEPLOY_USER:$DEPLOY_USER" "$SITE_DIR"
chmod 755 "$SITE_DIR"
ls -la "$SITE_DIR"

step "Server is ready for deploys"
