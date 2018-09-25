\l utils/stats.q
\l utils/funcs.q
\l utils/preprocess.q

np:.p.import[`numpy]
skmetric:.p.import[`sklearn.metrics]
skpreproc:.p.import[`sklearn.preprocessing]
stats:.p.import[`scipy.stats]
MinMaxScaler:skpreproc[`:MinMaxScaler][]
StdScaler:skpreproc[`:StandardScaler][]

tabtest:([]10?`4;10?100;10?100;10?00:00:02.000;10?10f)
smalltab:([]1000?1000;1000?1000;1000?1000)
plaintab:([]4 5 6;1 2 3;-1 -2 -3;0.4 0.5 0.6)
nulltab:([]til 5;@[5?10f;2;:;0n];5?100;@[5?10f;0 1;:;0n];5#0;5#0n)
plainmat:flip value flip plaintab

x:1000?40
y:1000?40
xf:1000?100f
yf:1000?100f
xb:010010101011111010110111b
yb:000000000001000000111000b
onehotx:`a`p`l`h`j

.ml.utils.arange[2;100;2] ~ `long$np[`:arange][2;100;2]`

.ml.utils.arange[2.5;50.2;0.2] ~ np[`:arange][2.5;50.2;0.2]`
.ml.utils.shape[1 2 3*/:1 2 3] ~ np[`:shape][1 2 3*/:1 2 3]`
.ml.utils.shape[1 2 3*/:til 10] ~ np[`:shape][1 2 3*/:til 10]`
.ml.utils.linspace[1;10;9] ~ np[`:linspace][1;10;9]`
.ml.utils.linspace[-0.2;109;62] ~ np[`:linspace][-0.2;109;62]`
.ml.utils.range[til 63] ~ 62

.ml.utils.traintestsplitseed[til 10;1+til 10;0.2;43]~`xtrain`ytrain`xtest`ytest!(0 3 5 8 7 2 6 4;1 4 6 9 8 3 7 5;9 1;10 2)

.ml.utils.dtypes[tabtest] ~`x`x1`x2`x3`x4!(11h;7h;7h;19h;9h)
.ml.utils.enum[tabtest] ~ update x:til 10 from tabtest

.ml.utils.accuracy[x;y] ~ skmetric[`:accuracy_score][x;y]` 
.ml.utils.mse[x;y] ~ skmetric[`:mean_squared_error][x;y]`
.ml.utils.sse[x;y] ~ sum d*d:x-y

(value .ml.utils.corrmat[plaintab]) ~ "f"$([]1 1 -1 1;1 1 -1 1;-1 -1 1 -1;1 1 -1 1)
(value .ml.utils.confmat[xb;yb]) ~ (8 12;1 3)

1 = count distinct min each (value .ml.utils.describe[plaintab]) = value .ml.utils.df2tab .p.import[`pandas][`:DataFrame.describe][.ml.utils.tab2df[plaintab]]

.ml.utils.tscoreeq[x;y]~abs first stats[`:ttest_ind][x;y]`

.ml.utils.precision[xb;yb;1b] ~ skmetric[`:precision_score][yb;xb]`
.ml.utils.sensitivity[xb;yb;1b] ~ skmetric[`:recall_score][yb;xb]`
.ml.utils.specificity[xb;yb;1b] ~ skmetric[`:recall_score][yb;xb;`pos_label pykw 0]`

.ml.utils.onehot[onehotx] ~ "f"$(1 0 0 0 0;0 0 0 0 1;0 0 0 1 0;0 1 0 0 0;0 0 1 0 0)

MinMaxScaler[`:fit][plainmat];
StdScaler[`:fit][plainmat];
.ml.utils.minmaxscaler[plainmat] ~ "f"$MinMaxScaler[`:transform][plainmat]`
.ml.utils.stdscaler[plainmat] ~ "f"$StdScaler[`:transform][plainmat]`

(cols .ml.utils.powerset[smalltab;0]) ~ `x`x1`x2`x_x1`x_x2`x1_x2`x_x1_x2
(cols .ml.utils.polytab[plaintab;3;0]) ~ `x_x1_x2`x_x1_x3`x_x2_x3`x1_x2_x3

.ml.utils.tablerolldrop[plaintab;`x;2] ~ ([]`t5`t5;1 2;-1 -2;0.4 0.5)

.ml.utils.checknulls[nulltab] ~ `x1`x3`x5
(cols .ml.utils.dropconstant[nulltab]) ~ `x`x1`x2`x3
