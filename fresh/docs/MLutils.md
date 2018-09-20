---
hero: <i class="fa fa-share-alt"></i> Machine learning

author: Conor McCarthy

title: ML Utils

date: October 2018

keywords: machine learning, ml, utilities, interpolation, filling, statistics

---
# Utils 

## Overview

Within machine learning applications a number of procedures and analyses are ubiquitous, for example the production of confusion matrices in classification problems, creation of ROC curves, the need to fill null data in a tunable manner and the use of interpolation to fix an equal spacing between data points.

The utility functions presently contained in the ML-Toolkit contains 3 main sub-sections.

1. funcs.q: this contains functions that are used commonly in ML applications (train test split, array production etc.)
2. stats.q: statistical functions for measuring the success of a machine learning model (correlation matrices, mean square error, roc curves etc.)
3. preprocess.q: includes functions useful in the preprocessing of data, such as polynomial feature creation, linear interpolation, tailored filling of nulls and min-max scaling

The functions within folder are contained within the `.ml` namespace and can be used in conjunction with the those in the FRESH section of the ML-Toolkit to apply machine learning techniques to time-series data.

This library of functions can be accessed [here](Include link to Toolkit in GIT)

## Statistical analysis

Within `stats.q` are a variety of functions used for analysing the results garnered from machine learning algorithms. These are vital to testing the validity of the models used and techniques employed by a user. The following table shows the functions that currently exist within the `stats.q` script.

(probably should add pointers to the function definitions/syntax in the table)

|Function                   | Description |
|---------------------------| ---------------------------------|
|accuracy(x;y)              | Compute the accuracy of classification results between vectors x and y.|
|mse(x;y)                   | Calculate mean square error between of two continous vectors x and y.|
|sse(x;y)                   | Calculate sum squared error between of two continous vectors x and y.|
|cvm(x)                     | Compute a covariance matrix for an input matrix x.|
|crm(x)                     | Compute a correleation matrix for an input matrix x.|
|corrmat(tab)               | Create a table like correlation matrix for a input unkeyed table.|
|confmat(x;y)               | Produce a confusion matrix given x a vector of the predicted labels and y the true labels in a classification problem.|
|confdict(x;y)              | Given x the predicted label and y the true labels, produce a dictionary of true/false positives and true/false negative.|
|describe(tab)              | For an input table this produces descriptive information about the table including the mean, quartiles, and deviation.|
|crossentropy(x;y)          | Calculates the categorical cross entropy between a set of unique class labels x and the probability of belonging to a class y.|
|logloss(x;y)               | This calculates the log loss given actual classes x (0/1) and the probability of belonging to the assigned class.|
|precision(x;y;z)           | Calculate the precision of a binary classifier where x is prediction, y are real labels and z is the positive labels value.|
|sensitivity(x;y;z)         | Calculate the sensitivity of a binary classifier where x is prediction, y are real labels and z is the positive labels value.|
|specificity(x;y;z)         | Calculate the specificity of a binary classifier where x is prediction, y are real labels and z is the positive labels value.|
|roc(x;p)                   | Compute the x and y axis values for an ROC curve given x the actual class and p the probability of the class belonging to the positive class.|
|rocaucscore(x;y)           | Computes the area of under an ROC curve produced using roc(x;p) above with the same inputs.|
|tscore(x;y)                | Calculate the one sample t-test score for a distribution x with sample mean y.|
|tscoreeq(x;y)              | Compute a t-test for 2 independent samples x and y with undequal variances.|

An example of the operation of each of these functions and a description of their use can be seen below.

### .ml.accuracy

Syntax: `.ml.accuracy[x;y]`

Returns the accuracy of predictions made by a machine learning algorithm

Where 
* `x` is a vector of predicted values and `y` are the true values of the quantity being predicted

