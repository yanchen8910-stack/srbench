#!/bin/bash
# Install Haskell toolchain
export BOOTSTRAP_HASKELL_NONINTERACTIVE=1
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | bash
export PATH=$PATH:~/.ghcup/bin:~/.cabal/bin

# Install tir
git clone https://github.com/folivetti/tir.git
cd tir
git checkout 9f51131cabdd52d4dab7a00cbd425bbae05b15b9
cabal update
cabal install --overwrite-policy=always --installdir=./python && cd python && pip install .
