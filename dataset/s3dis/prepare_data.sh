#!/bin/bash
 
python dataset/s3dis/prepare_data_inst.py
python dataset/s3dis/downsample.py
python dataset/s3dis/prepare_data_inst_gttxt.py
