# Create spack bits
cd ~ 
sudo apt-get install -y python3-dev
git clone https://github.com/spack/spack.git
cd spack.git
. share/spack/setup-env.sh
sudo apt-get install -y gfortran.    # OpenMPI needs Fortran compiler too by default
sudo apt-get install -y libssl-dev   # Needed by libevent
sudo apt-get install -y python3-dev  # Needed by rdma
spack compiler list
spack external find
spack install openmpi +cuda
bin/spack install openmpi '~atomics+cuda~cxx~cxx_exceptions+gpfs~internal-hwloc~java~legacylaunchers~lustre~memchecker~pmi~singularity~sqlite3+static+thread_multiple+vt+wrapper-rpath' fabrics=ucx schedulers=none

apt install -y lmod
source /etc/profile.d/lmod.sh
spack module lmod refresh -y
# Configureing JUlia for MPI
# # To set up MPI may need
# /home/ubuntu/projects/julia-1.6.1/bin/julia -e 'using Libdl; p=dlopen("libmpi", RTLD_LAZY; throw_error=false); p=dlopen("libmpi", RTLD_LAZY; throw_error=false); using Pkg; Pkg.build("MPI"; verbose=true)'

