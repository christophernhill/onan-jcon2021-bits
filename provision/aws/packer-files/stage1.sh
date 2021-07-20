# Create spack bits
cd ~ 
sudo apt-get install -y python3-dev python3-docutils
git clone https://github.com/spack/spack.git
cd spack
. share/spack/setup-env.sh
sudo apt-get install -y gfortran     # OpenMPI needs Fortran compiler too by default
sudo apt-get install -y libssl-dev   # Needed by libevent
sudo apt-get install -y python3-dev  # Needed by rdma
sudo apt install -y unzip
sudo apt install -y make
sudo apt install -y g++
spack compiler list
export PATH=/usr/local/cuda/bin:$PATH
spack external find
# Install fabrics=none and fabrics=ucx variants
spack install openmpi +cuda
bin/spack install openmpi '~atomics+cuda~cxx~cxx_exceptions+gpfs~internal-hwloc~java~legacylaunchers~lustre~memchecker~pmi~singularity~sqlite3+static+thread_multiple+vt+wrapper-rpath' fabrics=ucx schedulers=none

sudo apt install -y lmod
source /etc/profile.d/lmod.sh
spack module lmod refresh -y
# Add Julia
mkdir ~/projects
cd ~/projects
wget https://julialang-s3.julialang.org/bin/linux/x64/1.6/julia-1.6.1-linux-x86_64.tar.gz
tar -xzvf julia-1.6.1-linux-x86_64.tar.gz


# Setup Oceananigans.jl
cd ~/projects
alias julia=~/projects/julia-1.6.1/bin/julia 
git clone https://github.com/clima/Oceananigans.jl
cd Oceananigans.jl
export JULIA_DEPOT_PATH=`pwd`/.julia

# Configureing JUlia for MPI
# # To set up MPI may need
source /etc/profile.d/lmod.sh 
module use /home/ubuntu/spack/share/spack/lmod/linux-ubuntu20.04-x86_64/Core
module load openmpi
J1=`which mpicc`
JMP=`dirname $J1 |  sed s'/\(.*\)\/bin/\1/'`
export JULIA_MPI_PATH=${JMP}
export UCX_ERROR_SIGNALS="SIGILL,SIGBUS,SIGFPE"  # Needed on Power 9
julia --project=. -e 'using Libdl; p=dlopen("libmpi", RTLD_LAZY; throw_error=false); p=dlopen("libmpi", RTLD_LAZY; throw_error=false); using Pkg; Pkg.build("MPI"; verbose=true)'
julia --project=. -e 'using Pkg;Pkg.instantiate()'

plat="Linux"
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-${plat}-x86_64.sh
chmod +x Miniconda3-latest-${plat}-x86_64.sh
./Miniconda3-latest-${plat}-x86_64.sh -b -p miniconda3
. miniconda3/bin/activate && conda create -y --name=py39 python=3.9
conda activate py39
conda install -y matplotlib
conda install -y numpy
conda install -y cartopy
conda install -y scipy
conda install -y --channel=conda-forge cmocean

julia --project=. -e "using Pkg; Pkg.instantiate();"
julia --project=. -e "using Oceananigans"
julia --project=. -e 'using Pkg; Pkg.add("DataDeps")'
julia --project=. -e 'using Pkg; Pkg.add("PyCall")'
julia --project=. -e 'using PyCall; pyimport_conda("matplotlib.pyplot", "matplotlib")'
julia --project=. -e 'using PyCall; pyimport_conda("numpy.ma", "numpy")'
julia --project=. -e 'using PyCall; pyimport_conda("cartopy.crs", "cartopy")'
julia --project=. -e 'using PyCall; pyimport_conda("cmocean", "cmocean","conda-forge")'

julia --project=. -e 'using Pkg;Pkg.add("Plots");Pkg.add("TimesDates");Pkg.add("SpecialFunctions");Pkg.add("BenchmarkTools")'

# Missed dependency somewhere needs this for now? 
cd benchmark 
julia --project=. -e 'using Libdl; p=dlopen("libmpi", RTLD_LAZY; throw_error=false); p=dlopen("libmpi", RTLD_LAZY; throw_error=false); using Pkg; Pkg.build("MPI"; verbose=true)'
julia --project=. -e 'using Pkg;Pkg.add("StructArrays")'



# Add VirtualGL and TurboVNC
cd ~
sudo apt-get install -y virtualgl
wget https://gigenet.dl.sourceforge.net/project/turbovnc/2.2.6/turbovnc_2.2.6_amd64.deb
sudo apt-get install -y `pwd`/turbovnc_2.2.6_amd64.deb
sudo apt-get install -y novnc websockify python-numpy

# Boot commands (to work with ssh -L 6908:localhost:6908 -i key -l LOGIN and then http://localhost:6908 )
# note - password here is required but not for security, security is through using ssh tunnel and limiting
# port access.
mkdir /home/$USER/.vnc
echo password | /opt/TurboVNC/bin/vncpasswd -f > /home/$USER/.vnc/passwd
chown -R $USER:$USER /home/$USER/.vnc
chmod 0600 /home/$USER/.vnc/passwd

## These need to be repeated on reboot
## /opt/TurboVNC/bin/vncserver
## websockify -D --web=/usr/share/novnc 6908 localhost:5901
