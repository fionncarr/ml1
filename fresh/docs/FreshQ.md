---
hero: <i class="fa fa-share-alt"></i> Machine learning

author: Conor McCarthy

title: FreshQ: a feature extraction and feature significance toolkit

date: August 2018

keywords: machine learning, ml, feature extraction, feature selection, time series forecasting, interpolation

---

# FRESH

## Overview

Feature extraction and selection are vital components of the machine learning pipeline. Here we outline an implementation of the FRESH (FeatuRe Extraction and Scalable Hypothesis testing) algorithm[1]. This provides the opportunity to explore structured datasets in depth and to extract the most relevant features for predicting a target vector. 

Feature extraction at a basic level is the process by which from an initial dataset we build derived values/features which may be informative when passed to a machine learning algorithm. It allows for information which may be pertinent to the prediction of an attribute of the system under investigation to be extracted. This information is often easier to interpret than the time series in its raw form. It also offers the chance to apply less complex machine learning models to our data as the important trends in the data do not have to be extracted from the data via more complex methods.

Following feature extraction statistical significance tests between the feature and target vectors. This is required as within the features extracted from the initial data there may only be a small subsection of features of importance. Once statistical tests have been completed to find the relevance of features
the Benjamini-Hochberg-Yekutieli procedure is applied to set a threshold for the features which are deemed to be important. 

The purpose of feature selection from the standpoint of improving the accuracy of a machine learning algorithm are as follows

- Simplify the models being used thus making them easier to interpret.
- Shortens the time needed to train a model.
- Helps to avoid the curse of dimensionality.
- Reduces variance in the dataset to reduce overfitting.

