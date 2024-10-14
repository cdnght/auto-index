#!/bin/bash

# Fungsi untuk memvalidasi URL
validate_url() {
  if ! [[ "$1" =~ ^(https?://)([0-9A-Za-z_-]+)(\.[0-9A-Za-z_-]+)+(/.*)?$ ]]; then
    echo "URL tidak valid: $1"
    exit 1
  fi
}

# Memeriksa apakah URL diberikan sebagai argumen
if [ "$#" -ne 1 ]; then
  echo "Penggunaan: $0 <URL>"
  exit 1
fi

# Mengambil URL dari argumen dan memvalidasi
URL="$1"
validate_url "$URL"

# Set interval antara permintaan (dalam detik)
INTERVAL=300
# Set durasi total (dalam detik)
DURATION=86400
# File log
LOG_FILE="indexing.log"

# Menghitung jumlah permintaan
REQUESTS=$(($DURATION / $INTERVAL))

# Melakukan loop melalui permintaan
for ((i=0; i<$REQUESTS; i++)); do
  # Mengirim permintaan GET ke URL artikel dan log ke file
  curl -s -o /dev/null -w "%{http_code}\n" "$URL" >> "$LOG_FILE" 2>&1

  # Menunggu selama interval
  sleep $INTERVAL
done
