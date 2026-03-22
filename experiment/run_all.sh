#!/bin/bash

DATASET_DIR=~/pmlb/datasets
RESULTS_DIR=results
N_JOBS=4
FIT_TIME=3600
N_TRIALS=1
STARTING_SEED=1

ALGORITHMS="afp,bingo,brush,bsr,e2et,eplex,eql,feat,ffx,gpgomea,gplearn,gpzgd,itea,nesymres,operon,ps-tree,pysr,qlattice,rils-rols,tir,tpsr"

echo "Starting srbench full run"
echo "Algorithms: $ALGORITHMS"
echo "Dataset dir: $DATASET_DIR"
echo "Results dir: $RESULTS_DIR"
echo "Jobs: $N_JOBS | Fit time: ${FIT_TIME}s | Trials: $N_TRIALS"
echo "========================================"

python3 analyze.py $DATASET_DIR \
    --local \
    -ml $ALGORITHMS \
    -n_jobs $N_JOBS \
    -fit_time_limit $FIT_TIME \
    -n_trials $N_TRIALS \
    -starting_seed $STARTING_SEED \
    -results $RESULTS_DIR \
    --noskips

echo "========================================"
echo "Done. Results saved to $RESULTS_DIR"
