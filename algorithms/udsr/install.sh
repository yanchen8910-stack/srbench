#!/bin/bash
/opt/conda/bin/pip install cython numpy commentjson numba prettytable
rm -rf deep-symbolic-optimization
git clone https://github.com/dso-org/deep-symbolic-optimization
cd deep-symbolic-optimization

# patch TF1 API calls to TF2 compatible
find dso/dso -name "*.py" -exec sed -i \
    's/tf\.set_random_seed/tf.random.set_seed/g; 
     s/tf\.random\.random_shuffle/tf.random.shuffle/g;
     s/tf\.Session/tf.compat.v1.Session/g;
     s/tf\.placeholder/tf.compat.v1.placeholder/g;
     s/tf\.get_variable/tf.compat.v1.get_variable/g;
     s/tf\.variable_scope/tf.compat.v1.variable_scope/g;
     s/tf\.global_variables_initializer/tf.compat.v1.global_variables_initializer/g' {} \;

/opt/conda/bin/pip install --no-build-isolation --no-deps -e ./dso
/opt/conda/bin/pip install tensorflow commentjson numba prettytable
