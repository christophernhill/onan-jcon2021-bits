# Setup Oceananigans.jl
cd ~/projects
alias julia=~/projects/julia-1.6.1/bin/julia 
git clone https://github.com/clima/Oceananigans.jl
cd Oceananigans.jl
export JULIA_DEPOT_PATH=`pwd`/.julia

# Configureing JUlia for MPI
# # To set up MPI may need
source /etc/profile.d/lmod.sh 
module use /home/ubuntu/spack/share/spack/lmod/linux-ubuntu20.04-x86_64/
module load Core/openmpi/4.1.1-ofh2usm
julia --project=. -e 'using Libdl; p=dlopen("libmpi", RTLD_LAZY; throw_error=false); p=dlopen("libmpi", RTLD_LAZY; throw_error=false); using Pkg; Pkg.build("MPI"; verbose=true)'


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
julia --project=. -e 'using Pkg;Pkg.add("StructArrays")'
