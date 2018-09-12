\d .ml
/ evenly spaced values between x and y in steps of length z
arange:{x+z*til ceiling(y-x)%z}
/ z evenly spaced values between x and y
linspace:{x+til[z]*(y-x)%z-1}

shape:{-1_count each first scan x} / shape of a list
range:{max[x]-min x} / range of a list
percentile:{r[0]+(p-i 0)*last r:0^deltas x iasc[x]i:0 1+\:floor p:y*-1+count x} / percentile y of list x

/ descriptive statistics of the table columns
describe:{`count`mean`std`min`q1`q2`q3`max!flip(count;avg;dev;min;percentile[;.25];percentile[;.5];percentile[;.75];max)@\:/:flip(exec c from meta[x]where t in"hijefpmdznuvt")#x}

/ split data into training and test sets, x features, y labels, z proportion of data to reserve for test
traintestsplit:{`xtrain`ytrain`xtest`ytest!raze(x;y)@\:/:(0,floor n*1-z)_neg[n]?n:count x}
/ scale data between 0 and 1
minmaxscaler:{{(z-x)%y}[mnx;max[x]-mnx:min x]each x}
/ standardize data
stdscaler:{(x-avg x)%dev x}
/ identity matrix of size x
eye:{@[x#0.;;:;1.]each til x}
/ one hote encode list of values
onehot:{eye[count d](d:asc distinct x)?x}

/ t-score for a t test (one sample)
tscore:{[x;mu](avg[x]-mu)%sdev[x]%sqrt count x}
/ t-score for t-test (two independent samples, not equal variances
tscoreeq:{abs[avg[x]-avg y]%sqrt(svar[x]%count x)+svar[y]%count y}

/ covariance/correlation calculate upper triangle only
cvm:{(x+flip(not n=\:n)*x:(n#'0.0),'(x$/:'(n:til count x)_\:x)%count first x)-a*\:a:avg each x:"f"$x}
crm:{cvm[x]%u*/:u:dev each x}
/ correlation matrix, in dictionary format if input is a table
corrmat:{$[t;{x!x!/:y}cols x;]crm$[t:98=type x;value flip@;]x}
/ confusion matrix, x predicted class, y actual class
confmat:{cs:asc distinct y;exec 0^(count each group pred)cs by label from([]pred:x;label:y)}
accuracy:{avg x=y}
/ x predictions, y labels, z positive predicted label precision,sensitivity(recall), specificity
precision:{sum[u&x=y]%sum u:x=z}
sensitivity:{sum[(x=z)&x=y]%sum y=z}
specificity:{sum[u&x=y]%sum u:y<>z}
/ sum squared and mean squared error
sse:{sum d*d:x-y}
mse:{avg d*d:x-y}

EPS:1e-15
/ special case for binary classification, x(actual class) should be 0 or 1; y should be the probability of belonging to class 0 or 1 for each instance
logloss:{avg neg u+x*log[y[;1]]-u:log(y:EPS|y)[;0]} 
/ for any number of labels; x should be the indices of the list of unique class labels (0 if it belongs to 1st class, 1 if belongs to 2nd class, etc); y should be the probability of belonging to each class
crossentropy:{avg neg eye[count y 0][x]*log y|EPS} 

curvepts:{(x;y)@\:where(1_differ deltas[y]%deltas x),1b} / points in the ROC curve
auc:{sum 1_deltas[x]*y-.5*deltas y} / area under the curve with points of coordinates (x,y)
roc:{[y;p]{x%last x}each value exec 1+i-y,y from(update sums y from`p xdesc([]y;p))where p<>next p} / increasing false positive rates and true negatives rates to get the ROC curve
rocaucscore:{[y;p]auc . curvepts . roc[y;p]} / area under the ROC curve. x is the actual class and p the probability of belonging to the positive class
