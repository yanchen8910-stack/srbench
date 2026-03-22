#!/bin/bash
rm -rf NeuralSymbolicRegressionThatScales
git clone https://github.com/SymposiumOrganization/NeuralSymbolicRegressionThatScales
cd NeuralSymbolicRegressionThatScales
/opt/conda/bin/pip install -e src/

# Download pre-trained model
/opt/conda/bin/pip install huggingface_hub
mkdir -p /home/mambauser/nesymres_weights
/opt/conda/bin/python -c "
from huggingface_hub import hf_hub_download
path = hf_hub_download(
    repo_id='TommasoBendinelli/NeuralSymbolicRegressionThatScales',
    filename='100M.ckpt',
    local_dir='/home/mambauser/nesymres_weights'
)
print('Model downloaded to', path)
"
