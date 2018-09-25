.utils.loadfile:{$[.z.q;;-1]"Loading ",(string x);system"l ",.utils.path,"/",string x;}
.utils.path:{$[count u:@[{1_string first` vs hsym`$u -3+count u:get .utils.loadfile};`;""];u;"utils"]}[]
/ attempt to find the path of this file, default to utils if any problem
.utils.path
.utils.loadfile`stats.q
.utils.loadfile`funcs.q
.utils.loadfile`preprocess.q
