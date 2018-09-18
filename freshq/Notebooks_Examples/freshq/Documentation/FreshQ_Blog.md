# FreshQ: Feature Extraction and Time-Series Forecasting  in kdb+

By Conor McCarthy

Following on from the positive response to the seven machine learning JupyterQ notebooks with associated blogs available at https://kx.com/blog/ and the Natural Langauage Processing Library post Kx 25. The machine learning team have recently the second of our machine learning application libraries. This library which is based on the FRESH (Feature Extraction based on Scalable Hypothesis tests) algorithm[1] and appropriately named FreshQ covers the areas of feature extraction and feature significance testing. This provides our users with an ability to perform machine learning tasks easily on time series data and opens up the world of time series forecasting through an integration of q and embedPy. 

Included with this release are a set of notebooks which provide examples of the application of this library on time series data. The first is based on whether the last hour of business tomorrow will be busier than the last hour today based on information collected today. The second notebook is financial in nature and relates to the prediction of the value of tomorrows close price based on historical information from the position of a stock at end of day for the last 10 days of trading. These notebooks give an insight into the potential for this library to be utilised in both regression and classification example relating to time series data.
 
## Background

As outlined in a previous kx blog by Fionnula Carr [2], feature engineering is an essential part of the machine learning pipeline. FreshQ provides the opportunity to explore structured datasets in depth with the goal of extracting the most useful features of dataset.

Feature extraction at a basic level is the process by which from an initial dataset we build derived values/features which may be informative when passed to a machine learning algorithm. It allows for information which may be pertinent to the prediction of an attribute of the system under investigation to be extracted. This information is often easier to interpret than the time series in its raw form. It also offers the chance to apply less complex machine learning models to our data as the important trends in the data do not have to be extracted from the data via a more complex algorithm such as a neural network, the outputs of which are not necessarily easy to interpret.

Following feature extraction, statistical significance tests between the feature and target vectors can be performed. This is advantageous as within the features extracted from the initial data there may only be a small subsection of features which are important to the prediction of the target vector. Once statistical tests have been completed to find the relevance of features the Benjamini-Hochberg-Yekutieli procedure is applied to set a threshold for the features which will be kept for further prediction.

The purpose of feature selection from the standpoint of improving the accuracy of a machine learning algorithm are as follows

- Simplify the models being used thus making them easier to interpret.
- Shortens the time needed to train a model.
- Helps to avoid the curse of dimensionality.
- Reduces variance in the dataset to reduce overfitting.

The application of both feature extraction and feature significance to data provides the chance to improve the accuracy and efficiency of machine learning algorithms as applied to time series data and this is the goal of the FreshQ library.
### Technical Description

At its core the FRESH algorithm is an intuitive model with three primary steps;
1. Time series data, segmented based on a unique 'ID' column (hour/date/test run etc.) is passed to the feature extraction procedure which calculates 1000s of features for each ID.
2. The table containing the extracted features is then passed to a set of feature significance hypothesis tests to calculate their p-values.
3. Given the p-values calculated for each of the features when compared to the target vector, complete the Benjamini-Hochberg-Yekutieli procedure to filter out statistically insignificant features.

#### **Feature Creation**
Among the features calculated in the feature extraction procedure are the kurtosis, number of peaks, system entropy and skewness of the dataset. These in conjunction with ~50 other functions applied to the individual time series, results in the creation of potentially thousands of features which can be passed to a machine learning algorithm. 

The function which operates on the dataset to create these features is defined by;

`.fresh.createfeatures[table;aggs;cnames;funcs]`

This function takes as its arguments the table containing the pertinent data, ID column on which the features will be calculated, column names on which the features are to be calculated and a dictionary of the functions which will be calculated contained in the .fresh.feat namespace.

The application of these functions to a sample table below shows how the data is modified;
```q
q)table
ID        Feat1     Feat2    
------------------------
01-02-18  0.1      10        
01-02-18  0.2      12        
01-02-18  0.2      6         
02-02-18  0.2      1         
02-02-18  0.3      6        
```
1.Sample table

