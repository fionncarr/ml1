\l p.q
\d .ml

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

getmoment:{(x$("f"$arange[0;count x;1])xexp y)%(sum x)} /x=data;y=exp
hist:{(count each value(asc key g)#g:group(-1_a)bin x;a:min[x]+til[1+y]*(max[x]-min x)%y)} /x=data;y=#bins

valcount:{sum x=y}
countabovemean:{sum x>avg x} 
countbelowmean:{sum x<avg x}
rangecount:{sum x within(y;z)} /x=data;y=min val;z=max val
numcrossingm:{sum 1_differ x>y} /x=data;y=value check documentation for crossing definition.

firstmax:{x?max x}
firstmin:{x?min x} 
lastmax:{last where x=max x}
lastmin:{last where x=min x}
hasdup:{count[x]<>count distinct x}
hasdupmax:{1<sum x=max x}
hasdupmin:{1<sum x=min x}

sumrecurringdatapoint:{sum k*g k:where 1<g:count each group x}
sumrecurringval:{sum where 1<count each group x}

/ swap these?
perrecurtoalldata:{sum[1<g]%count g:count each group x}
perrecurtoallval:{sum[g where 1<g:count each group x]%count x}

ratiovalnumtserieslength:{count[distinct x]%count x}
ratiobeyondrsigma:{sum[abs[x-avg x]>y*dev x]%count x}

meanchange:{(x[i]-x 0)%i:count[x]-1}
meanabschange:{avg abs 1_deltas x}
abssumchange:{sum abs 1_deltas x}
mean2dercentral:{avg(.5*sum xprev\:[-1 1;x])-x}

varlargerstd:{1<var x}
largestdev:{dev[x]>y*range x}

getlenseqwhere:{(1_deltas i,count x)where x i:where differ x}
longstrikelessmean:{max getlenseqwhere x<avg x}
longstrikegreatermean:{max getlenseqwhere x>avg x}

cidce:{sqrt .ml.ssq 1_deltas x}
cidceN:{$[0=s:dev x;0.;cidce(x-avg x)%s]}
c3:{0^avg x*prd xprev\:[-1 -2*y;x]}

treverseasymstat:{0^avg(x1*x2*x2:xprev[-2*y]x)-x*x*x1:xprev[-1*y]x}
symmetrylookup:{abs[avg[x]-med x]>y*range x}

quantile:percentile / remove and just use percentile?

autocorr:{(avg(x-m)*xprev[y;x]-m:avg x)%var x}

skewness:{n*sum[m*m*m:x-avg x]%(s*s*s:sdev x)*(n-1)*-2+n:count x}
kurtosis:{((n-1)%(n-2)*n-3)*((n+1)*n*sum[k2*k2]%s*s:sum k2:k*k:x-avg x)+3*1-n:count x}

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

aggonchunk:{y each z cut x} /x:array;y:agg function; z: chunk length 
linagg:{xnew:aggonchunk[x;y;z];lintrend[til (count xnew)-1;-1_xnew]}

/x=data;y=#chunks;z=focus chunk
eratiobychunk:{val:("i"$floor((count x)%y)) cut x;[sum valfocus*valfocus:val[z]]%ssq x}

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
