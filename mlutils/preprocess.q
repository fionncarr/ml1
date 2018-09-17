\d .ml

/ converts data containing int/floats to a binary table based on input threshold
binarizer:{x>y}
/ check for columns containing null values to help with choice of filling
checknulls:{where 0<sum each 0n=flip x}
/drop columns with zero variance (1 value)
dropconstant:{(where (var each flip x) in (0 0n)) _ x}

onehot:{eye[count d](d:asc distinct x)?x}                               / encode a list of symbols using one-hot encoding

/ scale data between 0 and 1
minmaxscaler:{{(z-x)%y}[mnx;max[x]-mnx:min x]each x}
/ remove mean and standardize by standard deviation.
stdscaler:{(x-avg x)%dev x}

/ replace +/- float infinities with max/min values in the column
infreplace:{[tab]
 colvals:cols tab;
 n:{(max f[x])^f:(y*y<>0w)x}[;k]each til count k:value flip tab;
 n:{(min k[x])^k:(y*y<>-0w)x}[;n]each til count n;
 flip colvals!n}

/ produce a forecasting frame based on an 'id' column with n datapoints per frame. Drop incomplete frames and last frame (cannot be forecasted from)
tablerolldrop:{[table;id;n]{(sum 1+til y-1) _(neg y) _x}[rollingtable[table;id;n];n]}

/ default dictionary which can be modified to change the filling/interpolation behaviour
dict:``zero`median`mean`fill`linear!(::;0n;0n;0n;0n;0n)

fillfn:{[tab;tcol;dict]
 n0:$[k0:11h=abs type i0:dict`zero;tcol,i0;0b];
 n1:$[k1:11h=abs type i1:dict`median;tcol,i1;0b];
 n2:$[k2:11h=abs type i2:dict`mean;tcol,i2;0b];
 i3:$[-9h=type z:dict[`linear];z;$[1=count z;$[0=sum 0n=tab z;0n;z];z where 0<>sum each null l:tab z]];
 n3:$[k3:11h=abs type i3;$[-9h=type i3;0b;tcol,i3];0b];
 tabz:$[k0;0^flip n0!tab[n0];0n];
 tabmed:$[k1;flip n1!{(med p1)^p1:x[y]}[tab;]each n1;0n];
 tabmean:$[k2;flip n2!{(avg p2)^p2:x[y]}[tab;]each n2;0n];
 tablinear:$[k3;interplinfn[;;tcol]/[flip (tcol,i3)!tab(tcol,i3);i3];0n];
 filled:(cols tab) xcols reverse fills reverse fills $[not any -9h=type each (tabz;tabmed;tabmean;tablinear);0!tab;(tabz^tabmed^tabmean^tablinear^([]nil:(count tab)#0n))^0!tab];
 r:(k _ filled)^ 0^flip k!filled k:where not (type each flip filled)=11h
 }

/The function below allows for filling to be completed by symbol on the data.
symfillfn:{[x;y;z;k]raze{[x;y;z;k;l]fillfn[tabfn[y;x;z];k;l]}[;x;y;z;k]each distinct x[y]}

tabfnbin:{[tab;tcol;dif;dict]
 if[(count 1_cols tab)=count i0:dict`linear;'`$"please use the function tabfnlin instead"];
 tm:p+k*til ("j"$((last tab[tcol]) -p:first tab[tcol])%(k:`time$dif));
 lincol:$[k0:11h=abs type i0;tcol,i0;0b];
 realtab:$[k0;lincol#tab;0n];
 newlin:$[k0;tablininterp[realtab;tcol;tm];0n];
 bintab:$[k0;flip (dict`linear) _ flip tab;tab];
 newbin:filltabfn[bintab;tcol;dif];
 r:(cols tab) xcols flip (where 0=var each k) _ k:flip newlin^newbin
 }

tabfnlin:{[tab;tcol;dif;dict]
 if[(count 1_cols tab)=count i0:dict`fill;'`$"please use the function tabfnbin instead"]
 tm:p+k*til ("j"$((last tab[tcol]) -p:first tab[tcol])%(k:`time$dif));
 n:tcol,p:where 2=count each distinct each flip tab;
 bintab:$[0<count p;
        flip n!tab[$[11h=abs type dict[`fill];n:n,dict[`fill];n]];
        $[11h=abs type[dict[`fill]];
        flip l!tab[l:tcol,dict[`fill]];
        0n]];
 newbin:$[98h=type bintab;
        flip f!l[f:distinct cols l:filltabfn[bintab;tcol;dif]];
        0n];
 realtab:$[11h=abs type dict[`fill];
        flip (where not (type each k) in (6h;7h;8h;9h;19h)) _ k:(1_n,dict[`fill]) _ flip tab;
        tab];
 newlin:tablininterp[realtab;tcol;tm];
 r:(cols tab) xcols flip (where 0=var each k) _ k:flip newbin^$[0<count p; flip (1_n) _ flip newlin;newlin]
 }

/The following functions are used to produce individually chosen or the entire set of polynomial features
polytab:{[x;n;k]
 p:(k _ cols x)#x;
 flip(`$ssr[;".";"_"]each string each ` sv'c)!prd each p c:combs[n]p}

powerset:{x^flip raze flip each polytab[p;;0]each (-1_2+til count cols p:(y _ cols x)#x)}

/utils
combs:{[n;x]cols[x]distinct asc each n(raze{y,/:x except y}[til count cols x]each)/enlist 0#0}
eye:{@[x#0.;;:;1.]each til x}
f:{$[y;x+1;0]}\[0;]
filltabfn:{[t;c;dif]aj[c;newtab[t;c;dif];t]}
/linear interpolation for filling values based on a time series.
interplinfn:{[t;c;tm].[t;(i;c);:;lininterp[t tm;t c;i]. i+/:(neg 1+f 1=0,1_deltas i;reverse 1+f -1=0,1_deltas reverse i:where n:null t c)]}
lininterp:{[tm;v;i;b;a]v[b]+(v[a]-v b)*(tm[i]-k)%tm[a]-k:tm b}
newtab:{[t;c;dif]0^flip (c,`vals)!(tvals[t;c;dif];(count tvals[t;c;dif])#0n)}
/rolling table including incomplete frames
rollingtable:{[table;time;roll]
 labels:`$"t",'string (raze{y#x}[;roll]each last each p)where not 0=raze p:swin[roll;table[time]];
 results:{[x;y;z;k]l:where 0<>kx:raze k;ky:({raze swin[y;x[z]]}[x;y;]each 1_cols x)[;l];r:flip ky}[table;roll;time;p];
 tabval:labels,'(results);
 r:flip (cols table)!flip tabval}
/sliding window
swin:{[w;s]{1_x,y}\[w#0;s]}
tabfn:{?[x;enlist (=;z;enlist y);0b;()]}
/linear interpolation on a table for an time column c and time series tm
tablininterp:{[t;c;tm]
 i:1 0+\:t[c] bin `time$tm;
 x:(tm-t[c]i 1)%(t[c][i 0]-t[c][i 1]);
 c xcols ![ab[1]+flip x*/:flip(-). ab:((cols t)#t)i;();0b;(enlist c)!enlist tm]}
tvals:{[t;c;dif]tm:(first t[c])+k*til ("j"$((last t[c]) -first t[c])%(k:`time$dif))}