The first line below sets the functions to be calculated as only those containing as an argument the time series data without hyperparameters(i.e an individual time series is the only input).
```q
q)funcs:.fresh.getsingleinputfeatures[]
q).fresh.createfeatures[table;`ID;1_cols table;funcs]
ID         |   Feat1_Min   Feat2_Avg    …    Feat2_Has_Duplicate  Feat2_Max   Targets 
-----------|--------------------------------------------------------------------------
01-02-18   |   0.1         0.16667      …    0b                   12          1b       
02-02-18   |   0.2         0.25         …    0b                   6           0b       
```
2.Example extracted features table (here the target vector has been added to the table).

#### **Feature Significance Tests**
Once the features have been extracted we compare each of the features to the targets. The statistical tests which are used within the pipeline are as follows.
- Real feature and real target: Kendall tau-b test
- Real feature and binary target: Kolmogorov-Smirnov test.
- Binary feature and real target: Kolmogorov-Smirnov test.
- Binary feature and binary target: Fisher’s exact test.

Each of these statistical tests returns a p-value which compares the statistical significance of the features to the target vector.

Following calculation of the the p-values we employ the Benjamini-Hochberg-Yekutieli procedure which controls the features which are deemed to be statistically insignificant.

The significance tests and feature selection procedures described above are contained within the function 

`.fresh.significantfeatures[table;targets]` 

in this case table relates to the 'value' of the table (value table), while targets is the vector of values which are intended to be predicted. Here it is important to note that count targets must equal count table.

This will return a new table from which features that are deemed to be statistically insignificant have been removed. The data from this final table can then be passed to a machine learning algorithm for either forecasting or classification depending on the use case.

### Additionality functionality

Aside from the base level of functionality which includes the extraction and significance testing of features, a number of other functions are provided in order to allow for data to be converted to an appropriate format for the freshq algorithm to be most effective and to allow a user to produce features outside those which are computed from the initially input data. These supplied functions are outlined here but a more detailed explanation is provided at [INSERT LINK]

#### **Tailored data filling.**
In an ideal scenario the data which is being passed to the feature extraction algorithm should not contain null values. To this end the function `.fresh.preproc.fillfn[tab;tcol;dict]` has been provided to allow a user to fill data according to how they see fit. Where tab is the table of interest tco

The versatility of this function relates to modification of a dictionary `.fresh.dict` which when loaded initially defaults such that all columns are forward filled, however modifications to this default dictionary can allow linear/median/mean or zero filling to be completed on a column by column basis. 

#### **Interpolation.**
FreshQ and algorithms like it assume that the data being presented for each 'id' be evenly spaced. In a real world application this may not be a feasible constraint on the data. In order to get around this interpolation can be completed on the data to fix an equi-spaced grid to the data. Two forms of interpolation are provided here which are described in depth at [INSERT LINK].

1)`.fresh.preproc.tabfnlin[tab;tcol;t_diff;dict]`

This function will complete linear interpolation between two timestamps to find the expected value for another point occurring between these timestamps. The function defaults to linearly interpolate all data, however for columns which are binary in nature linear interpolation would not be logical, in such a case the data is forward fill interpolated. Additional columns to be forward filled can be defined through the addition of column names to the fill key of the default dictionary.

In this function, tab is the table of interest,tcol is the time column on which we are interpolating, t`_`diff is the desired time difference between timesteps and dict is the default dictionary/modified dictionary. 

2)`.fresh.preproc.tabfnbin[tab;tcol;t_diff;dict]`

This function completes a 'fills' type interpolation on the data. In this case the parameters being passed to the dataset are the same as in the linear interpolation function, however the default behaviour of the system is different. Unless specified in the linear key of the dictionary all columns will default to be forward fill interpolated.

#### **Polynomial features**
Alongside the production of features from the original dataset it may be useful in certain cases to produce polynomial features from the original dataset. For example given a table containing columns `x,x1,x2,x3` it may be useful to look at 2nd order polynomials alongside these of the form `x_x1,x_x2,x_x3,x1_x2,x1_x3,x2_x3` as the combination of these may be more insightful than the original data. The syntax for the production of these features is as follows.

`.fresh.polytab[x;y;z]`

In this case x is the original table, y is the degree of the polynomial features to be computed and z is the number of leading columns which should not be accounted for in the calculation of features (e.g. we again would not want to include the id or time columns in the creation of polynomial features). An example of this is presented below,
```q
q)table

date       time         open     high     low     close    volume
-----------------------------------------------------------------
2017.05.16 16:00:00.000 961      965.48   960.91  964.67   431465
2017.05.16 17:00:00.000 964.68   968.2    963.18  966.64   547131


q)table^.fresh.polytab[table;2;2]

date       time         open     high     low     close    volume open_high open_low 
-------------------------------------------------------------------------------------
2017.05.16 16:00:00.000 961      965.48   960.91  964.67   431465 927826.3  923434.5 
2017.05.16 17:00:00.000 964.68   968.2    963.18  966.64   547131 934003.2  929160.5 
```

#### **Creating forecasting frames**

One of the functions contained in this library can be used to 'artificially' produce forecasting frames from a dataset which may not necessarily have an appropriate structure but are suited for this form of analysis. For example as outlined in `Stock_Close_Price_Freshq.ipynb` in the case where we have distinct dates without a 'time' like column a rolling window can be applied to the data to create 'chunks' of data from which we can forecast, the syntax for this is as follows,

`.fresh.preproc.tablerolldrop[x;y;z]`

In this case x is the appropriate unkeyed table, y is the column from which the new column names will be derived and z is the number of datapoints which will be contained in the new windows. An example of this is presented below.

```q
q)table
date       open high low  close volume   openint
------------------------------------------------
1997.05.16 1.97 1.98 1.71 1.73  14700000 0      
1997.05.19 1.76 1.77 1.62 1.71  6106800  0      
1997.05.20 1.73 1.75 1.64 1.64  5467200  0      
1997.05.21 1.64 1.65 1.38 1.43  18853200 0      
    

q)show .fresh.preproc.tablerolldrop[table;`date;2]
date        open high low  close volume   openint 
--------------------------------------------------
t1997.05.19 1.97 1.98 1.71 1.73  14700000 0       
t1997.05.19 1.76 1.77 1.62 1.71  6106800  0       
t1997.05.20 1.73 1.75 1.64 1.64  5467200  0       
t1997.05.20 1.64 1.65 1.38 1.43  18853200 0       
     
```

If you would like to further investigate the uses of the FreshQ library, check out FreshQ on GitHub at […INSERT LINK HERE…] and visit https://code.kx.com/q/ml/freshq to find the complete list of the functions that are available in the FreshQ library. 

You can use Anaconda to integrate into your python installation to set up your Machine Learning environment , or you build your own which consists of downloading kdb+, embedPy and JupyterQ. You can find the installation steps on code.kx.com/q/ml/setup/

Please don’t hesitate to contact ai@kx.com if you have any suggestions or queries.

#### References:

- M. Christ et al., Time Series FeatuRe Extraction on basis of Scalable Hypothesis tests Neurocomputing (2018) 
- Feature Engineering in kdb+. Available from:
https://kx.com/blog/feature-engineering-in-kdb/