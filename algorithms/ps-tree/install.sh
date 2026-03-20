#!/bin/bash
if [ -d "PS-Tree" ]; then
    rm -rf PS-Tree
fi
git clone https://github.com/zhenlingcn/PS-Tree
cd PS-Tree

# remove glmnet from requirements and setup.py, install fixed version separately
sed -i '/glmnet/d' requirements.txt
sed -i "/'glmnet'/d" setup.py
/opt/conda/bin/pip install "glmnet @ git+https://github.com/civisanalytics/python-glmnet.git"
/opt/conda/bin/pip install --no-build-isolation -r requirements.txt
/opt/conda/bin/pip install --no-build-isolation .
