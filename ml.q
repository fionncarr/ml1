/load in all the .q scripts within the ml library
\d .ml
sstring:{$[10=type x;;string]x}
loadfile:{$[.z.q;;-1]"Loading ",x:1_string hsym`$sstring x;system"l ",path,"/",x;}
path:{$[count u:@[{1_string first` vs hsym`$u -3+count u:get .z.s};`;""];u;"ml"]}[]
