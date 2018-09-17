# MLToolkit
## Introduction
This repository contains two distinct sections. First is an implementation of the FRESH (FeatuRe Extraction and Scalable Hypothesis testing) algorithm called FreshQ for use in feature extraction from time series data and the reduction in the number of features through statistical testing. The second section is a number of scipts containing functions which are relevant for use in a variety of machine learning applications.

The contents of both sections are explained in greater depth within their individual folders and at [INSERT code.kx.com links.]

## Requirements

- kdb+ ≥ 3.5 64-bit
- Python ≥ 3.5.0
- embedPy

#### Dependencies
- numpy
- scikit-learn
- scipy = 1.0.0
- statsmodels
- matplotlib

These python dependancies can be installed via:

pip:
```bash
pip install -r requirements.txt
```

or via conda:
```bash
conda install --file requirements.txt
```

## Installation

Place the library file in `$QHOME` and load into a q instance using `ml/init.q`

This will load all the functions contained within the `.fresh` and `.ml` namespaces 
```q
\l ml/init.q
```

Loading of the individual libraries can be completed via `ml/mlutils/init.q` or `ml/freshq/init.q` depending on if the preprocessing/statistical functions are needed or the FreshQ alone is required
## Documentation

Documentation is available on the [FreshQ](https://code.kx.com/q/ml/freshq/) and [mlutils](https://code.kx.com/q/ml/mlutils) homepage.

## Status

The FreshQ library is still in development and is available here as a beta release, further functionality and improvements will be made to the library in the coming months.

