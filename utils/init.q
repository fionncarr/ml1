.mlutils.loadfile:{$[.z.q;;-1]"Loading ",x;system"l ",.mlutils.path,"/",x;} /mlutils/",x;}
/ attempt to find the path of this file, default to nlp if any problem
.mlutils.path:{$[count u:@[{1_string first` vs hsym`$u -3+count u:get .mlutils.loadfile};`;""];u;"mlutils"]}[]
.mlutils.hpath:hsym`$.mlutils.path
.mlutils.loadfile"stats.q"
.mlutils.loadfile"funcs.q"
.mlutils.loadfile"preprocess.q"
