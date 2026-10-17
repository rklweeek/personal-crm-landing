#!/usr/bin/env bash
# Runs on the GitHub Actions runner: uploads the built site to the server.
# The key there only allows rsync into the landing folder (see bootstrap.sh),
# so "user@host:" below already means /var/www/stayintouch.site.
# Usage: sync.sh <dir>
# Env:   DEPLOY_HOST, DEPLOY_USER, DEPLOY_SSH_KEY, DEPLOY_KNOWN_HOSTS
set -euo pipefail

src=${1:?usage: sync.sh <dir>}
: "${DEPLOY_HOST:?}" "${DEPLOY_USER:?}" "${DEPLOY_SSH_KEY:?}" "${DEPLOY_KNOWN_HOSTS:?}"
# --delete below would empty the site if the build went missing.
[ -f "$src/index.html" ] || { echo "!! $src/index.html not found, nothing uploaded" >&2; exit 1; }

ssh_dir=$(mktemp -d)
trap 'rm -rf "$ssh_dir"' EXIT
(
  umask 077
  printf '%s\n' "$DEPLOY_SSH_KEY" > "$ssh_dir/key"
  printf '%s\n' "$DEPLOY_KNOWN_HOSTS" > "$ssh_dir/known_hosts"
)

echo "Uploading $src/ to $DEPLOY_HOST"
# --delay-updates: changed files are swapped in together at the end,
# --delete-delay: then files that are not in the new build are removed.
rsync --recursive --times --perms --chmod=D755,F644 \
  --delete-delay --delay-updates --itemize-changes --stats \
  -e "ssh -i $ssh_dir/key -o IdentitiesOnly=yes -o BatchMode=yes -o StrictHostKeyChecking=yes -o UserKnownHostsFile=$ssh_dir/known_hosts" \
  "$src/" "$DEPLOY_USER@$DEPLOY_HOST:"
