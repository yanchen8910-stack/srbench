#!/bin/bash
if [ -d "PS-Tree" ]; then
    rm -rf PS-Tree
fi

micromamba install -n base -y -c conda-forge glmnet cython

git clone https://github.com/zhenlingcn/PS-Tree
cd PS-Tree
sed -i '/glmnet/d' requirements.txt
sed -i "/'glmnet'/d" setup.py
/opt/conda/bin/pip install --no-build-isolation -r requirements.txt
/opt/conda/bin/pip install --no-build-isolation .
