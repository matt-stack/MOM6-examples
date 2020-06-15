#!/bin/bash -l
# Batch directives
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=36
#SBATCH --account NTDD0002
#SBATCH --partition=dav
#SBATCH --reservation=TDD_4xV100
#SBATCH --time=00:15:00
#SBATCH --output=MOM6.log.%j.out
#SBATCH --job-name=bnchmk_MOM6


# Adjust these paths and values depending on your test
TEST=benchmark
BASE_DIR=$PWD
TEST_DIR=${BASE_DIR}/ocean_only/${TEST}
EXE_NAME=mom.exe
EXE_PATH=${BASE_DIR}/build/pgi/ocean_only/repro/${EXE_NAME}

echo "MOM6 running test \"${TEST}\" from directory ${TEST_DIR} with executable coming from ${EXE_PATH}"

# Load the modules needed
module purge
module load pgi/20.4
module load openmpi/4.0.3
module load netcdf/4.7.3
module load cuda/10.1
module list

# Add NetCDF to LD_LIBRARY_PATH
LD_LIBRARY_PATH=/glade/u/apps/dav/opt/netcdf/4.7.3/pgi/20.4/lib:${LD_LIBRARY_PATH}
echo -e "PATH=${PATH}\n"
echo -e "LD_LIBRARY_PATH=${LD_LIBRARY_PATH}\n"

# Go to the test directory and start the job
cd ${TEST_DIR}
# Have to make sure that a RESTART directory exists for each test you run or it fails early
mkdir -p ${TEST_DIR}/RESTART
# IMPORTANT: Make sure the number here does not exceed ntasks-per-node*nodes at the top

if ["$1" == "profile"]; then
nvprof -o nvprof_standalone_%j.nvvp --cpu-profiling=on  mpirun -np 36 ${EXE_PATH} 
else 
mpirun -np 36 ${EXE_PATH} 
fi
