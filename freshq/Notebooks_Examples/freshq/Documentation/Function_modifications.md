### ** embedPy related functions: **

Function Name      | Bottlenecks |
-------------------|-------------|
lintrend           | 'Scipy.stats.t.sf' (Student’s T continuous randomvariable), needed for calculation of stderr.|
numcwtpeaks        | Requires the scipy.signal function 'find_peaks_cwt' which applys a ‘ricker’ wavelet to the data and will take time to implement.|
fftaggreg          | Uses 'np.fft.rfft' and 'np.abs' to compute a fourier transform, bottlenecked by the lack of complex numbers in q.| 
fftcoeff           | Similar to 'fftaggreg' with the additional use of np.real/np.imag and np.angle to take specific.|
augfuller          | Uses a scipy module 'tsa.stattools' named 'adfuller' which completes an augmented dickey fuller test. his is several layers deep and seems complicated to implement in q.|
spktwelch          | Calculates coefficients of a power spectrum which requires a fourier transform at its backend. This function also appears to requires a large number of numpy functions which would need to be translated. |
partautocorrelation| Would require the production of a levinson-durbin recursion algorithm... appears to be non-trivial.|
aggautocorr        | Requirement for a fourier transform a number of layers into the source code within an autocovariance function.|
fisherexact        | Uses 'scipy.stats.fisher`_`exact' (issues with overflow in q implementation need to be resolved before q is used).|
ks2samp            | Uses 'scipy.kstwobign.sf' which is at its core a ‘special’ scipy function for the the calculation of the cumulative distribution function of the kolmogorov distribution.|
ktaupy             | Currently implemented completely using embedPy, the q implementation which produces results close to the python version is currently very slow, and a faster/simpler version which had been attempted is not close to the python result. |

### ** Presently Unimplemented functions: **

Function Name                         | Reasoning   |
--------------------------------------|-------------|
Approximate Entropy                   | Large number of for loops required in the python implementation, also requires a version of np.newaxis |
Sample Entropy                        | Similar to Approximate Entropy requires a number of complex for loops... These functions are said to be computationally expensive in python and have a run time far in excess of the other functions in the tsfresh algorithm
Autoregressive Coefficients           | Uses 'statsmodels.tsa.ar`_`model' and its '.fit' function the implementation for which appears non-trivial... The function also uses for loop which seemed complex to implement in q. |
`_`estimate`_`friedrich`_`coefficients| Has heavy reliance on pandas df structures and needs the calculation of the coefficients of a polynomial fitted to the langevin model. |
Friedrich Coefficients                | Needs '`_`estimate`_`friedrich`_`coefficients' to function correctly
Max Langevin Fixed Points             | Again needs `_`estimate`_`friedrich`_`coefficients to work, would also require a version of np.roots which returns complex values and again requires polynomial fitting.