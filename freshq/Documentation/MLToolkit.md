---
hero: <i class="fa fa-share-alt"></i> Machine learning

author: Conor McCarthy

title: FreshQ: a feature extraction and feature significance toolkit

date: August 2018

keywords: machine learning, ml, feature extraction, feature selection, time series forecasting, interpolation

---

# Fresh.q 

Feature extraction and selection are vital components of the machine learning pipeline. Here we outline an implementation of the FRESH (FeatuRe Extraction and Scalable Hypothesis testing) algorithm[1]. This provides the opportunity to explore structured datasets in depth and to extract the most relevant features for predicting a target vector. 

Feature extraction at a basic level is the process by which from an initial dataset we build derived values/features which may be informative when passed to a machine learning algorithm. It allows for information which may be pertinent to the prediction of an attribute of the system under investigation to be extracted. This information is often easier to interpret than the time series in its raw form. It also offers the chance to apply less complex machine learning models to our data as the important trends in the data do not have to be extracted from the data via more complex methods.

Following feature extraction statistical significance tests between the feature and target vectors. This is required as within the features extracted from the initial data there may only be a small subsection of features of importance. Once statistical tests have been completed to find the relevance of features
the Benjamini-Hochberg-Yekutieli procedure is applied to set a threshold for the features which are deemed to be important. 

The purpose of feature selection from the standpoint of improving the accuracy of a machine learning algorithm are as follows

- Simplify the models being used thus making them easier to interpret.
- Shortens the time needed to train a model.
- Helps to avoid the curse of dimensionality.
- Reduces variance in the dataset to reduce overfitting.

Within this library functions to complete binned/interpolation, create rolled tables, produce polynomial features from input data and fill data in a tailored manner are also provided. These allow a user to format their data correctly for the application of the FreshQ algorithm which anticipates data to be absent of nulls and with an equi-spaced structure.

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

---

# ML utils 

The section below will need to be split into a separate section but this will need to be done once a final structure has been formulated next week.

Within machine learning applications a number of procedures and analyses are ubiquitous, for example the production of confusion matrices in classification problems, creation of ROC curves, the need to fill null data in a tunable manner and the use of interpolation to fix an equal spacing between data points.

The library contains 4 main sections.

1. funcs.q: this contains functions that are used commonly in ML applications (train test split, array production etc.)
2. stats.q: statistical functions for measuring the success of a machine learning model (correlation matrices, mean square error, roc curves etc.)
3. graphics.q: contains self contained graphics functions for the production of ROC curves/confusion matrices.
4. preprocess.q: includes functions useful in the preprocessing of data, such as polynomial feature creation, linear interpolation, tailored filling of nulls and min-max scaling

The functions within folder are contained within the `.ml` namespace and can be used in conjunction with the FreshQ library to get the best from this library.

## preprocess.q

The functions contained in this script are related to the preprocessing of data prior to application of machine learning algorithms or feature engineering. The following table gives a brief explanation of the utils supplied to date;

|Function                   | Description |
|---------------------------| ---------------------------------|
|binarizer(tab;tval)        | Binarize a table based on a threshold value tval|
|onehot(x)                  | Enlist a list of symbols via one hot encoding|
|checknulls(tab)            | Find columns within a table that contain any null values|
|dropconstant(tab)          | Remove columns with zero variance|
|minmaxscaler(tab)          | Scale data between 0-1 |
|stdscaler(tab)             | (x- avg x)%dev x|
|tablerolldrop(tab;id;roll) | Create forecasting frame based on an 'id' column with a specified number (roll) of values within each frame|
|polytab(tab;n;k)           | Produce polynomial features from the table with n the degree of polynomial to be produced and k the number of leading columns which polynomial features are not created on.|
|powerset(tab;k)            | Create all possible polynomial features which could be produced from the table, here k is the number of leading columns which polynomials are not produced on.|
|tabfnlin(tab;tcol;dif;dict)| Allows for linear interpolation given time differences defined by dif, default behaviour can be overridden by modification to dict. Binary features default to forward filling.|
|tabfnbin(tab;tcol;dif;dict)| Default behaviour is to fill type interpolate data based on defined time difference, linear interpolation can be enforced through modification of dict |
|fillfn(tab;tcol;dict)      | Used in the  |

### Forecasting frames

