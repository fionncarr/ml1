.utils.loadfile:{$[.z.q;;-1]"Loading ",x;system"l ",.utils.path,"/",x;}
/ attempt to find the path of this file, default to nlp if any problem
.utils.path:{$[count u:@[{1_string first` vs hsym`$u -3+count u:get .utils.loadfile};`;""];u;"utils"]}[]
.utils.hpath:hsym`$.utils.path
.utils.path
\pwd
.utils.loadfile"stats.q"
.utils.loadfile"funcs.q"
.utils.loadfile"preprocess.q"
