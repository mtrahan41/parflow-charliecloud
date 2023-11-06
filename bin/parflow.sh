#!/bin/bash

if podman --version >& /dev/null
then
   podman run --rm -v $(pwd):/data docker.io/parflow/parflow:latest $*
elif docker ps >& /dev/null
then
   docker run --rm -v $(pwd):/data parflow/parflow:latest $*
elif singularity version >& /dev/null
then
   singularity run docker://parflow/parflow:latest $*
elif ch-checkns >& /dev/null
then
   if [ ! -d $(pwd)/.parflow_image ]
   then
       echo "running: ch-image pull parflow/parflow"
       ch-image pull parflow/parflow
       echo "running: ch-convert parflow/parflow $(pwd)/.parflow_image"
       ch-convert parflow/parflow $(pwd)/.parflow_image
   fi
   echo "running: ch-run -w -b $(pwd):/data -c /data --set-env $(pwd)/.parflow_image -- pfrun $*"
   ch-run -w -b $(pwd):/data -c /data --set-env $(pwd)/.parflow_image -- pfrun $*
else
   echo "Couldn't run podman, docker, charliecloud, or singularity"
fi