```q
q)xb:rand each 100#0b
q)yb:rand each 100#0b
q).ml.accuracy[xb;yb] /example of running on boolean data
0.53

q)xr:10000?5
q)yr:10000?5
q).ml.accuracy[xr;yr] /example of running on non-binary categorical data
0.2014
```

### .ml.mse

Syntax: `.ml.mse[x;y]`

Returns the mean squared error between predicted values and the true values in a machine learning application.

Where 
* `x` is a vector of predicted values and `y` are the true values of the quantity being predicted


```q
q)x:asc 50?50f
q)y:asc 50?50f
q).ml.mse[x;y]
452.4079
```

### .ml.sse

Syntax: `.ml.mse[x;y]`

Returns the sum squared error between predicted values and the true values in a machine learning application.

Where 
* `x` is a vector of predicted values and `y` are the true values of the quantity being predicted


```q
q)x:asc 50?50f
q)y:asc 50?50f
q).ml.sse[x;y]
22620.4
```

### .ml.cvm

Syntax: `.ml.cvm[x]`

Returns the covariance matrix given a matrix input `x`

```q
q)matrix:(3 4)#100?10f
q).ml.cvm[matrix]
9.6875  -0.1875 0.125 
-0.1875 4.1875  -3.875
0.125   -3.875  4.25  
```

### .ml.crm

Syntax: `.ml.crm[x]`

Returns the correlation matrix given a matrix input `x`

```q
q)matrix:(3 4)#100?10f
q).ml.crm[matrix]
1           -0.02943866 0.01948093
-0.02943866 1           -0.9185437
0.01948093  -0.9185437  1         
```

### .ml.corrmat

Syntax: `.ml.corrmat[x]`

Returns a correlation matrix given a tabular input `x` containing numeric values

```q
q)n:10000
q)tab:([]asc n?100f;reverse asc n?1000f;n?100)
q).ml.corrmat[tab]
  | x            x1          x2          
- | -------------------------------------
x | 1            -0.9999644  -0.004584063
x1| -0.9999644   1           0.004535739 
x2| -0.004584063 0.004535739 1           
```

### .ml.confmat

Syntax: `.ml.confmat[x;y]`

Returns a 2 x 2 confusion matrix

Where
* `x` is a vector binary vector of predicted labels and `y` is a binary vector of the true labels in a classification problem.

```q
q)xb:rand each 100#0b
q)yb:rand each 100#0b
q).ml.confmat[xb;yb]
0| 34 19
1| 28 19
```

### .ml.confdict

Syntax: `.ml.confdict[x;y]`

Returns the true positives, true negatives, false positives and false negatives from a confusion matrix in the form of a dictionary

Where
* `x` is a vector binary vector of predicted labels and `y` is a binary vector of the true labels in a classification problem.

```q
q)xb:rand each 100#0b
q)yb:rand each 100#0b
q).ml.confdit[xb;yb]
tp| 34
fn| 19
fp| 28
tn| 19
```

### .ml.describe

Syntax: `.ml.describe[x]`

Returns a table describing features of an input table `x` such as mean, standard deviation and quartile information.

```q
q)tab:([]x:n?10000f;x1:1+til n;x2:reverse til n;x3:n?100f)
q).ml.describe[tab]
     | x        x1       x2       x3       
-----| ------------------------------------
count| 1000     1000     1000     1000     
mean | 4953.491 500.5    499.5    49.77201 
std  | 2890.066 288.8194 288.8194 28.91279 
min  | 7.908894 1        0        0.1122762
q1   | 2491.828 250.75   249.75   24.38531 
q2   | 5000.222 500.5    499.5    49.96016 
q3   | 7453.287 750.25   749.25   74.98685 
max  | 9994.308 1000     999      99.98165 
```

### .ml.crossentropy

Syntax: `.ml.crossentropy[x;y]`

Returns the categorical cross entropy where `x` is a set of unique class labels `y` is the probability of belonging to one specific class 


```q
q)x:1000?10
q)y:1000?1f
q).ml.crossentropy[x;y]
1.000794
```

