\d .ml

shape:{-1_count each first scan x} 
dtypes:{type each$[98=type x;flip;]x}
round:{y*"j"$x%y}
range:{max[x]-min x}

traintestsplit:{[x;y;sz]`xtrain`ytrain`xtest`ytest!raze(x;y)@\:/:(0,floor n*1-sz)_neg[n]?n:count x};
minmaxscaler:{{(z-x)%y}[mnx;max[x]-mnx:min x]each x} 
eye:{@[x#0.;;:;1.]each til x}
onehot:{eye[count d](d:asc distinct x)?x}

tmconv:{@[x;where dtypes[x]in 12 13 14 16 17 18 19h;"j"$]}
enum:{@[x;c;?[distinct raze x c:where 11=dtypes x]]}
transform:{@[;where t in 12 13 14 16 17 18 19h;"j"$]@[x;c;?[distinct raze x c:where 11=t:dtypes x]]}
/ apply:{[f;x]$[type[x]in 0 98h;f x;first f enlist x]} / remove?

tScore:{[x;mu](avg[x]-mu)%sdev[x]%count x} // missing sqrt?
tScore:{[x;mu](avg[x]-mu)%sdev[x]%sqrt count x}
tScoreEq:{abs[avg[x]-avg y]%sqrt(svar[x]%count x)+svar[y]%count y}

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

\
/ still todo
seq:{x+z*til ceiling(1+y-x)%z}
percentile:{[x;k]s:asc x;n:count x;$[0=index-i:`int$index:n*k;$[0= n mod 2;avg s@(i;i-1);s i-1];s[i-1]+(index-i)*.[-;s@(i;i-1)]]} 
describe:{[data]`description xkey update description:`count`mean`std`min`q1`q2`q3`max from flip(count;avg;dev;min;percentile[;.25];percentile[;.5];percentile[;.75];max)@\:/: flip data}
/returns evenly spaced numbers over a specified interval. x=start,y=stop,s:num of samples to generate
linspace:{[x;y;s]x+z*til ceiling(1+y-x)%z:(y-x)%s-1}
tokenizer:{til[x]in y}
