#!/bin/bash
# reinstall shogun after base_environment.yml may have removed it
micromamba install -n base -y -c conda-forge shogun-cpp=6.1.4 eigen=3.4.0 pybind11=2.11.1
/opt/conda/bin/pip install git+https://github.com/cavalab/feat.git
