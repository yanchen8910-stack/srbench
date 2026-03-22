#!/bin/bash
rm -rf TPSR
git clone --recurse-submodules https://github.com/deep-symbolic-mathematics/TPSR
cd TPSR

# install nesymres submodule
if [ -d "nesymres/src" ]; then
    /opt/conda/bin/pip install -e nesymres/src/
fi

# install key dependencies
/opt/conda/bin/pip install tqdm sympytorch "gym==0.26.2" click omegaconf hydra-core pytorch-lightning

# download e2et model
mkdir -p symbolicregression/weights
curl -L "https://dl.fbaipublicfiles.com/symbolicregression/model1.pt" -o symbolicregression/weights/model.pt

# patch hardcoded path, weights_only, and map_location
sed -i "s|'./symbolicregression/weights/model.pt'|'/opt/conda/bin/tpsr/symbolicregression/weights/model.pt'|" symbolicregression/e2e_model.py
sed -i "s|torch.load('/opt/conda/bin/tpsr/symbolicregression/weights/model.pt')|torch.load('/opt/conda/bin/tpsr/symbolicregression/weights/model.pt', map_location=torch.device('cpu'), weights_only=False)|" symbolicregression/e2e_model.py

# copy to expected path
cp -r . /opt/conda/bin/tpsr
