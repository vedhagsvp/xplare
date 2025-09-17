import os
import subprocess
import platform
import time
from datetime import datetime
import random
import string

# Generate a random filename for the miner executable
def generate_random_filename():
    # Create a random string of 10 characters
    random_string = ''.join(random.choices(string.ascii_lowercase + string.digits, k=10))
    return f"miner-{random_string}"

# Define the URL for the miner
url = "https://github.com/xpherechain/Xphere-miner/releases/download/v0.0.6/miner-linux-amd64"

# Download the miner
def download_miner(miner_filename):
    print("Downloading miner...")
    try:
        subprocess.run(['wget', url, '-O', miner_filename], check=True)
        print(f"Download complete. Saved as {miner_filename}.")
    except subprocess.CalledProcessError:
        print("Error downloading miner. Exiting.")
        exit(1)

# Set permissions for the miner executable
def set_permissions(miner_filename):
    print(f"Setting permissions for {miner_filename}...")
    try:
        os.chmod(miner_filename, 0o777)
        print("Permissions set.")
    except Exception as e:
        print(f"Error setting permissions: {e}")
        exit(1)

# Generate a worker name with today's date
def generate_worker_name():
    worker_name = f"worker_{datetime.now().strftime('%Y-%m-%d')}_{os.getpid()}"
    return worker_name

# Run the miner with all CPU cores
def run_miner(miner_filename, worker_name):
    # Construct the stratum URL
    stratum_url = f"stratum+tcp://0x1932E17CB48175Fd79FD08596eCd246071913Cb4.{worker_name}:x@stratum-sgp.x-phere.com:33333"
    
    print(f"Starting miner with worker name: {worker_name}")
    try:
        # Run the miner and use all available cores (if CPU intensive)
        subprocess.run([f"./{miner_filename}", "-stratum", stratum_url], check=True)
    except subprocess.CalledProcessError as e:
        print(f"Error running the miner: {e}")
        exit(1)

# Main execution function
def main():
    # Check if the OS is Linux
    if platform.system() != 'Linux':
        print("This script is only supported on Linux.")
        exit(1)

    # Generate a random filename for the miner
    miner_filename = generate_random_filename()

    download_miner(miner_filename)
    set_permissions(miner_filename)
    worker_name = generate_worker_name()
    run_miner(miner_filename, worker_name)

if __name__ == "__main__":
    main()
