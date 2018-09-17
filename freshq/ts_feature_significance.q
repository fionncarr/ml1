\l p.q
\d .fresh
.p.import[`warnings][`:filterwarnings]["ignore"];
np:.p.import[`numpy]
scipy:.p.import[`scipy.stats]
ksdistrib:scipy[`:kstwobign.sf]
kendalltau:scipy[`:kendalltau]
fisherexact:.p.import[`scipy.stats]`:fisher_exact
special:.p.import[`scipy][`:special]

searchsort:{1+x bin y}

ks2samp:{y0:y where x = first distinct x;y1:y where x = last distinct x;
 n1:count y0;n2:count y1;
 ydata0:asc y0;ydata1:asc y1;
 totdata:ydata0,ydata1;
 cdf1:(searchsort[ydata0;]each totdata)%n1;
 cdf2:(searchsort[ydata1;]each totdata)%n2;
 d:max abs cdf1-cdf2;
 en:sqrt n1*n2%n1+n2;
 r:ksdistrib[d*en+0.12+0.11%en]`}

/ 
Implementation of kendalls tau-b test for real features and targets first uses embedpy,
second is a majority q with a python numerical integration step in this case the q version 
gives a slightly different answer (potentially some floating point rounding error?)
and is very very slow compared to python.
\

ktaupy:{[x;y][kendalltau[x;y]`][1]}

ktauq:{[x]
 n:count x;
 k@:where(<).'k:k cross k:til n;
 fx:{[d;i]neg signum(-).'d@\:i}[value flip x]each k;
 flipd:flip fx;
 xpair:sum 0=flipd[0]; ypair:sum 0=flipd[1];
 concord:sum(=). flip fx; discord:count where 2 = (-). flip fx;
 tau:(concord-discord)%sqrt(concord+discord+xpair)*(concord+discord+ypair);
 vars:(10+4*n)%9.0*n*n-1; z:tau%sqrt vars;
 r:tau,special[`:erfc][[abs z]%1.4142136]`
 }

/
The following is the implementation of the fisher exact test for binary features and targets as
outlined in the fresh documentation. Using a mix of embedPy and q

Calculation for the fischer exact test requires that an input be sent to the function of the form
data:((a;b);(c;d)) and the apparent calculation of (a+b)!(c+d)!(a+c)!(b+d)!/(a!b!c!d!n!) 
where n is the number of rows in data, a/d are false positive/negatives and b/c are true 
positives/negatives.

However calculation of this leads very quickly to overflow in the data(21! is larger than the
maximum allowed long)

factorial:{last prds 1+til x}
\

fishertest:{x0:first distinct x;x1:last distinct x;
 y0:first distinct y;y1:last distinct y;
 ny1x0:sum y1=k:y where x=x0;ny0x0:(count k)-ny1x0;
 ny1x1:sum y1=v:y where x=x1;ny0x1:(count v)-ny1x1;
 tab:((ny1x1;ny1x0);(ny0x1;ny0x0));
 [fisherexact[tab;`alternative pykw `$"two-sided"]`][1]}

/
Data must be sorted by p-value before running the benjamini-hochberg test on the data
it should also be noted that the associated features should be sorted with this list so mapping
is easier... (not sure if there's a better way)

From benjhochfind 'v' should probably be removed under the assumption we sort
by asc p-value earlier in the 'pipeline' it should also be noted that y in the benjhoch
function is a predefined limit where we cut off candidate features based on p-value
\

benjhoch:{(y*1+til k)%(k*sums{1%1+til x}k:count x)}
benjhochfind:{v:asc x;where v>=benjhoch[v;y]}
