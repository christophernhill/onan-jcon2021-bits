# Bring image up to date
sudo apt update
sudo apt -y dist-upgrade

# Install CUDA drivers and toolkit
sudo wget -O /etc/apt/preferences.d/cuda-repository-pin-600 https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin
sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub
sudo add-apt-repository "deb http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/ /"

# Default
sudo apt install -y cuda

# Other versions
## sudo apt install -y cuda-10-2=10.2.89
## sudo apt install -y cuda-11-3=11.3.1
## sudo apt install -y cuda-11-4=11.4.0
## sudo apt install -y cuda-11-4=11.4.43

# Need to reboot to load new kernel driver
sudo reboot