When dealing with time-series forecasting using historical data a unique id may not be immediately available or obvious. The following function can be used to produce a table which contains sets of unique ids derived from the data by expanding the data such that for each date we have introduced the n previous days into the same window. Here n is the length of the desired window. 

#### `.ml.tablerolldrop`

Syntax:  `.ml.tablerolldrop[table;id;roll]`

Requirements:
- The id column must not contain the value 0 as this will hinder the production of the forecasting frame in its current form.

Inputs:
- table: (type = unkeyed table) This is the table you wish to produce a ‘forecasting frame’ on.
- id: (type = symbol) This is the id column containing the data from which we produce the forecasting frame.
- roll: (type = int) The size of the forecasting windows which are to be produced from the original table.

Return:
- Returns a table containing the requested forecasting frame with the unique ids based on the requested id and a maximum length for the derived id given by the roll.
- The table returned does not contain incomplete forecasting frames with incomplete windows being dropped from the start of the table and the last window being dropped as forecasting cannot be tested on the (n+1)th id.

Sample Code:
```q
q)show amzndaydata:{lower[cols x]xcol x}("DFFFFJJ";enlist ",")0:`amzn_day.us.txt

date       open high low  close volume   openint
------------------------------------------------
1997.05.16 1.97 1.98 1.71 1.73  14700000 0      
1997.05.19 1.76 1.77 1.62 1.71  6106800  0      
1997.05.20 1.73 1.75 1.64 1.64  5467200  0      
1997.05.21 1.64 1.65 1.38 1.43  18853200 0      
1997.05.22 1.44 1.45 1.31 1.4   11776800 0      
1997.05.23 1.41 1.52 1.33 1.5   15937200 0

q)-1!"This dataset contains stock information for ",(string count amzndaydata)," days."
"This dataset contains stock information for 5170 days."

