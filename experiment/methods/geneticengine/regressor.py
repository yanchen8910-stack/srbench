from geml.regressors import GeneticProgrammingRegressor
from geml.regressors import model
from sklearn.base import RegressorMixin

est: RegressorMixin = GeneticProgrammingRegressor(
    max_time=60*60,
)

def get_population(est) -> list[RegressorMixin]:
    return est.get_population()

def get_best_solution(est) -> RegressorMixin:
    return est.get_best_solution()

def complexity(est):
    return est.get_nodes()

eval_kwargs = {
    'test_params': {'max_time': 10}
}
