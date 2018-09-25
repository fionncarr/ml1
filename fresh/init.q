.fresh.loadfile:{$[.z.q;;-1]"Loading ",(string x);system"l ",.fresh.path,"/",string x;}
.fresh.path:{$[count u:@[{1_string first` vs hsym`$u -3+count u:get .fresh.loadfile};`;""];u;"fresh"]}[] 
/ attempts to find the path of this file, defaults to fresh if any problems arise.
.fresh.loadfile`ts_feature_significance.q
.fresh.loadfile`fresh.q
.fresh.loadfile`paramdict.q