q)show tabinit:.ml.tablerolldrop[amzndaydata;`date;3]

date       open high low  close volume   openint
------------------------------------------------
t1997.05.20 1.97 1.98 1.71 1.73  14700000 0      
t1997.05.20 1.76 1.77 1.62 1.71  6106800  0      
t1997.05.20 1.73 1.75 1.64 1.64  5467200  0      
t1997.05.21 1.64 1.65 1.38 1.43  18853200 0      
t1997.05.21 1.44 1.45 1.31 1.4   11776800 0      
t1997.05.21 1.41 1.52 1.33 1.5   15937200 0

q)-1"The forecasting frame contains ",(string count tabinit)," datapoints.";
“The forecasting frame contains 15501 datapoints.”
```

### Polynomial Features

#### Individual Polynomial Features
Aside from the original dataset it may also be useful to produce polynomial features from the dataset, for example for a table with feature columns x,x1,x2 it may be useful to have information on features of the form `x*x1,x*x2,x*x1*x2` for example as the these may be more important than the original features to predictions of our target vector. In the implementation described below this is completed without repetition (i.e. produce `x*x1` but not `x1*x` etc.)

Syntax:  `.ml.polytab[tab;deg;ncols]`

Inputs:
- table: (type = unkeyed table) This is the table we are producing the polynomial features from.
- deg: (type = int) This is the degree of the polynomial features to be produced (2,3...)
- ncols: (type = int) This is the numerical value of the number of columns which must be dropped from the from of the data (time/sym columns) which we do not produce features on.

Return:
- Returns an unkeyed table with the same number of rows as the original dataset and the relevant polynomial features which should be produced given the degree stated at input.

```q
q)show 5#tab:([]sym:450000?`1;time:`#asc 450000?00:30:00.000;val:sin 0.001*til 450000;
  til 450000;450000?100f;450000?1000f;450000?10)

sym time         val          x  x1       x2       x3
-----------------------------------------------------
d   00:00:00.001 0            0  52.26479 990.7741 1 
i   00:00:00.006 0.0009999998 1  2.740491 52.11973 1 
h   00:00:00.007 0.001999999  2  42.23458 967.8194 8 
j   00:00:00.007 0.002999996  3  23.54108 337.9137 0 

q)5#.ml.polytab[tab;2;2]

val_x        val_x1      val_x2     val_x3       x_x1     x_x2     x_x3 x1_x2..
-----------------------------------------------------------------------------..
0            0           0          0            0        0        0    51782..
0.0009999998 0.002740491 0.05211972 0.0009999998 2.740491 52.11973 1    142.8..
0.003999997  0.08446911  1.935637   0.01599999   84.46917 1935.639 16   40875..
0.008999987  0.07062314  1.01374    0            70.62325 1013.741 0    7954...
0.01599996   0.2569871   2.354285   0.01999995   256.9878 2354.291 20   37814..

q)5#.ml.polytab[tab;3;2]

val_x_x1    val_x_x2   val_x_x3     val_x1_x2 val_x1_x3   val_x2_x3  x_x1_x2 ..
-----------------------------------------------------------------------------..
0           0          0            0         0           0          0       ..
0.002740491 0.05211972 0.0009999998 0.1428336 0.002740491 0.05211972 142.8337..
0.1689382   3.871275   0.03199998   81.75084  0.6757529   15.4851    81750.9 ..
0.2118694   3.041219   0            23.86453  0           0          23864.57..
1.027948    9.41714    0.07999979   151.2556  1.284935    11.77143   151256  ..

/To convert this to a format that is correct for the extraction procedure to operate we would have

q)show 5#newtab:tab^.ml.polytab[tab;2;2]^.fresh.preproc.polytab[tab;3;2]

sym time         val          x  x1       x2       x3 val_x        val_x1    ..
-----------------------------------------------------------------------------..
d   00:00:00.001 0            0  52.26479 990.7741 1  0            0         ..
i   00:00:00.006 0.0009999998 1  2.740491 52.11973 1  0.0009999998 0.00274049..
h   00:00:00.007 0.001999999  2  42.23458 967.8194 8  0.003999997  0.08446911..
j   00:00:00.007 0.002999996  3  23.54108 337.9137 0  0.008999987  0.07062314..
l   00:00:00.008 0.003999989  4  64.24694 588.5728 5  0.01599996   0.2569871 ..
```

#### Power Set
In conjunction with the production of individually chosen polynomial features based on the 'degree' of interest it is also possible to produce the so called `Power Set` which is defined as all possible polynomials features which could be produced from the dataset in question.

The function used to produce this power set is as follows;

Syntax:  `.ml.powerset[tab;ncols]`

Inputs:
- table: (type = unkeyed table) This is the table we are producing the polynomial features from.
- ncols: (type = int) This is the numerical value of the number of columns which must be dropped from the front of the data (time/sym columns) from which we do not produce features.

Return:
- Returns an unkeyed table with the same number of rows as the original dataset and the relevant polynomial features which should be produced given the degree stated at input.

```q
q)show 3#amzndaydata:{lower[cols x]xcol x}("DFFFFJJ";enlist ",")0:`:SampleDatasets/amzn_day.us.txt

date       open high low  close volume   openint
------------------------------------------------
1997.05.16 1.97 1.98 1.71 1.73  14700000 0      
1997.05.19 1.76 1.77 1.62 1.71  6106800  0      
1997.05.20 1.73 1.75 1.64 1.64  5467200  0      
1997.05.21 1.64 1.65 1.38 1.43  18853200 0      

q)\l freshpreprocess.q

q)show 3#k:.ml.powerset[amzndaydata;1]

date       open high low  close volume   openint open_high open_low open_clos..
-----------------------------------------------------------------------------..
1997.05.16 1.97 1.98 1.71 1.73  14700000 0       3.9006    3.3687   3.4081   ..
1997.05.19 1.76 1.77 1.62 1.71  6106800  0       3.1152    2.8512   3.0096   ..
1997.05.20 1.73 1.75 1.64 1.64  5467200  0       3.0275    2.8372   2.8372   ..

/to show that all the power set polynomials are being produced.

q)reverse cols k

`open_high_low_close_volume_openint`high_low_close_volume_openint`open_low_cl..
```


**Notes:** 
* Within the application of this procedure it should be noted that the number of columns produced will expand rapidly with increases in the number of the input columns. It is suggested that polynomials greater than 3 not be used in the majority of cases. 

* High degree polynomials particularly in cases of financial data can also lead to overflow as individual values in the data can be large, as such care should be taken when creating polynomial features in datasets containing large values.

* The naming of polynomial features has been set to be delimited by an underscore to maintain consistency with the naming convention used in `.fresh.createfeatures`

### Interpolation Methods and Data Filling

One important characteristic of data used in this form of feature extraction and selection is that the functions being calculated expect equi-spaced time steps in order to be most effective particularly in the calculation of fourier transforms for example. To facilitate this two methods of interpolation have been provided, linear interpolation and a fills type interpolation. The form of interpolation implemented should be case specific and may vary on a column by column basis, this has been facilitated within the two functions provided.

