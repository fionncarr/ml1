\d .fresh
paramdict:
	select
  		binnedentropy:(select lag:(2 5 10) from (0#`)!()),
		cidce:(select boolean:01b from (0#`)!()),
		numcrossingm:(select crossing:(-1 0 1) from (0#`)!()),
		ratiobeyondrsigma:(select sigma:(0.5 1 1.5 2 2.5 3 5 6 7 10) from (0#`)!()),
		largestdev:(select percent:(1_til 20)*0.05 from (0#`)!()),
		c3:(select lag:(1 2 3) from (0#`)!()),
		autocorr:(select lag:(til 10) from (0#`)!()),
		indexmassquantile:(select q:(0.1*1+til 9) from (0#`)!()),
		numcwtpeaks:(select width:(1 5) from (0#`)!()),
		numpeaks:(select support:(1 3 5 10 50) from (0#`)!()),
		symmetriclooking:(select rangepercent:0.05*(til 20) from (0#`)!()),
  		treverseasymstat:(select lag:(1 2 3) from (0#`)!()),
		quantile:(select quantile:(1 _til 10)*0.1 from (0#`)!()),
		valcount:(select val:(0 1 0n 0w -0w) from (0#`)!()),
		spktwelch:(select coeff:(2 5 8) from (0#`)!()),
		rangecount:(select minval:(-1),maxval:(1) from (0#`)!()),
		partautocorrelation:(select lag:(til 10) from (0#`)!()),
		changequant:(select ql:(0 0.2 0.4 0.6 0.8),
				    qh:(0.2 0.4 0.6 0.80 1),
				    isabs:01b,
			     from (0#`)!()),
		fftcoeff:(select attrib:(`real`imag`abs`angle),
				 coeff:(til 100)
			  from (0#`)!()),	 
		agglintrend:(select attrib:`slope`intercept`p`rval,
				    chunklen:(5 10 50),
				    aggfn:`max`min`mean`variance
                             from (0#`)!()),
		eratiobychunk:(select numsegments:(10),
				      segmentfocus:(til 10)
			       from (0#`)!())				
	from (0#`)!()