### .ml.logloss

Syntax: `.ml.logloss[x;y]`

Returns the logarithmic-loss for a binary classifier

Where
* `x` is a set of the classes 0/1
* `y` is a matrix with the first row giving the probability that each class element x belongs to class 0 and the second row is the probability if belongs to class 1

```q
q)x:rand each 1000#0b
q)k:1000?1f
q)y:flip (k;1-k)
q).ml.logloss[x;y]
1.024205
```


### .ml.precision

Syntax: `.ml.precision[x;y;z]`

Returns a measure of the precision associated with a classification problem

Where
* `x` is the predicted binary label
* `y` is the true binary classification label
* `z` is the binary value defined to be true

```q
q)xb:rand each 100#0b
q)yb:rand each 100#0b
q).ml.precision[xb;yb;1b]
0.5090909
```

### .ml.sensitivity

Syntax: `.ml.sensitivity[x;y;z]`

Returns a measure of the sensitivity associated with a classification problem

Where
* `x` is the predicted binary label
* `y` is the true binary classification label
* `z` is the binary value defined to be true

```q
q)xb:rand each 100#0b
q)yb:rand each 100#0b
q).ml.sensitivity[xb;yb;1b]
0.5957447
```

### .ml.specificity

Syntax: `.ml.specificity[x;y;z]`

Returns a measure of the specificity associated with a classification problem

Where
* `x` is the predicted binary label
* `y` is the true binary classification label
* `z` is the binary value defined to be true

```q
q)xb:rand each 100#0b
q)yb:rand each 100#0b
q).ml.specificity[xb;yb;1b]
0.490566
```

### .ml.roc

Syntax: `.ml.roc[x;y]`

Returns the coordinates of the true positive and false positive values associated with the ROC curve 

Where
* `x` is the label associated with a prediction
* `y` is the probability that a prediction belongs to the positive class.

```q
q)x:rand each 1000#0b
q)y:asc 1000?1f
q).ml.roc[x;y]
0           0.002012072 0.004024145 0.004024145 0.004024145 0.00603..
0.001988072 0.001988072 0.001988072 0.003976143 0.005964215 0.00596..
```

### .ml.rocaucscore

Syntax: `.ml.rocaucscore[x;y]`

Returns the area under ROC curve

Where
* `x` is the label associated with a prediction
* `y` is the probability that a prediction belongs to the positive class.

```q
q)x:rand each 1000#0b
q)y:asc 1000?1f
.ml.rocaucscore[x;y]
0.5532959
```

### .ml.tscore

Syntax: `.ml.tscore[x;y]`

Returns the one sample t-score for a distribution with less than 30 samples

Where
* `x` is a distribution of values
* `y` is the population mean

```q
q)x:25?100f
q)y:15
q).ml.tscore[x;y]
7.634824
```
### .ml.tscoreeq

Syntax: `.ml.tscoreeq[x;y]`

Returns the t-test score of 2 independent sample distributions `x` and `y` with non equal variance

```q
q)n:1000
q)x:{x,(sum 20?1f) - 10}/[{not n~count x};()]  /Gaussian distribution
q)y:{x,(sum 20?1f) - 10}/[{not n~count x};()]
q).ml.tscore[x;y]
1.106935
```



## Data preprocessing

The functions contained in the script preprocess.q are related to the preprocessing of data prior to application of machine learning algorithms or feature engineering. The following table gives a brief explanation of the utilities supplied within this script to date;

