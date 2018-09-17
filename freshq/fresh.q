/fresh algorithm implementaion in q
/ https://arxiv.org/pdf/1610.07717v3.pdf 

/embedPy is required

\l p.q

/force python to refrain from producing version warnings.
.p.import[`warnings][`:filterwarnings]["ignore"];

\d .fresh

/ features from raw data, single outputs
feat.absenergy:{x wsum x}                                                           / absolute energy = sum of squares
feat.abssumchange:{sum abs 1_deltas x}                                              / sum of absolute values of deltas
feat.autocorr:{(avg(x-m)*xprev[y;x]-m:avg x)%var x}                                 / x values, y lag 
feat.binnedentropy:{neg sum p*log p:hist["f"$x;y][0]%count x}                       / measure of 'chunked' system entropy 
feat.c3:{0^avg (-2*y) _x*prd xprev\:[-1 -2*y;x]}                                    / measure of t-series non-linearity Schreiber, T. and Schmitz, A. (1997). PHYSICAL REVIEW E, VOLUME 55, NUMBER 5
feat.changequant:{[x;ql;qh;isabs]                                             / mean of changes of series inside corridor
 diff:$[isabs;abs;]1_deltas x;
 incor:min (>[x];<[x])@'feat.quantile[x]each ql,qh;
 k:diff where 1_&':[incor];
 `max`min`avg`var`dev!(max k;min k;avg k;var k;dev k)}
feat.cidce:{sqrt k$k:"f"$1_deltas$[not y;x;0=s:dev x;:0.;(x-avg x)%s]}              / measure of time series complexity ref- http://www.cs.ucr.edu/~eamonn/Complexity-Invariant%20Distance%20Measure.pdf
feat.count:{count x}
feat.countabovemean:{sum x>avg x}						      
feat.countbelowmean:{sum x<avg x}
/x=data;y=#chunks;z=focus chunk
feat.eratiobychunk:{val:("i"$floor((count x)%y)) cut x;[sum valfocus*valfocus:val[z]]%absenergy[x]} / TODO
feat.firstmax:{(x?max x)%count x}                                                    / relative index of first occurence of max value (relative index = i/count x)
feat.firstmin:{(x?min x)%count x}                                                    / relative index of first occurence of min value
feat.hasdup:{count[x]<>count distinct x}
feat.hasdupmax:{1<sum x=max x}
feat.hasdupmin:{1<sum x=min x}
feat.indexmassquantile:{(1+(sums[x]%sum x:abs x)binr y)%count x}                     / relative index (into y) where y% of mass of x is to the left
feat.kurtosis:{((n-1)%(n-2)*n-3)*((n+1)*n*sum[k2*k2]%s*s:sum k2:k*k:x-avg x)+3*1-n:count x} / TODO
feat.largestdev:{dev[x]>y*max[x]-min x}                                              / is standard deviation of x > y * range x ?
feat.lastmax:{(last where x=max x)%count x}                                          / relative index of last occurence of max value (relative index = i/count x)
feat.lastmin:{(last where x=min x)%count x}                                          / relative index of last occurence of min value
feat.longstrikeltmean:{p:max getlenseqwhere x<avg x;$[p<>-0W;p;0]}                   / longest run of values < mean
feat.longstrikegtmean:{p:max getlenseqwhere x>avg x;$[p<>-0W;p;0]}                   / longest run of values > mean
feat.max:{max x}
feat.mean:{avg x}
feat.meanabschange:{avg abs 1_deltas x}
feat.meanchange:{(x[n]-x 0)%n:-1+count x}                                            / mean absolute differences between successive t-series values
feat.mean2dercentral:{avg(.5*sum xprev\:[-1 1;x])-x}                                 / mean value of second derivative of t-series under central approximation
feat.med:{med x}
feat.min:{min x}
feat.numcrossingm:{sum 1_differ x>y}                                                  / x=data;y=threshold, number of times x crosses y, e.g if y=0, number of sign changes of x
feat.numcwtpeaks:{count(findpeak[x;arange[1;y+1;1]]`)}                                / 'ricker wavelet specification removed... it is default in find_peak_cwt
feat.numpeaks:{sum all each flip peakfind[x;y;]each 1+til y}                          / number of peaks of support y in time series x (peak defined as x[i] larger than y values left and right)
feat.perrecurtoalldata:{sum[1<g]%count g:count each group x}                          / ratio of count[distinct values which reoccur]%count distinct values
feat.perrecurtoallval:{sum[g where 1<g:count each group x]%count x}                   / ratio of count[reoccuring points]%count points
feat.quantile:{r[0]+(p-i 0)*last r:0^deltas x iasc[x]i:0 1+\:floor p:y*-1+count x}
feat.rangecount:{sum[[x>=y] and x<z]}                                                 /x=data;y=min val;z=max val, TODO x within would be handier if definition does not need to match python
feat.ratiobeyondrsigma:{sum[abs[x-avg x]>y*dev x]%count x}
feat.ratiovalnumtserieslength:{count[distinct x]%count x}
feat.skewness:{n*sum[m*m*m:x-avg x]%(s*s*s:sdev x)*(n-1)*-2+n:count x}
feat.stddev:dev
feat.sumrecurringdatapoint:{sum k*g k:where 1<g:count each group x}
feat.sumrecurringval:{sum where 1<count each group x}
feat.sumval:{sum x}                                                                   / TODO, this one sums data points not values
feat.symmetriclooking:{abs[avg[x]-med x]>y*max[x]-min x}                              / distribution looks symmetric
feat.treverseasymstat:{0^avg(-2*y)_(x1*x2*x2:xprev[-2*y]x)-x*x*x1:xprev[-1*y]x}
feat.valcount:{sum x=y}
feat.var:{var x}
feat.vargtstddev:{1<var x}



