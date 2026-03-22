#!/bin/bash
# install eigency with no-build-isolation to avoid pkg_resources issue
/opt/conda/bin/pip install --no-build-isolation eigency==1.77

# install Bingo
git clone --recurse-submodules --depth 1 --branch v0.4.1.srbench https://github.com/nasa/bingo.git
cd bingo
/opt/conda/bin/pip install --no-build-isolation .