|Function                   | Description |
|---------------------------| ---------------------------------|
|onehot(x)                  | Encode a list of symbols via one hot encoding.|
|checknulls(tab)            | Find columns within a table that contain any null values.|
|dropconstant(tab)          | Remove columns from a table which have zero variance.|
|minmaxscaler(tab)          | Scale data containted in a table between 0-1.|
|stdscaler(tab)             | Produce a standard scaler transform based representation of the input table.|
|tablerolldrop(tab;id;roll) | Create forecasting frame based on an 'id' column with a specified number (roll) of values within each frame.|
|polytab(tab;n;k)           | Produce polynomial features from the table with n the degree of polynomial to be produced and k the number of leading columns which polynomial features are not created on.|
|powerset(tab;k)            | Create all possible polynomial features which could be produced from the table, here k is the number of leading columns which polynomials are not produced on.|
|tabfnlin(tab;tcol;dif;dict)| Allows for linear interpolation given time differences defined by dif, default behaviour can be overridden by modification to dict. Binary features default to forward filling.|
|tabfnbin(tab;tcol;dif;dict)| Default behaviour is to fill type interpolate data based on defined time difference, linear interpolation can be enforced through modification of dict.|
|fillfn(tab;tcol;dict)      | Used in the  tailored filling of null values within the an unkeyed table, this defaults to forward fill all data unless specified in dict.|

The following are examples of the operation of each of the functions contained in the preprocessing section of the machine learning utilities.

### .ml.onehot

Syntax: `.ml.onehot[x]`

Returns a one hot encoded representation of an input list of symbols `x`.

```q
q)x:`a`a`b`b`c`a
q).ml.onehot[x]
1 0 0
1 0 0
0 1 0
0 1 0
0 0 1
1 0 0
```

### .ml.checknulls

Syntax: `.ml.checknulls[x]`

Returns a list of the columns within a table of numerical values `x` that contain null values.

```q
q)tab:([]1 2 3 4 0N 6;6?10f;1.2 2.4 3.6 4.8 0n 7.2)
q).ml.checknulls[tab]
`x`x2
```

### .ml.dropconstant

Syntax: `.ml.dropconstant[x]`

Returns given an input numerical table `x` a table where all columns that contain zero variance have been removed

```q
q)n:1000
q)3#tab:([]n?100f;n#0n;n?1000;n#10;n#0N)
x        x1 x2  x3 x4
---------------------
27.05226    482 10   
90.72252    845 10   
84.72851    971 10   

q)3#.ml.dropconstant[tab]
x        x2 
------------
27.05226 482
90.72252 845
84.72851 971
```

### .ml.minmaxscaler

Syntax: `.ml.minmaxscaler[x]`

Returns for an input numerical table `x` a min-max scaled representation of the table with values in the table scaled between 0 and 1

```q
q)n:5
q)tab:([]n?100f;n?1000;n?100f;n?50f)
x        x1  x2       x3       
------------------------------
5.131717 681 43.96318 23.40407
50.60375 752 71.45967 40.97883
34.9319  312 71.68448 37.79269
71.23945 858 35.90727 13.17263
43.51838 399 85.67067 32.51957

q).ml.minmaxscaler[tab]
x         x1        x2        x3       
---------------------------------------
0         0.6758242 0.1618843 0.3679552
0.6878474 0.8058608 0.7144287 1        
0.450782  0         0.7189462 0.885416 
1         1         0         0        
0.5806683 0.1593407 1         0.6957777
```

### .ml.stdscaler

Syntax: `.ml.stdscaler[x]`

Returns for an input numerical table `x` a representation of the table where each column has undergone a standard scaling given as `[x-avg x]%dev x`

```q
q)n:5
q)tab:([]n?100f;n?1000;n?100f;n?50f)
x        x1  x2       x3       
------------------------------
5.131717 681 43.96318 23.40407
50.60375 752 71.45967 40.97883
34.9319  312 71.68448 37.79269
71.23945 858 35.90727 13.17263
43.51838 399 85.67067 32.51957

q).ml.stdscaler[tab]
x          x1         x2         x3       
---------------------------------------
-1.663252  0.3846187  -0.9502199 -0.6088642
0.4403491  0.7234267  0.5197869  1.125582  
-0.2846532 -1.376229  0.5318052  0.8111424 
1.394986   1.229253   -1.380902  -1.618601 
0.11257    -0.9610695 1.27953    0.2907405 

```

