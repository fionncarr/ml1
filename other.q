\d .ml
/ q table to pandas dataframe
tab2df:{
 r:.p.import[`pandas;`:DataFrame.from_dict;flip 0!x][@;cols x];
 $[count k:keys x;r[`:set_index]k;r]}
/ pandas dataframe to q table
df2tab:{
 n:$[.p.isinstance[x`:index;.p.import[`pandas]`:RangeIndex]`;0;x[`:index.nlevels]`];
 n!flip $[n;x[`:reset_index][];x][`:to_dict;`list]`}
/ datatypes of table columns or dictionary values
dtypes:{type each$[98=type x;flip;]x}

/ convert all temporal values to underlying integers in table or dict
times2long:{@[x;where dtypes[x]in 12 13 14 16 17 18 19h;"j"$]} / convert times to integers
/ enumerate symbol values
enum:{@[x;c;?[distinct raze x c:where 11=dtypes x]]}
/ remove features with 1 distinct value, (zero variance) 
rmzerovar:{(where(1<count distinct@)each flip x)#x}
