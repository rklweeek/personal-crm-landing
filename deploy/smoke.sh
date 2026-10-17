#!/usr/bin/env bash
# Smoke test after a deploy: the home page must answer HTTP 200 with exactly
# the page from this build, and /version.txt must name this commit.
# Usage: smoke.sh <site-url> <built-index.html> <version>
set -euo pipefail

url=${1:?usage: smoke.sh <site-url> <built-index.html> <version>}
url=${url%/}
index=${2:?usage: smoke.sh <site-url> <built-index.html> <version>}
version=${3:?usage: smoke.sh <site-url> <built-index.html> <version>}

built=$(sha256sum < "$index" | cut -d' ' -f1)
page=$(mktemp)
trap 'rm -f "$page"' EXIT

for attempt in 1 2 3 4 5 6; do
  code=$(curl --silent --show-error --max-time 10 --output "$page" --write-out '%{http_code}' "$url/") ||
    code=000
  served=$(sha256sum < "$page" | cut -d' ' -f1)
  live=$(curl --silent --show-error --fail --max-time 10 "$url/version.txt") || live=""
  echo "GET $url/ -> HTTP $code, page sha256 $served (built $built), version.txt: ${live:-none}"

  if [ "$code" = 200 ] && [ "$served" = "$built" ] && [ "$live" = "$version" ]; then
    echo "Smoke test passed"
    exit 0
  fi
  [ "$attempt" = 6 ] || sleep 5
done

echo "!! Smoke test failed: the site does not answer with the new version. Nothing was rolled back." >&2
exit 1