## General functions
The functions contained within the script funcs.q are general use functions which are commonly used in machine learning applications, these range from splitting data into train/test sets to the conversion of tabular data to a matrix. The following table gives an outline of the currently implemented functions contained within this script

|Function                        | Description |
|--------------------------------| ---------------------------------|
| arange(x;y;z)                  | Produces evenly spaced values between x and y in steps of length z.|
| linspace(x;y;z)                | Creates an array of z evenly spaced values between x and y.|
| range(x)                       | Calculate the range of values in an 1D array x.|
| shape(x)                       | Outputs the shape of an array x.|
| traintestsplit(x;y;sz)         | Splits data x and target y into training and test sets where sz is the % of data in test.|
| traintestsplitseed(x;y;sz;seed)| Split data and target into train and test sets as previously but with a seed set by user.|
| times2long(tab)                | Covert times in a table to longs.|
| enum(tab)                      | Enumerate any sym files in the table.|
| tab2df(tab)                    | Convert a q table to a pandas dataframe.|
| df2tab(pdtab)                  | Convert a pandas dataframe to a q table.|
| mattab(tab)                    | Produces a matrix representation of an unkeyed table for passing to a machine learning algorithm.|

The following is an example of the operation of each of the functions contained in the general functions (funcs.q) script each function contained in the .ml namespace.

### .ml.arange

Syntax: `.ml.arange[x;y;z]`

Returns an evenly spaced array of values between `x` and `y` in steps of length `z`.
```q
q).ml.arange[1;10;1]
1 2 3 4 5 6 7 8 9
q).ml.arange[6.25;10.5;0.05]
6.25 6.3 6.35 6.4 6.45 6.5 6.55 6.6 6.65 6.7 6.75 6.8 6.85 6.9 6.95 7 7.05 7...
```

### .ml.linspace

Syntax: `.ml.linspace[x;y;z]`

Returns an array of `z` evenly spaced values between `x` and `y`.

```q
q).ml.linspace[10;20;9]
10 11.25 12.5 13.75 15 16.25 17.5 18.75 20
q).ml.linspace[0.5;15.25;12]
0.5 1.840909 3.181818 4.522727 5.863636 7.204545 8.545455 9.886364 11.22727 1..
```

### .ml.range

Syntax: `.ml.range[x]`

Returns the range of the values contained in a 1D array `x`

```q
q)x:1000?100000f
q).ml.range[x]
99742.37
```

### .ml.shape

Syntax: `.ml.shape[x]`

Returns the shape of a matrix `x` in the format (#rows,#columns)

```q
q)x:(30 20)#1000?10f
q).ml.shape[x]
30 20
```

### .ml.traintestsplit

Syntax: `.ml.traintestsplit[x;y;sz]`

Returns a dictionary containing the data matrix `x` and target `y` split into a training and testing set based on the percentage `sz` of the data to be contained in the test set.  

```q
q)x:(30 20)#1000?10f
q)y:rand each 30#0b
q).ml.traintestsplit[x;y;0.2] / split the data such that 20% is contained in the test set
xtrain| (2.02852 2.374546 1.083376 2.59378 6.698505 6.675959 4.120228 2.63468..
ytrain| 110010100101111001110000b
xtest | (8.379916 8.986609 7.06074 2.067817 5.468488 4.103195 0.1590803 0.259..
ytest | 000001b
```

### .ml.traintestsplitseed

Syntax: `.ml.traintestsplitseed[x;y;sz;seed]`

As with .ml.traintestsplit this returns a dictionary containing the data matrix `x` and target `y` split into a training and testing set based on the percentage `sz` of the data to be contained in the test set. This version can be given a random seed (`seed`), thus alllowing for the same splitting of the data to be repeatedly achieved

```q
q)x:(30 20)#1000?10f
q)y:rand each 30#0b
q).ml.traintestsplitseed[x;y;0.2;42]
xtrain| (8.752061 6.82448 3.992896 2.465234 8.599461 2.452222 6.070236 6.8686..
ytrain| 000011101000001110111101b
xtest | (4.204472 7.137387 1.163132 9.893949 4.504886 5.465625 8.298632 0.049..
ytest | 000001b
```


### .ml.times2long

Syntax: `.ml.times2long[x]`

Returns for an input table `x`, a table where all time columns have been converted to a long representation

```q
q)n:1000
q)3#tab:([]sym:n?`1;time:asc n?00:00:05.000;n?1000f;n?100)
sym time         x        x1
----------------------------
p   00:00:00.002 37.74609 92
a   00:00:00.007 135.1677 73
b   00:00:00.015 838.3428 96


