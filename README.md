# Getting started

Parse command line style arguments from any string.


```
*Data.ArgParser> argParser defaultParseOptions "  --name name  --desc desc    --command   \"hello world\"  --single-quotes 'single quotes'  --mixed-quotes \"mixed 'quotes'\" a b c 'd' 'e' \"f\" \"    g    \" \"\" '' boom  --dir /tmp/dir"

["--name","name","--desc","desc","--command","hello world","--single-quotes","single quotes","--mixed-quotes","mixed 'quotes'","a","b","c","d","e","f","    g    ","","","boom","--dir","/tmp/dir"]
``````

TODO:
- escape chars

-- adarqui