This library of functions can be accessed at [here](Include link to ML Toolkit in GIT)
References:
1. Christ.M, Kempa-Liehr.A and Feindt.M (2017). Distributed and parallel time series feature extraction for industrial big data applications. Neurocomputing (https://arxiv.org/pdf/1610.07717v3.pdf).

## Data formatting

One of the key requirements of this library is that the data being passed to the feature extraction procedure contain a so called 'identifying' column which delimits the time series data into unique subsets from which features of this data can be extracted. This id column can be either inherent to the dataset or derived from the data for the specific use case through the application of a sliding window onto the table. Null values should also be removed from the data and filled with non null values that are relevant to the column being filled.

The data should also not contain text in the form of strings or symbols (other than in the id column) as these cannot be passed to the feature calculation functions. If a text based feature is thought to be important however, one hot encoding can be completed to convert the text to numerical values if deemed particularly relevant.

Data-types which are supported by the feature extraction procedure are boolean, int, real, long, short and float. Other datatypes should not passed to the extraction procedure as features creation will not be supported under such conditions.

Functions to complete the formatting above including the tailored filling of nulls, application of a 'rolling window' and the interpolation of data are supplied within the ML toolkit and documented at (...Insert link to non fresh documentation...)
## Calculated Features

The features extracted from the data are contained in the script fresh.q within the .fresh namespace and can be displayed via the syntax:

`.fresh.feat`

The following is a table of a subset of the calculated features and a short description this subset.

|Function                         | Description |
|:--------------------------------|:-------------------------------------------------|
|absenergy(x)                     | Absolute sum of the differences between successive datapoints. |
|aggautocorr(x,aggfn)             | Aggregation (mean/var etc.) of an autocorrelation over all possible lags 1 - length data. |
|augfuller(x)                     | Hypotesis test to check for a unit root in time series dataset (This causes issues in statistical inference). |
|autocorr(x,lag)                  | Calculate autocorrelation over specified lags. |
|binnedentropy(x,#bins)           | Calculate system entropy of data binned into equidistant bins. |
|c3(x,lag)                        | This is a measure of the non-linearity of the time series. |
|changequant(x,ql,qh,isabs,aggfn) | Calculates the aggregated value of successive changes within corridor specified by ql(lower quantile) and qh(upper quantile). |
|cidce(x,isabs)                   | This is a measure of time series complexity based on peaks and troughs in the dataset. |
|countabovemean(x)                | Calculates the number of points in the dataset with a value less than the time series mean. |
|fftaggreg(x)                     | Returns the spectral centroid (mean), variance, skew, and kurtosis of the absolute fourier transform spectrum. |
|fftcoeff(x,coeff,attrib)         | Calculate fast fourier transform coefficients given real inputs and extract real, imaginary, absolute and angular components. |
|hasdup(x)                        | Calculates if the time series dataset contains duplicate points. |
|hasdupmax(x)                     | Returns a boolean value stating if a duplicate of the maximum value exists in the dataset. |
|indexmassquantile(x,q)           | Relative index i where q% of the time series x’s mass lies left of i. |
|kurtosis(x)                      | Return the adjusted G2 Fisher-Pearson kurtosis. |
|lintrend(x)                      | Returns the slope, intercept, r-value, p-value and standard error associated with the time series. |
|longstrikelmean(x)               | Compute the longest subsequence in x less than the mean of x. | 
|meanchange(x)                    | Mean over the absolute difference between subsequent t-series values. |
|mean2dercentral(x)               | Mean value of the central approximation of the second derivative of the time series. |
|numcrossingm(x,m)                | Calculate the number of crossings in the dataset of over a value m. A crossing is defined as sequential value where the first is less than m and the second is greater or vice-versa. |
|numcwtpeaks(x,width)             | Searches for peaks in x once smoothed by a ricker/top-hat wavelet with various widths. |
|numpeaks(x,support)              | Number of peaks of with a specified support(y) in time series x (peak defined as x[i] larger than the y values to its left and right). |
|partautocorrelation(x,lag)       | Calculates the partial autocorrelation of the time series at a specified lag. | 
|perrecurtoalldata(x)             | [Count of values occurring more than once]%[count different values]. |
|perrecurtoallval(x)              | [Count of values occurring more than once]%[count data]. |
|ratiobeyondrsigma(x,r)           | Ratio of values more than rdev(x) from the mean of x. |
|ratiovalnumtserieslength(x)      | [Number of unique values]%[count values]. |
|spktwelch(x,coeff)               | Calculates the cross power spectral density of the time series x at different frequencies. |
|symmetriclooking(x)              | Boolean measure of if the data appears symmetric. |
|treverseasymstat(x,lag)          | Measure of the asymmetry of the time series based on lags applied to the data. |
|vargtstdev(x)                    | Boolean defining if the variance of the dataset is larger than the standard deviation. |

A more detailed explanation of individual functions is available on request, as is information on the remaining functions which includes but are not limited the the following max, min, variance ,mean, count, sum of all values, skewness, first/last locations of max/min etc.


## Feature Extraction
#### `.fresh.createfeatures`

Feature extraction is the application of functions to subsets of initial input data, with the goal of obtaining information from the dataset that is more informative than the raw dataset. These important features could be the number of peaks that are present in the dataset, the kurtosis of the data or simply the maximum value that was reached within the data. 

The function defined below can be be used to derive such features from the data, a set of 57 functions from which these features are derived are contained in the `.fresh.feat` namespace. A subset of these functions can be used during extraction or changes can be made by the individual user to add or remove functions that are deemed important or insignificant to the specific use-case of interest.   

Syntax: `.fresh.createfeatures[table;aggs;cnames;funcs]`

Inputs: 
- table: This is a table containing an 'id' column
- aggs: (type = symbol) This is the 'id' column on which aggregations due to function calculations will be applied.
- cnames: (type = list of symbols) These are the columns which features are calculated for, they should not include time columns if present or any columns containing text.
- funcs: (type = dictionary) These are the functions that are applied to the columns (this can be either the entire ```.fresh.feat``` namespace or a subset of the features therein contained.)

Return:
- Returns a table containing the extracted features based on an identifying column from the input table.

Sample Code:
```q 
/load in freshq library
q)\l fresh.q

/load hourly amazon stock information 
q)tabinit:{lower[cols x]xcol x}("DTFFFFII";enlist ",") 0:`amzn.us.txt

q)show tabinit:(where 0=var each flip delete date,time from tabinit) _ tabinit
date       time         open     high     low     close    volume
-----------------------------------------------------------------
2017.05.16 16:00:00.000 961      965.48   960.91  964.67   431465
2017.05.16 17:00:00.000 964.68   968.2    963.18  966.64   547131
2017.05.16 18:00:00.000 966.53   967.85   965.12  967.285  234450
2017.05.16 19:00:00.000 967.11   970.06   966.26  967.9845 273555
2017.05.16 20:00:00.000 968.0232 968.74   965.74  965.78   170741
2017.05.16 21:00:00.000 965.765  967.92   965.57  966.94   138878
2017.05.16 22:00:00.000 966.98   967.31   965.55  966.07   395476
2017.05.17 16:00:00.000 954.7    960.3957 952.74  956.88   614193
2017.05.17 17:00:00.000 957.42   959.64   952.065 952.74   529877
2017.05.17 18:00:00.000 952.93   956.88   951.11  955.74   431709

/In this example we are only interested in functions that take the data as input (no hyperparameters)

q)singleinputfeatures:.fresh.getsingleinputfeatures[]

