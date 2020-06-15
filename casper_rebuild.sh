#!/bin/bash -l
# Batch directives
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --account NTDD0002
#SBATCH --partition=dav
#SBATCH --time=00:15:00
#SBATCH --output=MOM6.bldlog.%j
#SBATCH --job-name=rebld_MOM6

# Load the modules needed
module purge
module load pgi/20.4
module load openmpi/4.0.3
module load netcdf/4.7.3
module list

# Edit these paths for your specific run
BASE_DIR=/glade/scratch/brileyj/Summer_MOM6/Ported/MOM6_stdalone
BLD_OCN=${BASE_DIR}/build/pgi/ocean_only/repro/
EXE=mom.exe 

# Make the MOM6 executable
(cd ${BLD_OCN}; source ../../env; make NETCDF=3 REPRO=1 ${EXE} -j)
