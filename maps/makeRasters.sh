#!/bin/bash

set -euo pipefail

if [ "$#" -ne 2 ]; then
	echo "./makeRasters.sh targetDir targetEPSG $#"
	exit 1
fi

find $1 -name "*.tif" -type f

rm -rf maps
mkdir maps

parallel --will-cite "gdalwarp -co compress=jpeg -wo OPTIMIZE_SIZE=YES -co TILED=YES -t_srs EPSG:$2 {} maps/{/.}.$2.tif;  gdaladdo -r nearest maps/{/.}.$2.tif 2 4 8 16 32 64 128 256 512 1024 2048 4096 8192" ::: $(find $1 -name "*.tif" -type f)



tar -czf maps.$1.$2.tar.gz maps/