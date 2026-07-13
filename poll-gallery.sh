#!/usr/bin/env bash
# Poll https://pi.dev/packages until pi-live-theme is indexed, then
# auto-submit to Hacker News and send a macOS notification.
# Usage: ./poll-gallery.sh [interval_seconds] [max_attempts]

set -euo pipefail

INTERVAL="${1:-120}"
MAX_ATTEMPTS="${2:-180}"

if [[ -z "${HN_USER:-}" ]] || [[ -z "${HN_PASS:-}" ]]; then
  echo "Set HN_USER and HN_PASS environment variables." >&2
  exit 1
fi

HN_USER="${HN_USER}"
HN_PASS="${HN_PASS}"
GALLERY_URL="https://pi.dev/packages/pi-live-theme"
POLL_URL="https://pi.dev/packages?name=pi-live-theme"
HN_TITLE="Show HN: pi-live-theme — live theme preview for pi coding agent"
COOKIE_JAR="/tmp/hn-cookies-$$.txt"

cleanup() { rm -f "$COOKIE_JAR"; }
trap cleanup EXIT

log() { echo "[$(date '+%H:%M:%S')] $*"; }

submit_to_hn() {
  local login_fnid submit_fnid encoded_url

  log "Logging into Hacker News..."

  # Step 1: get the login page to extract the anti-CSRF fnid
  login_fnid=$(curl -sc "$COOKIE_JAR" -b "$COOKIE_JAR" \
    "https://news.ycombinator.com/login" 2>/dev/null \
    | sed -n 's/.*name="fnid" value="\([^"]*\)".*/\1/p')

  if [[ -z "$login_fnid" ]]; then
    log "ERROR: could not extract login fnid"
    return 1
  fi

  # Step 2: POST login credentials
  curl -sc "$COOKIE_JAR" -b "$COOKIE_JAR" -L \
    -d "fnid=${login_fnid}&acct=${HN_USER}&pw=${HN_PASS}&creating=t&goto=news" \
    "https://news.ycombinator.com/login" >/dev/null 2>&1

  if ! grep -q "user" "$COOKIE_JAR" 2>/dev/null; then
    log "ERROR: login failed (no user cookie)"
    return 1
  fi

  log "Logged in as $HN_USER."

  # Step 3: get the submit form and extract its fnid
  encoded_url=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$GALLERY_URL'))")
  encoded_title=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$HN_TITLE'))")

  submit_fnid=$(curl -sc "$COOKIE_JAR" -b "$COOKIE_JAR" \
    "https://news.ycombinator.com/submitlink?u=${encoded_url}&t=${encoded_title}" 2>/dev/null \
    | sed -n 's/.*name="fnid" value="\([^"]*\)".*/\1/p')

  if [[ -z "$submit_fnid" ]]; then
    log "ERROR: could not extract submit fnid (already submitted?)"
    return 1
  fi

  # Step 4: POST the submission
  curl -sc "$COOKIE_JAR" -b "$COOKIE_JAR" \
    -d "fnid=${submit_fnid}&u=${encoded_url}&t=${encoded_title}" \
    "https://news.ycombinator.com/r" >/dev/null 2>&1

  log "✅ Submitted to Hacker News!"
}

for ((attempt=1; attempt<=MAX_ATTEMPTS; attempt++)); do
  log "Check #$attempt..."

  if curl -sf "$POLL_URL" 2>/dev/null | grep -qv "No packages match"; then
    log "🎉 pi-live-theme found in the gallery!"
    osascript -e "display notification \"pi-live-theme indexed — submitting to HN\" with title \"Gallery Indexed\" sound name \"Glass\""

    if submit_to_hn; then
      osascript -e "display notification \"pi-live-theme submitted to Hacker News\" with title \"HN Submitted\" sound name \"Glass\""
    else
      log "HN submission failed — check errors above"
      osascript -e "display notification \"HN submission failed (see terminal)\" with title \"Gallery Indexed\" sound name \"Basso\""
    fi

    open "$GALLERY_URL"
    exit 0
  fi

  log "Not yet indexed. Waiting ${INTERVAL}s..."
  sleep "$INTERVAL"
done

log "Gave up after $MAX_ATTEMPTS attempts."
osascript -e "display notification \"pi-live-theme still not indexed after $((MAX_ATTEMPTS * INTERVAL / 60)) min\" with title \"Gallery Timeout\" sound name \"Basso\""
exit 1
