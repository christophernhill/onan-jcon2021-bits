# Create spack bits
cd ~ 
git clone https://github.com/spack/spack.git
cd spack.git
. share/spack/setup-env.sh
sudo apt-get install gfortran.    # OpenMPI needs Fortran compiler too by default
sudo apt-get install libssl-dev   # Needed by libevent
spack compiler list
spack external find
spack install openmpi +cuda
bin/spack install openmpi '~atomics+cuda~cxx~cxx_exceptions+gpfs~internal-hwloc~java~legacylaunchers~lustre~memchecker~pmi~singularity~sqlite3+static+thread_multiple+vt+wrapper-rpath' fabrics=ucx schedulers=none

# Configureing JUlia for MPI
# # To set up MPI may need
# /home/ubuntu/projects/julia-1.6.1/bin/julia -e 'using Libdl; p=dlopen("libmpi", RTLD_LAZY; throw_error=false); p=dlopen("libmpi", RTLD_LAZY; throw_error=false); using Pkg; Pkg.build("MPI"; verbose=true)'

