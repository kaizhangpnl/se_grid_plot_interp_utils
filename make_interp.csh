#!/bin/csh

set echo 

# ne30np4 to fv129x256 
setenv mapping_file mapping_files/map_ne30np4_to_fv129x256_aave.20150901.nc 
setenv F1 input1_ne30np4_T.nc 
setenv F2 output_ne30np4_to_fv129x256_aave.nc 
rm -f $F2 
ncks --map=${mapping_file} $F1 $F2 

# fv129x256 to ne30np4 
setenv mapping_file mapping_files/map_fv129x256_to_ne30np4_aave.20150901.nc
setenv F1 output_ne30np4_to_fv129x256_aave.nc
setenv F2 output_fv129x256_aave_to_ne30np4.nc 
rm -f $F2 
ncks --map=${mapping_file} $F1 $F2 

