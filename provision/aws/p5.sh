# Create spack bits
cd ~ 
git clone https://github.com/spack/spack.git
cd spack.git
. share/spack/setup-env.sh
sudo apt-get install gfortran
spack compier list
spack external find
spack install openmpi +cuda
