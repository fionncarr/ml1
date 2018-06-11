\l p.q

/
The following are numpy and scipy modules which were used in the place of q code
in areas where I couldn't get a q implementation to fully work
\

findpeak:.p.import[`scipy.signal]`:find_peaks_cwt;
distrib:.p.import[`scipy.stats]`:t.sf;
rfft:.p.import[`numpy]`:fft.rfft;
absolute:.p.import[`numpy]`:abs;
pacf:.p.import[`statsmodels.tsa.stattools]`:pacf
adfuller:.p.import[`statsmodels.tsa.stattools]`:adfuller
acf:.p.import[`statsmodels.tsa.stattools]`:acf

/
There are a number of functions which exist in the TS fresh library that already exist within q/kdb+
These functions are as follows; max,min,sum,median=med,mean=avg,length=count,std deviation=dev,variance=var,
may need to be added to the 'actual' script 
\

shape:{-1_count each first scan x}
size:{(*/)shape x}
arange:{x+z*til ceiling(y-x)%z}
getmoment:{(x$("f"$arange[0;count x;1])xexp y)%(sum x)} /x=data;y=exp
hist:{(count each value(asc key g)#g:group(-1_a)bin x;a:min[x]+til[1+y]*(max[x]-min x)%y)} /x=data;y=#bins

absenergy:{sum x*x}

valcount:{sum x=y}
countabovemean:{sum x>avg x} 
countbelowmean:{sum x<avg x}
rangecount:{sum x within(y;z)} /x=data;y=min val;z=max val
numcrossingm:{sum 1_differ x>y} /x=data;y=value check documentation for crossing definition.

firstmax:{x?max x}
firstmin:{x?min x} 
lastmax:{last where x=max x}
lastmin:{last where x=min x}
hasdup:{(count x)<>count(distinct x)}
hasdupmax:{1<sum x=max x}
hasdupmin:{1<sum x=min x}

sumrecurringdatapoint:{sum k*g k:where 1< g:count each group x}
sumrecurringval:{sum where 1<count each group x}

aggonchunk:{y each z cut x} /x:array;y:agg function; z: chunk length 

perrecurtoalldata:{sum[1<g]%count g:count each group x}
perrecurtoallval:{sum[g where 1<g:count each group x]%count x}

ratiovalnumtserieslength: {(count distinct x)%count x}
ratiobeyondrsigma:{sum[((abs (x-avg[x]))>y*dev x)]%size[x]}

meanchange:{avg 1_deltas x}
meanabschange:{avg abs 1_deltas x}
abssumchange:{sum abs 1_deltas x}
mean2dercentral:{dif:(xprev[-1;x]+xprev[1;x]-2*x)%2.0;avg dif}

varlargerstd:{(var x)>1}
largestdev:{(dev x)>y*max[x]-min x}

getlenseqwhere:{(sum each where[differ x]_x)except 0}
longstrikelessmean:{max getlenseqwhere[x<avg x]}
longstrikegreatermean:{max getlenseqwhere[x>avg x]}

cidce:{sqrt k$k:"f"$1_deltas$[y;[if[0=s:dev x;:0.];(x-avg x)%s];x]}
c3:{$[y>=0.5*n:count x;0f;avg prd xprev[;x]each 0 -1 -2*y]}

treverseasymstat:{$[y>=0.5*n:count x;0;avg(x2*(x2:xprev[-2*y]x)*x1)-(x1:xprev[-1*y]x)*x*x]}
symmetrylookup:{abs[avg[x]-med x] > y*max[x]-min x}

quantile:{r[0]+(p-i 0)*last r:0^deltas x iasc[x]i:0 1+\:floor p:y*-1+count x}

autocorr:{$[y>k:count x;0n;(sum(((neg y)_n)*(y _ n:x-avg x)))%((k-y)*var x)]}

skewness:{((sqrt n*n-1)*(n xexp 1.5)*sum(m*m*m))%((n*n:count x-2)*((sum(m*m:x-avg x))xexp 1.5))}
kurtosis:{(((n+1)*n*(n-1)*sum k2*k2)%((n-3)*(n-2)*(sum k2)*(sum k2:k*k:x-avg x)))-(((3*(n-1)*(n-1))%((n-2)*((n:count x)-3))))}

numcwtpeaks:{count(findpeak[x;arange[1;y+1;1]]`)} / 'ricker wavelet specification removed... it is default in find_peak_cwt

binnedentropy:{neg sum p*log p:hist[x;y][0]%count x}

/x=data; y=quantile
indexmassquantile:{first where ((sums x)%sum abs x)>=y}

/x is the "intensity data"
lintrend:{
	k:1+til count x;df:(n:count k)-2; 
	covarfn:{[k;x](sum((k*x)-(avg k)*(avg x)))%(count k)-1};
        rnum:covarfn[k;x];rden:sqrt(covarfn[k;k]*covarfn[x;x]);rval:$[rden=0;0f;rnum%rden];
        slope:rnum%covarfn[k;k];intercept:(avg x) - slope*(avg k);
        $[n=2;$[x[0]=x[1];[p:1;stderr:0];[p:0;stderr:0n]];
        [t:rval*(sqrt(df%((1f-rval+tiny)*(1f+rval+tiny:1e-20))));stderr:sqrt((1-(rval*rval))*covarfn[x;x]%(covarfn[k;k]*df));p:2*distrib[abs t;df]`;]];
        r:slope,intercept,rval,p,stderr
        }

linagg:{xnew:aggonchunk[x;y;z];lintrend[til (count xnew)-1;-1_xnew]}

/x=data;y=#chunks;z=focus chunk
eratiobychunk:{val:("i"$floor((count x)%y)) cut x;[sum valfocus*valfocus:val[z]]%absenergy[x]}

changequant:{[x;ql;qh;isabs;aggfn]
	if[ql~qh;:0];
	pos:(x>quantile[x;ql])&(x<quantile[x;qh]);
	if[(sum pos)=0;:0];
	k:x where pos;r:aggfn $[isabs;abs 1_deltas k; 1_deltas k]}

/ The following two functions cover the number_peaks function in tsfresh python
peakfind:{[x;y;z]
	xreduced:(neg y) _ y _ x;
	droproll:{(neg y) _ y _ xprev[z;x]};
	if[z=1;res:xreduced>droproll[x;y;z];res &:xreduced>droproll[x;y;(neg z)]];
	if[z<>1;res &:xreduced>droproll[x;y;z];res &:xreduced>droproll[x;y;(neg z)]];
       	r:res}
numberpeaks:{[x;y] k:peakfind[x;y;]each 1+til y;sum all each flip k}

/The following two lines are in place of the setproperty function present in ts fresh as I don't really know what our alternative will be

attrtable:([]func:"s"$();keyvals:"s"$();values:"s"$());
setprop:{$[y=`fctype;$[[z in (`simple;`combiner)];[`attrtable upsert x,y,z];:0];:0]}

/
The following function is the calculation of the fft_aggregated which returns the centroid, variance, skew and kurtosis of the absolute fourier transform spectrum. It however uses numpy to calculate the fourier transform and absolute value.
\
fftaggreg:{[x] getmoment:{[y;moment](("f"$y)$("f"$arange[0;count y;1])xexp moment)%(sum y)};
        l:absolute[rfft[x]`]`;
        centroid:getmoment[l;1];m2:getmoment[l;2];m3:getmoment[l;3];m4:getmoment[l;4];
        getvariance:{x-(y xexp 2)};variance:getvariance[m2;centroid];
        getskew:{[l;y;z;k]$[z<0.5;0n;((k-3*y*z)-(y xexp 3))%(z xexp 1.5)]};skew:getskew[l;centroid;variance;m3];
        getkurtosis:{[l;y;z;m2;m3;m4]$[z<0.5;0n;((m4-4*y*m3-3*y)+(6*m2*y*y))%(z xexp 2)]};kurtosis:getkurtosis[l;centroid;variance;m2;m3;m4];
        r:centroid,variance,skew,kurtosis}

/
The functions which follow are partially correct (under introduction of table data they seem to in at least limited
cases to return the same values as the python equivalents... however they will need to be modified to handle
the `param file and may need more 'error handling'
\

partautocorrelation:{[x;params] maxreqlag:max params; n:count x; $[n<=1;pacf:0n*til maxreqlag +1;[maxlag:$[n<=maxreqlag;maxreqlag-1;maxreqlag]]];paccoeff:pacf[x;nlags:maxlag;method:`ld]}

Aug_dickey:{[x;attrib] k:{adfuller[x]`};res:@[k;x;[0n;0n;0n]];$[attrib=`teststat;res[0];attrib=`pvalue;res[1];attrib=`usedlag;res[2];0N!0n]}
