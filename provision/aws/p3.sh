# Setup Oceananigans.jl
cd ~/projects
alias julia=~/projects/julia-1.6.1/bin/julia 
git clone https://github.com/Oceananigans.jl
cd Oceananigans.jl
export JULIA_DEPOT_PATH=`pwd`/.julia

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