q)3#.ml.times2long[tab]
sym time x        x1
----------------
p   2    37.74609 92
a   7    135.1677 73
b   15   838.3428 96
```

### .ml.enum

Syntax: `.ml.enum[x]`

Returns for an input table `x` and table where columns containing symbols have been enumerated 

```q
q)n:1000
q)5#tab:([]sym:n?`a`b;time:asc n?00:00:05.000;n?1000f;n?100)
sym time         x        x1
----------------------------
b   00:00:00.006 698.6595 12
a   00:00:00.013 671.1112 10
b   00:00:00.013 171.778  1 
b   00:00:00.018 476.7409 90
a   00:00:00.023 341.0811 73

q)5#.ml.enum[tab]
sym time         x        x1
----------------------------
0   00:00:00.006 698.6595 12
1   00:00:00.013 671.1112 10
0   00:00:00.013 171.778  1 
0   00:00:00.018 476.7409 90
1   00:00:00.023 341.0811 73
```

### .ml.tab2df

Syntax: `.ml.tab2df[x]`

Returns a pandas dataframe for a q table input `x`

```q
q)n:5
q)table:([]x:n?10000f;x1:1+til n;x2:reverse til n;x3:n?100f) / q table for input
x        x1 x2 x3      
-----------------------
2631.44  1  4  78.71917
1118.109 2  3  80.09356
3250.627 3  2  16.71013
q)show pdf:.ml.tab2df[table] / convert to pandas dataframe and show it is an embedPy object
{[f;x]embedPy[f;x]}[foreign]enlist 
q)print pdf / display the python form of the dataframe
             x  x1  x2         x3
0  2631.439704   1   4  78.719172
1  1118.109056   2   3  80.093563
2  3250.627243   3   2  16.710134
```

### .ml.df2tab

Syntax: `.ml.df2tab[x]`

Returns a q table for an pandas table input `x`

```q
q)n:3
q)table:([]x:n?10000f;x1:1+til n;x2:reverse til n;x3:n?100f) / q table for input
q)print pdf:.ml.tab2df[table] / convert to pandas dataframe
             x  x1  x2         x3
0  2631.439704   1   4  78.719172
1  1118.109056   2   3  80.093563
2  3250.627243   3   2  16.710134

q).ml.df2tab[pdf] /convert dataframe back to q table
x        x1 x2 x3      
-----------------------
2631.44  1  4  78.71917
1118.109 2  3  80.09356
3250.627 3  2  16.71013
```

### .ml.mattab

Syntax: `.ml.mattab[x]`

Returns a matrix representation of a table `x`, this is often used prior to the injection of data into a machine learning algorithm

```q
q)n:1000

q)5#tab:([]sym:n?`a`b;time:asc n?00:00:05.000;n?1000f;n?100)
sym time         x        x1
----------------------------
b   00:00:00.006 698.6595 12
a   00:00:00.013 671.1112 10
b   00:00:00.013 171.778  1 

q)3#.ml.mattab[tab]
`b 00:00:00.006 698.6595 12
`a 00:00:00.013 671.1112 10
`b 00:00:00.013 171.778  1 
```

(The location of this and it's general presence in the documentation needs to be checked)

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