/ multi-outputs
/aggregated linear trend outputs
feat.agglintrend:{lintrend aggonchunk[x;y]}
/aggregated autocorrelation
feat.aggautocorr:{n:count x;
 $[((abs var x) < 10 xexp -10) or n=1;a:0;a:1 _acf[x;`unbiased pykw 1b;`fft pykw n>1250]`];
 `avg`med`var`dev!(avg a;med a;var a;dev a)}
/linear trend parameters
feat.lintrend:{
 k:1+til count x;df:(n:count k)-2; 
 rnum:cov[k;x];rden:sqrt cov[k;k]*cov[x;x];rval:$[rden=0;0f;rnum%rden];
 slope:rnum%cov[k;k];intercept:avg[x]-slope*avg k-1;
 $[n=2;$[x[0]=x[1];[p:1;stderr:0];[p:0;stderr:0n]];
  [t:rval*sqrt df%(1f-rval+tiny)*1f+rval+tiny:1e-20;stderr:sqrt(1-rval*rval)*cov[x;x]%cov[k;k]*df;p:2*tdistrib[abs t;df]`;]];
 `slope`intercept`rval`p`stderr!slope,intercept,rval,p,stderr
 }

partautocorrelation:{[x;lag]
 maxreqlag:max lag;
 n:count x;
 $[n<=1;
 (1+maxreqlag)#0n;
 [$[n<=maxreqlag;maxlag:maxreqlag-1;maxlag:maxreqlag];
 paccoeff:pacf[x;`nlags pykw maxlag;`method pykw `ld]`;
 paccoeff:paccoeff[lag],(max 0,maxreqlag-maxlag)#0n]];
 r:({`$"lag_",string x}each lag)!paccoeff}

