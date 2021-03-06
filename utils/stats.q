\d .ml

utils.accuracy:{avg x=y}
/ sum squared and mean squared error
utils.mse:{avg d*d:x-y} / mean of squared errors
utils.sse:{sum d*d:x-y} / sum of squared errors

/ covariance/correlation calculate upper triangle only
utils.cvm:{(x+flip(not n=\:n)*x:(n#'0.0),'(x$/:'(n:til count x)_\:x)%count first x)-a*\:a:avg each x:"f"$x}
utils.crm:{utils.cvm[x]%u*/:u:dev each x}
/ correlation matrix, in dictionary format if input is a table
utils.corrmat:{$[t;{x!x!/:y}cols x;]utils.crm$[t:98=type x;value flip@;]x}
/ confusion matrix, x predicted class, y actual class
utils.confmat:{cs:asc distinct y;exec 0^(count each group pred)cs by label from([]pred:x;label:y)}
/ dictionary of tp/tn/fp/fn from confusion matrix
utils.confdict:{`tp`fn`fp`tn!raze value utils.confmat[x;y]} / number of TP,FN,FP,TN.

/ x is alist of unique class labels (0 = class 1, 1 = class 2 ... ); y is the probability of belonging to a class
utils.crossentropy:{avg neg eye[count y 0][x]*log y|EPS}

/ descriptive statistics of the table columns
utils.describe:{`count`mean`std`min`q1`q2`q3`max!flip(count;avg;sdev;min;utils.percentile[;.25];utils.percentile[;.5];utils.percentile[;.75];max)@\:/:flip(exec c from meta[x]where t in"hijefpmdznuvt")#x}

/x is the actual class should be 0 or 1; y should be the probability of belonging to class 0 or 1 for each instance
utils.logloss:{avg neg u+x*log[y[;1]]-u:log(y:EPS|y)[;0]}

/ x predictions, y labels, z positive predicted label precision,sensitivity(recall), specificity
utils.precision:{sum[u&x=y]%sum u:x=z}
utils.sensitivity:{sum[(x=z)&x=y]%sum y=z}
utils.specificity:{sum[u&x=y]%sum u:y<>z}

/ increasing false positive rates and true negatives rates to get the ROC curve
utils.roc:{[y;p]{x%last x}each value exec 1+i-y,y from(update sums y from`p xdesc([]y;p))where p<>next p}
/ area under the ROC curve. x is the actual class and p the probability of belonging to the positive class
utils.rocaucscore:{[y;p]utils.auc . utils.curvepts . utils.roc[y;p]}


/ t-score for a t test (one sample)
utils.tscore:{[x;mu](avg[x]-mu)%sdev[x]%sqrt count x}
/ t-score for t-test (two independent samples, not equal varainces)
utils.tscoreeq:{abs[avg[x]-avg y]%sqrt(svar[x]%count x)+svar[y]%count y}


/utils
utils.auc:{sum 1_deltas[x]*y-.5*deltas y} / area under the curve with points of coordinates (x,y)
utils.bc:{[y;score]
 fps:1+ti-tps:sums[y@:si]ti:-1+1_where differ score,1+last score@:si:idesc score;
 :(fps;tps;score ti);}
utils.curveinds:{[x;y]where(-1_differ utils.gradients[x;y]),1b}
EPS:1e-15
utils.gradients:{[x;y]deltas[y]%deltas x}
/ percentile y of list x
utils.percentile:{r[0]+(p-i 0)*last r:0^deltas x iasc[x]i:0 1+\:floor p:y*-1+count x} / percentile y of list x
/ points in the ROC curve
utils.curvepts:{(x;y)@\:where(1_differ deltas[y]%deltas x),1b}
