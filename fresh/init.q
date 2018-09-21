.fresh.loadfile:{$[.z.q;;-1]"Loading ",x;system"l ",.fresh.path,"/",x;} /freshq/",x;}
/ attempts to find the path of this file, defaults to fresh if any problems arise.
.fresh.path:{$[count u:@[{1_string first` vs hsym`$u -3+count u:get .fresh.loadfile};`;""];u;"fresh"]}[]
.fresh.hpath:hsym`$.fresh.path
.fresh.path
.fresh.loadfile"ts_feature_significance.q"
.fresh.loadfile"fresh.q"
.fresh.loadfile"paramdict.q"