spktwelch:{[x;coeff]
 dict:`freq`pxx!welch[x]`;
  $[n:count dict[`pxx]<=max coeff;
 [reducedcoeff:coeff where coeff<n;
 notreducedcoeff:coeff except reducedcoeff;
 pxx:dict[`pxx][reducedcoeff],((count notreducedcoeff)#0n)];
 pxx:dict[`pxx][coeff]];
 r:({`$"coeff_",string x}each coeff)!pxx}

fftcoeff:{[x;y;z]
 fftx:rfft[x];
 $[z<(count npangle[fftx]`);
  $[y = `real;(npreal[fftx]`)z;y = `abs;(npabs[fftx]`)z;y = `imag;(npimag[fftx]`)z;y=`angle;(npangle[fftx;`deg pykw 1b]`)z;0n]
  ;0n]}

/ The following 2 functions can be implemented now but are time consuming calculations
augfuller:{[x]
 k:{adfuller[x]`};
 res:@[k;x;3#0n];
 r:`teststat`pvalue`usedlag!(res[0];res[1];res[2])}

fftaggreg:{[x] getmoment:{[y;moment](("f"$y)$("f"$arange[0;count y;1])xexp moment)%(sum y)};
 l:absolute[rfft[x]`]`;
 centroid:getmoment[l;1];m2:getmoment[l;2];m3:getmoment[l;3];m4:getmoment[l;4];
 getvariance:{x-(y xexp 2)};variance:getvariance[m2;centroid];
 getskew:{[l;y;z;k]$[z<0.5;0n;((k-3*y*z)-(y xexp 3))%(z xexp 1.5)]};skew:getskew[l;centroid;variance;m3];
 getkurtosis:{[l;y;z;m2;m3;m4]$[z<0.5;0n;((m4-4*y*m3-3*y)+(6*m2*y*y))%(z xexp 2)]};kurtosis:getkurtosis[l;centroid;variance;m2;m3;m4];
 `centroid`variance`skew`kurtosis!centroid,variance,skew,kurtosis}


/ utils for the above
tdistrib:.p.import[`scipy.stats]`:t.sf;
rfft:.p.import[`numpy]`:fft.rfft;
absolute:.p.import[`numpy]`:abs;
findpeak:.p.import[`scipy.signal]`:find_peaks_cwt;
pacf:.p.import[`statsmodels.tsa.stattools]`:pacf
adfuller:.p.import[`statsmodels.tsa.stattools]`:adfuller
acf:.p.import[`statsmodels.tsa.stattools]`:acf
welch:.p.import[`scipy.signal]`:welch
npreal:.p.import[`numpy]`:real
npangle:.p.import[`numpy]`:angle
npimag:.p.import[`numpy]`:imag
npabs:.p.import[`numpy]`:abs

/x:data;y:chunk length
aggonchunk:{
 n:y cut x;
 `max`min`avg`var`dev!(max each n;min each n;avg each n;var each n;dev each n)}
getlenseqwhere:{(1_deltas i,count x)where x i:where differ x}
arange:{x+z*til ceiling(y-x)%z}                                                              / x until y
hist:{(count each value(asc key g)#g:group(-1_a) bin x;a:min[x]+til[1+y]*(max[x]-min x)%y)} /x=data;y=#bins
peakfind:{
 xreduced:neg[y] _y _x;
 droproll:{neg[y] _y _z xprev x};
 if[z=1;res:xreduced>droproll[x;y;z];res&:xreduced>droproll[x;y;(neg z)]];
 if[z<>1;res&:xreduced>droproll[x;y;z];res&:xreduced>droproll[x;y;(neg z)]];
 r:res}



getsingleinputfeatures:{where[{1=count x y}[{$[100=type x;get[x]1;()]}]each .fresh.feat]#.fresh.feat}

createfeatures:{[data;aggs;cnames;funcs]
 mkname:{`$"_"sv string x[0],x 2}; 
 r:?[data;();aggs!aggs:aggs,();mkname'[comb]!1_'comb:(flip(key;value)@\:funcs)cross cnames];
 / flatten multi output cols
 if[count mcols@:where 98=type each value[r]mcols:exec c from meta[r]where null t;
  r:key[r]!(mcols _ value r){x,'y}/{(`$"_"sv'string x,'cols y)xcol y}'[mcols;value[r]mcols]];
 r} 

significantfeatures:{[table;targets]
 table:(where 0=var each flip table)_table;
 bintest:{2=count distinct x};
 bintarget:bintest targets;
 bincols:where bintest each flip table;
 realcols:cols[table]except bincols;
 bintab:bincols#table;
 realtab:realcols#table;
 pvals:raze$[bintarget;
         {y[x;]each flip z}[targets]'[ks2samp,fishertest;(realtab;bintab)];
         {y[x;]each flip z}[targets]'[ktaupy,ks2samp;(realtab;bintab)]];
 insignificant:benjhochfind[pvals;0.05];
 res:table;
 if[count insignificant;res:insignificant _ table];
 res}
