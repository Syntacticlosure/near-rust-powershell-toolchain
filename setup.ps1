$setup_path = "https://raw.githubusercontent.com/Syntacticlosure/near-rust-powershell-toolchain/master/near_tools.psm1"
invoke-webrequest $setup_path|select-object -expandproperty content|out-file ~/near_tools.psm1 -encoding utf8