\l p.q
\d .ml


/ evenly spaced values between x and y in steps of length z.
arange:{x+z*til ceiling(y-x)%z}
/ datatypes of table columns or dictionary values
dtypes:{type each$[98=type x;flip;]x}
/ z evenly spaced values between x and y
linspace:{x+til[z]*(y-x)%z-1}
range:{max[x]-min x}
/ shape of a list
shape:{-1_count each first scan x}
/Convert an unkeyed table to matrix
mattab:{flip value flip x}

/split data into train and test datasets where sz is the % of data in test
traintestsplit:{[x;y;sz]`xtrain`ytrain`xtest`ytest!raze(x;y)@\:/:(0,floor n*1-sz)_neg[n]?n:count x}

/split data into train and test with an applied random seed to force a certain splitting
traintestsplitseed:{[x;y;sz;seed]system "S ",string (neg[seed]);`xtrain`ytrain`xtest`ytest!raze(x;y)@\:/:(0,floor n*1-sz)_neg[n]?n:count x}

/ convert all temporal values to underlying integers in table or dict
times2long:{@[x;where dtypes[x]in 12 13 14 16 17 18 19h;"j"$]} / convert times to integers
/ enumerate symbol values
enum:{@[x;c;?[distinct raze x c:where 11=dtypes x]]}

/ pandas manipulation q tab to df or df to q tab
tab2df:{
 r:.p.import[`pandas;`:DataFrame.from_dict;flip 0!x][@;cols x];
 $[count k:keys x;r[`:set_index]k;r]}
df2tab:{
 n:$[.p.isinstance[x`:index;.p.import[`pandas]`:RangeIndex]`;0;x[`:index.nlevels]`];
 n!flip $[n;x[`:reset_index][];x][`:to_dict;`list]`}
