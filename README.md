# near-rust-powershell-toolchain
simplify workflows of building near-rust contract on windows

### setup
```$xslt
$setup_path = "https://raw.githubusercontent.com/Syntacticlosure/near-rust-powershell-toolchain/master/near_tools.psm1"
invoke-webrequest $setup_path|select-object -expandproperty content|out-file ~/near_tools.psm1 -encoding utf8
```

### create a new near contract project
```$xslt
import-module ~/near_tools.psm1
new-near test-project
```
template codes will be generated automatically.

### build and deploy
```$xslt
build-near   # just build
deploy-near  # build and deploy
```

### call
```$xslt
call-near methodName @{"arg1"=1;"arg2"="str"}
```

### redeploy
```$xslt
clear-near  # delete current account and recreate it
```
