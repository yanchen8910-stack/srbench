#!/bin/bash
# force install correct version last, overriding anything sphinx may have pulled
/opt/conda/bin/pip install --force-reinstall --no-deps "pybrush @ https://github.com/cavalab/brush/releases/download/v0.1.1/pybrush-0.1.1-cp311-cp311-linux_x86_64.whl"
