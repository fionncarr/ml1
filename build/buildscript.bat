if not defined QLIC_KC (
 goto :nokdb
)

set PATH=C:\Miniconda3-x64;C:\Miniconda3-x64\Scripts;%PATH%
conda update -q conda
conda info -a
conda install -c kx embedPy
exit /b 0

:error
echo failed with error 
exit /b 

:nokdb
echo no kdb
exit /b 0
