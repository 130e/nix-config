#!/usr/bin/env bash

# Array of Extension IDs to download
EXTENSION_IDs=(
    "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
    "dbepggeogbaibhgnhhndojpepiihcmeb" # Vimium
    # "eimadpbcbfnmbkopoojfekhnkhdbieeh" # Dark Reader
    "pkehgijcmpdhfbdbbnkijodmdjhbjlgp" # Privacy Badger
)
BROWSER_VERSION="129.0"

# Loop over the Extension IDs
for ID in "${EXTENSION_IDs[@]}"; do
    # Construct the download URL
    url="https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=${BROWSER_VERSION}&x=id%3D${ID}%26installsource%3Dondemand%26uc"

    # Download the file using wget, save it as the extension ID
    wget -q "$url" -O "${ID}.crx"

    if [ $? -eq 0 ]; then
        # Calculate the SHA256 checksum and print it
        sha256sum "$ID"
    else
        echo "Failed to download $url"
    fi
done
