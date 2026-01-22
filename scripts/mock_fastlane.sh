#!/usr/bin/env bash
set -euo pipefail

lane="${1:-release_all}"

log() {
  printf "mock-fastlane | %s\n" "$*"
}

step() {
  printf "\n==> %s\n" "$*"
}

check_file() {
  local path="$1"
  local label="$2"

  if [[ -n "$path" && -f "$path" ]]; then
    log "$label found at $path"
  else
    log "WARNING: $label missing at $path (mock continues)"
  fi
}

simulate_android() {
  step "ANDROID lane (android_release)"
  log "Reading track and metadata (mock)"
  log "Calculating versionCode and updating pubspec (mock)"
  log "flutter clean"
  log "flutter pub get"
  log "flutter build appbundle --release"
  check_file "${PLAY_STORE_JSON_PATH:-}" "Play Store JSON"
  log "Uploading AAB to Google Play (mock)"
  log "Backup artifacts to ./build/outputs (mock)"
}

simulate_ios() {
  step "IOS lane (ios_release)"
  log "Syncing App Store Connect key (mock)"
  check_file "${APP_STORE_CONNECT_KEY_PATH:-}" "App Store Connect key"
  log "Incrementing build number and updating pubspec (mock)"
  log "flutter clean"
  log "flutter pub get"
  log "flutter build ipa --release"
  log "Uploading IPA to App Store Connect (mock)"
  log "Backup artifacts to ./build/ios (mock)"
}

case "$lane" in
  android_release)
    simulate_android
    ;;
  ios_release)
    simulate_ios
    ;;
  release_all)
    simulate_android
    simulate_ios
    ;;
  *)
    log "Unknown lane: $lane"
    log "Available: android_release, ios_release, release_all"
    exit 1
    ;;
esac

step "Fastlane mock complete"
log "No real builds or uploads were performed."
log "end."
