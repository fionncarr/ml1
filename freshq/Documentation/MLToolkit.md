---
hero: <i class="fa fa-share-alt"></i> Machine learning

author: Conor McCarthy

title: ML toolkit

date: October 2018

keywords: machine learning, ml, feature extraction, feature selection, time series forecasting, utilities, interpolation, filling, statistics

---

# ML Toolkit

## Overview

The machine learning toolkit herein referred to as the ML toolkit contains a number of libraries and scripts. These have been produced with the aim of providing q/kdb+ users with general use functions and procedures to allow them to perform machine learning tasks on a wide variety of datasets.

This toolkit contains at present 2 main sections. 

The first contains utility functions relating to important aspects of machine learning including data preprocessing and statistical testing, and also includes general use functions found to be useful in many machine learning applications. 

The second is an implementation of the FRESH (FeatuRe Extraction and Scalable Hypothesis testing) algorithm in q. This provides the q/kdb+ user with the ability to perform feature extraction and feature significance tests on structured time-series data in order to allow users to perform forecasting, regression and classification on time-series data.

Over time the machine learning functionality contained within this library will be extended both in a wider context to include q specific implementations of machine learning algorithms, but also to include more functionality in the sections already implemented.

This library of functions can be accessed [here](ML toolkit GIT to be added)

### Requirements
The following requirements cover all those needed to run the libraries and examples within the current build of this toolkit.

- kdb+ ≥ v3.5 64-bit
- Anaconda Python 3.x
- embedPy
- JupyterQ

A number of python dependencies also exist for the running of embedPy functions within both the the ML utils and FRESH libraries, these are as follows.

- numpy
- scipy
- scikit-learn
- statsmodels
- matplotlib
- pandas

These can be installed using pip via;
```bash
pip install -r requirements.txt
```
or via conda;
```bash
conda install --file requirements.txt
```