Alongside the need for the data to where feasible and logical be equi-spaced, the data should also be complete and as such a function which can allow a number of filling methods to be implemented at the same time has been provided. 

It should be noted that the functions provided currently are early version implementations and while they have been designed to be as generalized as possible modifications may have to be made on a user by user basis to ensure that the data is being filled correctly 

All the functions outlined here are set to maintain their default behaviours unless modifications the following dictionary are made.

```q
dict:.ml.dict:``zero`median`mean`fill`linear!(::;0n;0n;0n;0n;0n)
```
Examples of the effect that modifications to this function have on the behaviour of the functions are shown in the below sections.
#### Linear Interpolation
The function which controls linear interpolation can be seen below. This function defaults to maintain a behaviour where columns that only contain 2 values (binary features) will be forward filled at equi-spaced times and all remaining columns will be linearly interpolated unless the fill key of dict above is modified.

##### `.ml.tabfnlin`

Syntax:  `.ml.tabfnlin[tab;tcol;t_diff;dict]`

Inputs:
- tab: (type = unkeyed table) This is the table we are interpolating the data on.
- tcol: (type = symbol) This is the column containing the time data from which the interpolation is produced.
- t`_`diff: (type = timespan) This should be set as the time desired time between timesteps
- dict: (type = dictionary) This is the number of columns which must be removed from the front of the dataset (eg. symbol and time) as these can't be linearly interpolated on.

Return:
- Returns a table containing a linearly interpolated version of the original dataset with interpolations completed for each symbol in the table individually.

```q
q)n:450000

q)5#tab:([]time:`#asc n?00:30:00.000;val:sin 0.001*til n;til n;n?100f;n?1000f)
time         val          n  x        x1
----------------------------------------
00:00:00.006 0            0  17.65111 2 
00:00:00.011 0.0009999998 1  26.1618  2 
00:00:00.014 0.001999999  2  63.13232 1 
00:00:00.016 0.003999989  4  80.96929 1 
00:00:00.017 0.004999979  5  69.30639 2 

q)5#.ml.tabfnlin[tab;`time;00:00:00.002;dict]

time         val          n        x        x1
----------------------------------------------
00:00:00.006 0            0        17.65111 2 
00:00:00.008 0.0003999999 0.4      21.05539 2 
00:00:00.010 0.0007999999 0.8      24.45966 2 
00:00:00.012 0.001333333  1.333333 38.48531 2 
00:00:00.014 0.001999999  2        63.13232 1 

/ modify the dictionary to now also interpolate the column `x
q)dict[`fill]:`x

q).ml.tabfnlin[tab;`time;00:00:00.002;dict]
time         val          n        x        x1
----------------------------------------------
00:00:00.006 0            0        17.65111 2 
00:00:00.008 0.0003999999 0.4      17.65111 2 
00:00:00.010 0.0007999999 0.8      17.65111 2 
00:00:00.012 0.001333333  1.333333 26.1618  2 
00:00:00.014 0.001999999  2        63.13232 1
```

### Fills Interpolation
The function which controls defaulted fills like interpolation can be seen below. Unlike the linear interpolation function this functions default behaviour is to forward fill all columns in the dataset unless specified not to exhibit this behaviour. As with the linear form of interpolation this default behaviour can be supressed by modifying the linear key of dict as shown in the example below.

#### `.ml.tabfnbin`

Syntax:  `.ml.tabfnbin[tab;tcol;t_diff;dict]`

Inputs:
- tab: (type = unkeyed table) This is the table we are interpolating the data on.
- tcol: (type = symbol) This is the column containing the time data from which the interpolation is produced.
- t`_`diff: (type = timespan) This should be set as the time desired time between timesteps
- dict: (type = dictionary) This is the number of columns which must be removed from the front of the dataset (eg. symbol and time) as these can't be linearly interpolated on.

Return:
- Returns a table containing a linearly interpolated version of the original dataset with interpolations completed for each symbol in the table individually.

```q
q)n:450000

q)5#tab:([]time:`#asc n?00:30:00.000;val:sin 0.001*til n;til n;n?100f;n?1 2)
time         val          n x        x1
---------------------------------------
00:00:00.011 0            0 36.80754 2 
00:00:00.013 0.0009999998 1 70.03546 1 
00:00:00.014 0.001999999  2 36.91628 1 
00:00:00.016 0.002999996  3 71.89353 2 
00:00:00.020 0.003999989  4 44.62133 2 

