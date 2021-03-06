/
The purpose of this script is to provide an example of how FreshQ
could be implemented in a production environment namely with outputs during
script execution.

To complete the pipeline the function 'freshqpipeline' is run this takes 
in the case below arguments of [table;id;target] however this could be modified to include the 
addition of the forecasting frame production if required.

In the below example the following lines should be executed within the console, however in reality
these could be integrated into the development environment.

This example requires that 'amzn.us.txt' has been downloaded from the github and is within the folder
containing the implementationexample.q script.

$ q consoleexample.q 
q)tabinit:{lower[cols x]xcol x}("DTFFFFII";enlist ",") 0:`:SampleDatasets/amzn.us.txt
q)tabinit:(where 0=var each flip delete date,time from tabinit) _ tabinit
q)closes:value exec last close by date from tabinit
q)targets:closes>prev closes

\

\l ml/init.q
\l graphics.q

-1"\n------------------------------";
-1 "Ready for feature extraction to take place, please load in your table, assign your target and choose your id column";
-1"------------------------------\n";

freshqpipeline:{[table;id;target]
 -1"\n------------------------------";
 -1 "In this example we are only extracting on features which take the data alone as an input, these are as follows:";
 -1"------------------------------\n";
 show singleinputfeatures:.ml.fresh.getsingleinputfeatures[];
 
 -1"\n------------------------------";
 -1 "Beginning feature extraction, this may take a while...";
 -1"------------------------------\n";
 tabraw:.ml.fresh.createfeatures[table;id;2_ cols table;singleinputfeatures];
 
 -1"------------------------------";
 -1 "Feature extraction is now complete, the new table is as follows";
 -1"------------------------------\n";
 show tabraw;
 
 -1"\n------------------------------";
 -1 "Feature selection is now beginning...";
 -1"--------------------------------\n";
 show tabreduced:key[tabraw]!.ml.fresh.significantfeatures[value tabraw;targets];

 -1"--------------------------------";
 -1 "Feature selection is now complete, the following are the columnal modifications to the input table";
 -1"------------------------------";
 -1"The number of columns in the initial dataset is: ",string count cols tabinit;
 -1"The number of columns in the unfiltered dataset is: ",string count cols tabraw;
 -1"The number of columns in the filtered dataset is: ",string count cols tabreduced;
 
 fitvalsfilter:0^flip value flip value tabreduced;
 fitunfilter:0^flip value flip value tabraw;

 -1"\n------------------------------";
 -1"We now set a Random Forest Classifier with 200 estimators to create our predictions and fit the data to the model and make predictions given a defined random seed";
 -1"--------------------------------\n";
 clf:.p.import[`sklearn.ensemble][`:RandomForestClassifier][`n_estimators pykw 10;`random_state pykw 42];
 classreport:.p.import[`sklearn.metrics]`:classification_report;

 seed:"i"$.z.t;
 dict1:.ml.utils.traintestsplitseed[fitvalsfilter;targets;0.25;seed];
 dict2:.ml.utils.traintestsplitseed[fitunfilter;targets;0.25;seed];
 clf[`:fit][dict1[`xtrain];dict1[`ytrain]]`;
 pred1:clf[`:predict][dict1[`xtest]]`;
 clf[`:fit][dict2[`xtrain];dict2[`ytrain]]`;
 pred2:clf[`:predict][dict2[`xtest]]`;
 
 -1"------------------------------";
 -1"The results from this analysis are as follows";
 -1"------------------------------\n";
 print classreport[dict1[`ytest];pred1]`;
 -1"The number of misclassifications in the filtered dataset is: ",string sum dict1[`ytest]<>pred1;
 -1"The accuracy in the filtered dataset is: ",string .ml.utils.accuracy[dict1[`ytest];pred1];
 -1"_______________________________________________________________";

 print classreport[dict2[`ytest];pred2]`;
 -1"The number of misclassifications in the unfiltered dataset is: ",string sum dict2[`ytest]<>pred2;
 -1"The accuracy in the unfiltered dataset is: ",string .ml.utils.accuracy[dict2[`ytest];pred2];
 -1"_______________________________________________________________";
 
 show cnfM:.ml.cfm[dict1[`ytest];pred1];
 }
