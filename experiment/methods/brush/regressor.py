from brush import BrushRegressor
try:
    from brush import individual
except ImportError:
    individual = None

from sklearn.base import BaseEstimator, RegressorMixin as _RegressorMixin

class BrushWrapper(BaseEstimator, _RegressorMixin):
    def __init__(self, pop_size=100, max_gen=250, max_depth=8, max_size=75,
                 verbosity=0, functions=None):
        self.pop_size = pop_size
        self.max_gen = max_gen
        self.max_depth = max_depth
        self.max_size = max_size
        self.verbosity = verbosity
        self.functions = functions or ['Add','Sub','Mul','Div','Sin','Cos','Tanh','Exp','Log','Sqrt']

    def fit(self, X, y):
        self._est = BrushRegressor(
            pop_size=self.pop_size,
            max_gen=self.max_gen,
            max_depth=self.max_depth,
            max_size=self.max_size,
            verbosity=self.verbosity,
            functions=self.functions
        )
        self._est.fit(X, y)
        return self

    def predict(self, X):
        return self._est.predict(X)


from sklearn.metrics import r2_score
from sklearn.base import BaseEstimator, RegressorMixin
import re
import numpy as np

bandit     = ["dynamic_thompson", "thompson"]
max_depth  = [5, 7, 9]
objectives = [['scorer', 'complexity'], ['scorer', 'linear_complexity']]

hyper_params = []
# The estimator is generating a segfault when using gridsearch. Skipping
# for b, d in zip(bandit, max_depth):
#     for o in objectives:
#         hyper_params.append({
#                 'bandit'     : [b],
#                 'max_depth'  : [d],
#                 'objectives' : [o]
#                 })
        
kwargs = {
    'verbosity'  : 0,
    'pop_size'   : 100,
    'max_gen'    : 250,
    'max_depth'  : 8,
    'max_size'   : 75,
    'functions'  : [
        'Add', 'Sub', 'Mul', 'Div', 'Sin', 'Cos', 'Tanh',
        'Exp', 'Log', 'Sqrt',
    ]
}


est = BrushWrapper() 


func_dict = {
    'Mul': '*',
    'Sub': '-',
    'Add': '+',
    'Div': '/',
    'Pow': '**',
}

func_arity = { # remember to add here the functions used in the experiments
    # These can have multiple arguments
    'Mul': 2,
    'Sub': 2,
    'Div': 2,
    'Add': 2,

    'Pow': 2,
    
    'Sin'  : 1,
    'Cos'  : 1,
    'Tanh' : 1,

    'Asin' : 1,
    'Acos' : 1,
    
    'Sqrt' : 1,
    
    'Log'     : 1,
    'Exp'     : 1,
    
    'Square'  : 1,
}


class BrushPopEstimator(RegressorMixin):
    """
    BrushPopEstimator is a custom regressor that wraps a fitted Brush estimator
    to call `model` and `predict` from its archive.
    
    Attributes:
        est (object): The fitted Brush estimator.
        id (int): The identifier for the specific model in the estimator's archive.
    Methods:
        __init__(est, id):
            Initializes the BrushPopEstimator with a fitted Brush estimator
            and a model ID.
        fit(X, y):
            Dummy fit method to set the estimator as fitted.
        predict(X):
            Prepares the input data and predicts the output using the
            model from the estimator's archive.
        score(X, y):
            Computes the R^2 score of the prediction.
        model():
            Retrieves the model equation from the estimator's archive.
    """
    def __init__(self, est, id):
        self.est = est
        self.id  = id

    def fit(self, X, y):
        self.is_fitted_ = True

    def predict(self, X):
        preds = self.est.predict_archive(X)
        ind = [i for i in preds if i['id']==self.id][0]
        return ind['y_pred']

    def score(self, X, y):
        yhat = self.predict(X).flatten()
        return r2_score(y,yhat)
    
    def model(self):
        archive = self.est.archive_
        ind = [i for i in archive if i['id']==self.id][0]
        loaded = individual.ClassifierIndividual.from_json(ind)
        return loaded.get_model()
    

def pretify_expr(string, feature_names):
    # Breaking down into a list of symbols. replace 8 with % to capture weight multiplication
    # (these are already in infix notation)
    ind = string.replace(' ', '').replace(')', '').replace('(', ',').split(',')

    new_string = ""
    stack = []
    for node in ind:
        stack.append((node, []))
        while len(stack[-1][1]) == func_arity.get(stack[-1][0], 0):

            prim, args = stack.pop()
            new_string = prim
            if prim in func_dict.keys(): # converting prefix to infix notation
                new_string = '(' + func_dict[prim].join(args) + ')'
            elif "*" in prim: # node weights already are in infix notation. handling it
                l, r = prim.split("*")
                stack.append( ("Mul", [l]) )
                stack.append( (r, []) )
                continue             
            elif prim not in feature_names:
                try:
                    float(prim)
                except:
                    new_string = prim.lower() + '(' + args[0] + ')'
                
            if len(stack) == 0:
                break

            stack[-1][1].append(new_string)

    return new_string


def model(est, X=None):
    model_str = None
    if isinstance(est, BrushWrapper):
        model_str = est._est.best_estimator_.get_model()
    elif isinstance(est, BrushRegressor):
        model_str = est.best_estimator_.get_model()
    else:
        model_str = est.model()

    # raw string, without fixing infix notation
    return model_str

    # Extra processing if need to have prettier strings 
    feature_names = [f"x_{i}" for i in range(100)]
    if X is not None:
        feature_names = X.columns

    pretty_model_str = pretify_expr(model_str, feature_names=feature_names)

    return pretty_model_str


def complexity(est):
    if isinstance(est, BrushRegressor):
        return est.best_estimator_.fitness.size
    
    ind = [i for i in est.est.archive_ if i['id']==est.id][0]
    return ind['fitness']['size']


def get_best_solution(est):
    return est


def get_population(est):
    print("population size:", len(est.population_))
    print("archive size   :", len(est.archive_))

    archive = est.archive_

    pop = []
    for ind in archive:
        # Archive is sorted by complexity
        pop.append(
            BrushPopEstimator(est, ind['id'])
        )

        # Stopping here to avoid too many models
        if len(pop) >= 100:
            break

    return pop