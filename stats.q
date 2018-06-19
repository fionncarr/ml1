\l p.q
\d .ml

/ q table to pandas dataframe
tab2df:{
  r:.p.import[`pandas;`:DataFrame.from_dict;flip 0!x][@;cols x];
  $[count k:keys x;r[`:set_index]k;r]}
/ pandas dataframe to q table
df2tab:{
  n:$[.p.isinstance[x`:index;.p.import[`pandas]`:RangeIndex]`;0;x[`:index.nlevels]`];
  n!flip $[n;x[`:reset_index][];x][`:to_dict;`list]`}


arange:{x+z*til ceiling(y-x)%z} / evenly spaced values between x and y in steps of length z.
linspace:{x+til[z]*(y-x)%z-1} / z evenly spaced values between x and y

shape:{-1_count each first scan x} / shape of a list
dtypes:{type each$[98=type x;flip;]x} / datatypes of table columns or dictionary values
round:{y*"j"$x%y} / 
range:{max[x]-min x} / range of a list
percentile:{r[0]+(p-i 0)*last r:0^deltas x iasc[x]i:0 1+\:floor p:y*-1+count x} / percentile y of list x

/ descriptive statistics of the table columns
describe:{`count`mean`std`min`q1`q2`q3`max!flip(count;avg;dev;min;percentile[;.25];percentile[;.5];percentile[;.75];max)@\:/:flip(exec c from meta[x]where t in"hijefpmdznuvt")#x}


traintestsplit:{[x;y;sz]`xtrain`ytrain`xtest`ytest!raze(x;y)@\:/:(0,floor n*1-sz)_neg[n]?n:count x} / split data into training and test sets. sz is the proportion of the data to include in the test set
minmaxscaler:{{(z-x)%y}[mnx;max[x]-mnx:min x]each x} / scale data between 0 and 1
stdscaler:{(x-avg x)%dev x} / remove the mean and standarize data by the standard deviation
eye:{@[x#0.;;:;1.]each til x} / identity matrix of size x 
onehot:{eye[count d](d:asc distinct x)?x} / encode a list of integers using one-hot encoding

tmconv:{@[x;where dtypes[x]in 12 13 14 16 17 18 19h;"j"$]} / convert times to integers
enum:{@[x;c;?[distinct raze x c:where 11=dtypes x]]} / encode symbol columns in a table as integers. Each distinct symbol in the table maps to an integer
rmtrivial:{(where(1<count distinct@)each flip x)#x} / drop columns with just 1 distinct value
transform:{@[;where t in 12 13 14 16 17 18 19h;"j"$]@[x;c;?[distinct raze x c:where 11=t:dtypes x]]} / convert times to integers and encode symbol columns as integers

tscore:{[x;mu](avg[x]-mu)%sdev[x]%sqrt count x} / t-score for a t test (one sample)
tscoreeq:{abs[avg[x]-avg y]%sqrt(svar[x]%count x)+svar[y]%count y} / t-score for t-test (two independent samples, not equal varainces)

corrmat:{x cor/:\:$[t;value;]x:$[t:98=type x;flip;]x} / correlation matrix
confmat:{d:$[b:x~(::);asc distinct y,z;10b];0^(d!(n;n:count d)#0),exec(count each group c2)d by c1 from $[b;;x=]([]c1:y;c2:z)} / confusion matrix. x is the positive class,y should be the actual classes and z the predictions
confdict:{`tp`fn`fp`tn!raze value confmat[x;y;z]} / number of TP,FN,FP,TN.
precision:('[{x[`tp]%sum x`tp`fp};confdict]) / positive predictive value
sensitivity:('[{x[`tp]%sum x`tp`fn};confdict]) / true positive rate
specificity:('[{x[`tn]%sum x`tn`fp};confdict]) / true negative rate

sse:{sum d*d:x-y} / sum of squared errors
mse:{avg d*d:x-y} / mean of squared errors
accuracy:{avg x=y} / accuracy score

EPS:1e-15
/ special case for binary classification, x(actual class) should be 0 or 1; y should be the probability of belonging to class 0 or 1 for each instance
logloss:{avg neg u+x*log[y[;1]]-u:log(y:EPS|y)[;0]} 
/ for any number of labels; x should be the indices of the list of unique class labels (0 if it belongs to 1st class, 1 if belongs to 2nd class, etc); y should be the probability of belonging to each class
crossentropy:{avg neg eye[count y 0][x]*log y|EPS} 

curvepts:{(x;y)@\:where(1_differ deltas[y]%deltas x),1b} / points in the ROC curve
auc:{sum 1_deltas[x]*y-.5*deltas y} / area under the curve with points of coordinates (x,y)
roc:{[y;p]{x%last x}each value exec 1+i-y,y from(update sums y from`p xdesc([]y;p))where p<>next p} / increasing false positive rates and true negatives rates for ROC curve
rocaucscore:{[y;p]auc . curvepts . roc[y;p]} / area under the ROC curve. x is the actual class and p the probability of belonging to the positive class