q)5#.ml.tabfnbin[tab;`time;00:00:00.002;dict]

time         val          n  x        x1
----------------------------------------
00:00:00.011 0            0  36.80754 2 
00:00:00.013 0.0009999998 1  70.03546 1 
00:00:00.015 0.001999999  2  36.91628 1 
00:00:00.017 0.002999996  3  71.89353 2 
00:00:00.019 0.002999996  3  71.89353 2 

/ modify the dictionary to linearly interpolate the columns `val`x
q)dict[`linear]:`val`x

q)5#.ml.tabfnlin[tab;`time;00:00:00.002;dict]
time         val          n  x        x1
----------------------------------------
00:00:00.011 0            0  36.80754 2 
00:00:00.013 0.0009999998 1  70.03546 1 
00:00:00.015 0.002499997  2  54.40491 1 
00:00:00.017 0.003249994  3  65.07548 2 
00:00:00.019 0.003749991  3  51.43938 2 

```

### Filling nulls
The datasets which are passed to the feature extraction procedure should not contain contain null values in order to insure that the values calculated from each of the functions are non full unless this is the output from the function. 

The function described below takes in a dictionary defined in the `.fresh` namespace as `.ml.dict`. The dictionary defaults such that all columns will be forward filled. As shown below modifications of this dictionary can made to change the form of filling that is being completed.

If null values are present at the start of a column and have not been filled based on the outline from the dictionary or the default behaviour, the filled column is then back filled to catch any missing nulls.

Note: Linear interpolation should not be completed on columns that do not contain null values, as the function expects nulls to be present in the dataset. As such to check the columns that linear interpolation can be completed on a function `.ml.checknulls[tab]` is supplied.

#### `.ml.fillfn`

Syntax:  `.ml.fillfn[table;time;dict]`

Inputs:
- table: (type = unkeyed table) This is the table we are interpolating the data on.
- time: (type = symbol) This is the column containing the time data from which the interpolation is produced.
- dict: (type = dictionary) This is a dictionary defined by the user into which the column  for different types of interpolation are defined.

Return:
- Returns a table containing a linearly interpolated version of the original dataset with interpolations completed for each symbol in the table individually.

```q
q)n:1000000

q)show tab:([]time:asc n?10:00:00.000;@[n?1000f;2+til 3;:;0n];@[n?1000f;(100?10000),til 3;:;0n];@[n?1000f;(100?10000);:;0n])
time         x        x1       x2      
---------------------------------------
00:00:00.041 538.7384          692.6751
00:00:00.091 613.7786          800.4231
00:00:00.103                   934.321 
00:00:00.154          895.7309 991.6671
00:00:00.216          288.4304 963.1538
00:00:00.293 618.6048 164.5617 252.6422
00:00:00.374 145.8393 440.5396         
00:00:00.380 473.4236 286.6571 107.0687

q).ml.checknulls[tab]

`x`x1`x2

q)show dict:.ml.dict
      | ::
zero  | 0n
median| 0n
mean  | 0n
fill  | 0n
linear| 0n

q)8#.ml.fillfn[tab;`time;dict]
time         x        x1       x2      
---------------------------------------
00:00:00.041 538.7384 895.7309 692.6751
00:00:00.091 613.7786 895.7309 800.4231
00:00:00.103 613.7786 895.7309 934.321 
00:00:00.154 613.7786 895.7309 991.6671
00:00:00.216 613.7786 288.4304 963.1538
00:00:00.293 618.6048 164.5617 252.6422
00:00:00.374 145.8393 440.5396 252.6422
00:00:00.380 473.4236 286.6571 107.0687

q)dict[`linear]:`x

q)dict[`median]:`x1

q)8#.ml.fillfn[tab;`time;dict]
time         x        x1       x2      
---------------------------------------
00:00:00.041 538.7384 500.079  692.6751
00:00:00.091 613.7786 500.079  800.4231
00:00:00.103 614.0653 500.079  934.321 
00:00:00.154 615.2838 895.7309 991.6671
00:00:00.216 616.7651 288.4304 963.1538
00:00:00.293 618.6048 164.5617 252.6422
00:00:00.374 145.8393 440.5396 252.6422
00:00:00.380 473.4236 286.6571 107.0687

```

