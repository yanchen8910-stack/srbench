#!/bin/bash
rm -rf eql_repo
git clone https://github.com/cavalab/eql.git eql_repo
cd eql_repo
# fix broken setup.py
cat > setup.py << 'SETUP'
from setuptools import setup, find_packages
setup(
    name='eql',
    version='0.2',
    packages=find_packages(),
)
SETUP
/opt/conda/bin/pip install .
