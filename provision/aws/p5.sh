# Create spack bits
cd ~ 
git clone https://github.com/spack/spack.git
cd spack.git
. share/spack/setup-env.sh
sudo apt-get install gfortran.    # OpenMPI needs Fortran compiler too by default
sudo apt-get install libssl-dev   # Needed by libevent
spack compier list
spack external find
spack install openmpi +cuda
