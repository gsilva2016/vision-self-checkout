#!/bin/bash
#
# Copyright (C) 2023 Intel Corporation.
#
# SPDX-License-Identifier: BSD-3-Clause
#

if [ -z "$OD_BATCH_SIZE" ]
then
	OD_BATCH_SIZE=1
fi

if [ "$LOW_POWER" == "0" ]; then
	LOW_POWER=""
fi

if [ "$CPU_ONLY" == "0" ]; then
	CPU_ONLY=""
fi

echo "" > /tmp/results/pipeline_info$cid_count.log

if [ -z "$LOW_POWER" ] && [ -z "$CPU_ONLY" ]
then
	echo "CPU+iGPU yolov5s.sh. Batch Size: $OD_BATCH_SIZE LOW_POWER: $LOW_POWER CPU_ONLY: $CPU_ONLY started" >> /tmp/results/pipeline_info$cid_count.log
	gst-launch-1.0 $inputsrc ! vaapidecodebin ! gvadetect batch-size=$OD_BATCH_SIZE model-instance-id=odmodel name=detection model=models/yolov5s/1/FP32-INT8/yolov5s.xml model-proc=models/yolov5s/1/yolov5s.json threshold=.5 device=MULTI:GPU,CPU ! gvametaaggregate name=aggregate ! gvametaconvert name=metaconvert add-empty-results=true ! gvametapublish name=destination file-format=2 file-path=/tmp/results/r$cid_count.jsonl ! fpsdisplaysink video-sink=fakesink sync=true --verbose 2>&1 | stdbuf -oL sed -n -e 's/^.*current: //p' | stdbuf -oL cut -d , -f 1 > /tmp/results/pipeline$cid_count.log
elif [ "$CPU_ONLY" == "1" ] 
then
	echo "CPU yolov5s.sh started. Batch Size: $OD_BATCH_SIZE LOW_POWER: $LOW_POWER CPU_ONLY: $CPU_ONLY" >> /tmp/results/pipeline_info$cid_count.log

	gst-launch-1.0 $inputsrc ! decodebin force-sw-decoders=1 ! gvadetect model-instance-id=odmodel batch-size=$OD_BATCH_SIZE name=detection model=models/yolov5s/1/FP32-INT8/yolov5s.xml model-proc=models/yolov5s/1/yolov5s.json threshold=.5 device=CPU ! gvametaconvert name=metaconvert add-empty-results=true ! gvametapublish name=destination file-format=2 file-path=/tmp/results/r$cid_count.jsonl ! fpsdisplaysink video-sink=fakesink sync=true --verbose 2>&1 | stdbuf -oL sed -n -e 's/^.*current: //p' | stdbuf -oL cut -d , -f 1 > /tmp/results/pipeline$cid_count.log
else
	echo "iGPU low power yolov5s.sh started. Batch Size: $OD_BATCH_SIZE LOW_POWER: $LOW_POWER CPU_ONLY: $CPU_ONLY" >> /tmp/results/pipeline_info$cid_count.log
	gst-launch-1.0 $inputsrc ! vaapidecodebin ! gvadetect batch-size=$OD_BATCH_SIZE model-instance-id=odmodel name=detection model=models/yolov5s/1/FP32-INT8/yolov5s.xml model-proc=models/yolov5s/1/yolov5s.json threshold=.5 device=GPU $pre_process ! gvametaaggregate name=aggregate ! gvametaconvert name=metaconvert add-empty-results=true ! gvametapublish name=destination file-format=2 file-path=/tmp/results/r$cid_count.jsonl ! fpsdisplaysink video-sink=fakesink sync=true --verbose 2>&1 | stdbuf -oL sed -n -e 's/^.*current: //p' | stdbuf -oL cut -d , -f 1 > /tmp/results/pipeline$cid_count.log
fi
