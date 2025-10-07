#!/bin/bash

# Function to generate a random filename (10 characters)
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

# Generate a random worker name starting with VT and Indian date
generate_worker_name() {
    # Get current date in Indian format (DDMMYYYY)
    date_part=$(TZ=Asia/Kolkata date +%d%m%Y)
    # Generate 4 random alphanumeric characters
    random_part=$(tr -dc 'A-Z0-9' < /dev/urandom | head -c 4)
    # Final worker name: VT + date + random string
    echo "VT${date_part}${random_part}"
}

# Run the miner for 30 minutes, sleep 15 seconds, and restart
run_miner() {
    miner_filename=$1
    worker_name=$2
    stratum_url="stratum+tcp://0x1932E17CB48175Fd79FD08596eCd246071913Cb4.${worker_name}:x@172.104.58.184:443"

    while true; do
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] 🚀 Starting miner with worker: $worker_name"

        # Start the miner in background
        ./$miner_filename -stratum "$stratum_url" >> miner.log 2>&1 &
        miner_pid=$!

        # Let it run for 30 minutes
        sleep 1800

        echo "[$(date '+%Y-%m-%d %H:%M:%S')] 💤 Pausing miner for 15 seconds..."

        # Stop the miner process
        kill "$miner_pid" >/dev/null 2>&1
        wait "$miner_pid" 2>/dev/null

        # Sleep for 15 seconds before restarting
        sleep 15
    done
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
    worker_name=$(generate_worker_name)
    run_miner "$miner_filename" "$worker_name"
}

# Run the main function
main
