import sys
import os
import pyTIR as tir
from itertools import product
from sklearn.base import BaseEstimator, RegressorMixin

class TIRWrapper(BaseEstimator, RegressorMixin):
    def __init__(self, npop=1000, ngens=500, pc=0.3, pm=0.7, 
                 exponents=(-5,5), error="R^2", alg="MOO",
                 transfunctions='Id,Sin,Tanh,Sqrt,Log,Exp',
                 ytransfunctions='Id', max_time=3600):
        self.npop = npop
        self.ngens = ngens
        self.pc = pc
        self.pm = pm
        self.exponents = exponents
        self.error = error
        self.alg = alg
        self.transfunctions = transfunctions
        self.ytransfunctions = ytransfunctions
        self.max_time = max_time

    def fit(self, X, y):
        self._est = tir.TIRRegressor(
            npop=self.npop, ngens=self.ngens, pc=self.pc, pm=self.pm,
            exponents=self.exponents, error=self.error, alg=self.alg,
            transfunctions=self.transfunctions,
            ytransfunctions=self.ytransfunctions,
            max_time=self.max_time
        )
        self._est.fit(X, y)
        return self

    def predict(self, X):
        return self._est.predict(X)

    def get_best_solution(self):
        return self._est.get_best_solution()

est = TIRWrapper()

def model(est, X=None):
    new_model = est._est.sympy.replace("^","**")
    if X is not None and hasattr(X, "columns"):
        for i,f in reversed(list(enumerate(X.columns))):
            new_model = new_model.replace(f"x{i}",f)
    return new_model

def complexity(est):
    return len(str(model(est)))

eval_kwargs = {
    'scale_x': False,
    'scale_y': False,
}
