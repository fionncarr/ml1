\l p.q
\d .ml

tab2df:{
  r:.p.import[`pandas;`:DataFrame.from_dict;flip 0!x][@;cols x];
  $[count k:keys x;r[`:set_index]k;r]}
df2tab:{
  n:$[.p.isinstance[x`:index;.p.import[`pandas]`:RangeIndex]`;0;x[`:index.nlevels]`];
  n!flip $[n;x[`:reset_index][];x][`:to_dict;`list]`}

arange:{x+z*til ceiling(y-x)%z}
linspace:{x+til[z]*(y-x)%z-1}

shape:{-1_count each first scan x}
dtypes:{type each$[98=type x;flip;]x}
round:{y*"j"$x%y}
range:{max[x]-min x}
percentile:{r[0]+(p-i 0)*last r:0^deltas x iasc[x]i:0 1+\:floor p:y*-1+count x}

describe:{`count`mean`std`min`q1`q2`q3`max!flip(count;avg;dev;min;percentile[;.25];percentile[;.5];percentile[;.75];max)@\:/:flip(exec c from meta[x]where t in"hijefpmdznuvt")#x}

traintestsplit:{[x;y;sz]`xtrain`ytrain`xtest`ytest!raze(x;y)@\:/:(0,floor n*1-sz)_neg[n]?n:count x}
minmaxscaler:{{(z-x)%y}[mnx;max[x]-mnx:min x]each x}
stdscaler:{(x-avg x)%dev x}
eye:{@[x#0.;;:;1.]each til x}
onehot:{eye[count d](d:asc distinct x)?x}

tmconv:{@[x;where dtypes[x]in 12 13 14 16 17 18 19h;"j"$]}
enum:{@[x;c;?[distinct raze x c:where 11=dtypes x]]}
rmtrivial:{(where(1<count distinct@)each flip x)#x}
transform:{@[;where t in 12 13 14 16 17 18 19h;"j"$]@[x;c;?[distinct raze x c:where 11=t:dtypes x]]}

tscore:{[x;mu](avg[x]-mu)%sdev[x]%sqrt count x}
tscoreeq:{abs[avg[x]-avg y]%sqrt(svar[x]%count x)+svar[y]%count y}

confusion:{d:$[b:x~(::);asc distinct y,z;10b];0^(d!(n;n:count d)#0),exec(count each group c2)d by c1 from $[b;;x=]([]c1:y;c2:z)}
confdict:{`tp`fn`fp`tn!raze value confusion[x;y;z]}
precision:('[{x[`tp]%sum x`tp`fp};confdict])
sensitivity:('[{x[`tp]%sum x`tp`fn};confdict])
specificity:('[{x[`tn]%sum x`tn`fp};confdict])

mse:{avg d*d:x-y}
accuracy:{avg x=y}

EPS:1e-15
logloss:{avg neg u+x*log[y[;1]]-u:log(y:EPS|y)[;0]}
crossentropy:{avg neg eye[count y 0][x]*log y|EPS}

curvepts:{(x;y)@\:where(1_differ deltas[y]%deltas x),1b}
auc:{sum 1_deltas[x]*y-.5*deltas y}
roc:{[y;p]{x%last x}each value exec 1+i-y,y from(update sums y from`p xdesc([]y;p))where p<>next p}
rocaucscore:{[y;p]auc . curvepts . roc[y;p]}
