# Create spack bits
cd ~ 
git clone https://github.com/spack/spack.git
cd spack.git
. share/spack/setup-env.sh
spack compier list
spack install openmpi +cuda