q)show tabraw:.fresh.createfeatures[tabinit;`date;2_ cols tabinit;singleinputfeatures]

date      | absenergy_open absenergy_high absenergy_low absenergy_close absenergy_volume abssumch..
----------| -------------------------------------------------------------------------------------..
2017.05.16| 6528432        6558328        6513445       6538611         8.201544e+11     10.4964 ..
2017.05.17| 6376044        6411741        6327408       6355289         2.353128e+12     20.9    ..
2017.05.18| 6374159        6434609        6359583       6399064         1.190324e+12     16.666  ..
2017.05.19| 6533383        6561515        6507017       6528318         1.791927e+12     9.8768  ..
2017.05.22| 6564285        6589820        6549129       6577656         6.661642e+11     9.29    ..
2017.05.23| 6602406        6622096        6570649       6595882         5.312849e+11     14.049  ..
```

## Feature Significance

#### `.fresh.significantfeatures`

A number of statistical significance tests are applied to the data to determine if a feature is likely to be useful in the predicting the value of a target vector. The significance test which is applied is dependent on the characteristics of the feature and target respectively, the following table outlines the test which is applied in each case.

|Feature Type       | Target Type       | Significance Test |
|:------------------|:------------------|:------------------|
|Binary             | Real              | Kolmogorov-Smirnov|                     
|Binary	            | Binary            | Fisher-Exact      |
|Real               | Real              | Kendall Tau-b     |
|Real               | Binary            | Kolmogorov-Smirnov|

Each of the above tests returns a p-value which can then be passed to the Benjamini-Hochberg-Yekutieli(BHY) procedure which determines if the feature meets a defined false discovery rate(FDR) level (This is set at 5% within the fresh.q script but can be modified if a lower FDR is needed).

Both the calculation of p-values via the feature significance tests above and the completion of the BHY procedure are contained within the function;

Syntax: `.fresh.significantfeatures[table;targets]`

Inputs: 
- table:(type = matrix) matrix representation of the feature extracted table (eg. value table).
- targets:(type = list) The name of the target vector which is a list of floats/ints/booleans.

Return:

- Returns a table containing a reduced number of features where the p-value calculated via the significance tests met the conditions defined by the BHY procedure.

Sample Code:
```q
q) show tabreduced:key[tabraw]!.fresh.significantfeatures[value tabraw;targets]
date      | abssumchange_high countabovemean_open countabovemean_high countbelowmean_open firstma..
----------| -------------------------------------------------------------------------------------..
2017.05.16| 8.03              5                   3                   2                   0.57142..
2017.05.17| 14.6657           4                   4                   3                   0.57142..
2017.05.18| 16.72             5                   4                   2                   0.85714..
2017.05.19| 4                 4                   5                   3                   0.28571..
2017.05.22| 5.3956            6                   4                   1                   0.14285..
2017.05.23| 9.1238            4                   3                   3                   0      ..

q)-1 "The number of columns in the initial dataset is: ",string count cols tabinit;
The number of columns in the initial dataset is: 7

q)-1 "The number of columns in the unfiltered dataset is: ",string count cols tabraw;
The number of columns in the unfiltered dataset is: 201

q)-1 "The number of columns in the filtered dataset is: ",string count cols tabreduced;
The number of columns in the filtered dataset is: 45
```
Given the demonstration code above taken from the ```Stock_Close_Price_Freshq.ipynb``` notebook, it is clear that feature extraction initially expands the number of available features dramatically and subsequently reduces to only those features deemed statistically relevant to prediction of the elements of the target vector.

## Fine Tuning

### Parameter Dictionary

Another of the features which can be modified to suit the needs of a specific use-case is the script paramdict.q. This contains hyperparameters for many of the functions which require such inputs. The default dictionary provided in this release is extensive but by no means exhaustive and can be modified by the individual user to suit their use case.

Within a future release functions or an api will be provided to allow this to be easily done via the console.
### Functions

The functions which are contained in this library are a small subset of the functions which can be applied in a feature extraction pipeline. Provided a user sticks to the template outlined within the fresh.q script any function written in q or leveraging embedPy which follows this template can be applied to the dataset.

As with modifications to the parameter dictionary a function to modify the functions which are called at feature creation will be provided in a later release.
## Future work

* The majority of functions which are calculated within the `.fresh.createfeatures` and `.fresh.significantfeatures` functions are implemented in their entirety in q, however given the use of signal processing libraries and the need at a fundamental level for complex statistical distributions in a number of the functions embedPy has been utilized in the following;

|Function           | Bottlenecks for q implementation |
|-------------------| ---------------------------------|
|aggautocorr        | Requires the calculation of fourier transforms within the autocovariance calculation.|
|augfuller          | Uses a scipy module 'tsa.stattools' named 'adfuller' which completes an augmented dickey fuller test.|
|fftaggreg          | Uses numpy functions 'fft.rfft' and 'abs' to compute a fourier transform, bottlenecked by the lack of complex numbers in q.| 
|fftcoeff           | Similar to 'fftaggreg' with the additional use of real/imag and angle to take specific features from the calculated fourier transform.|
|fisherexact        | Uses 'scipy.stats.fisher`_`exact' given issues with overflow based on the use of factorials.|
|ks2samp            | Uses 'scipy.kstwobign.sf' which is at its core a ‘special’ scipy function for the the calculation of the cumulative distribution function of the kolmogorov distribution.|
|ktaupy             | Currently implemented completely using embedPy given issues with accuracy in the q implementation. |
|lintrend           | 'scipy.stats.t.sf' (Student’s T continuous randomvariable), needed for calculation of stderr.|
|numcwtpeaks        | Requires the scipy.signal function 'find_peaks_cwt' which applys a ‘ricker’ wavelet to the data.|
|partautocorrelation| Requires the creation in q of a levinson-durbin recursion algorithm.|
|spktwelch          | Calculation of the power spectrum requires a fourier transform at its backend.|

These functions will in so far as is possible be translated into q to remove dependencies on embedPy in the coming months. 

* Parallelization of both the feature extraction and significance tests is still to be implemented.

* Functions will continue to be added to the `.fresh.feat` namespace to increase the number of features being created.

* The methods of interpolation and generalized filling are yet to be generalized to allow them to be applied by symbol/date etc.

