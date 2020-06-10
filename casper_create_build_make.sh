rm -rf build/pgi
module purge
module load pgi/20.4
module load openmpi
module load netcdf
module list

mkdir -p build/pgi/shared/repro/
(cd build/pgi/shared/repro/; rm -f path_names; \
../../../../src/mkmf/bin/list_paths -l ../../../../src/FMS; \
../../../../src/mkmf/bin/mkmf -t /glade/scratch/ssuresh/MOM6-examples/casper-pgi.mk -p libfms.a -c "-Duse_libMPI -Duse_netCDF -DSPMD -I/glade/u/apps/dav/opt/netcdf/4.7.3/pgi/20.4/include/ -I/glade/u/apps/dav/opt/openmpi/4.0.3/pgi/20.4//include/ -L/glade/u/apps/dav/opt/netcdf/4.7.3/pgi/20.4//lib/ -lnetcdf -L/glade/u/apps/dav/opt/openmpi/4.0.3/pgi/20.4/lib/ -lmpi" path_names)

(cd build/pgi/shared/repro/; source ../../env; make NETCDF=3 REPRO=1 libfms.a -j)


#################ocean only
mkdir -p build/pgi/ocean_only/repro/
(cd build/pgi/ocean_only/repro/; rm -f path_names; \
../../../../src/mkmf/bin/list_paths -l ./ ../../../../src/MOM6/{config_src/dynamic,config_src/solo_driver,src/{*,*/*}}/ ; \
../../../../src/mkmf/bin/mkmf -t /glade/scratch/ssuresh/MOM6-examples/casper-pgi.mk -o '-I../../shared/repro -I/glade/u/apps/dav/opt/netcdf/4.7.3/pgi/20.4/include/ -I/glade/u/apps/dav/opt/openmpi/4.0.3/pgi/20.4/include/' -p MOM6 -l '-L../../shared/repro -lfms -L/glade/u/apps/dav/opt/netcdf/4.7.3/pgi/20.4//lib/ -lnetcdf -L/glade/u/apps/dav/opt/openmpi/4.0.3/pgi/20.4/lib/ -lmpi -lmpi_mpifh' -c '-Duse_libMPI -Duse_netCDF -DSPMD' path_names)

(cd build/pgi/ocean_only/repro/; source ../../env; make NETCDF=3 REPRO=1 MOM6 -j)
