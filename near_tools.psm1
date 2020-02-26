
function get-nearconfig{
$obj = cat ./nearconfig.json|convertfrom-json
$script:masterAccount = $obj.masterAccount
$script:accountId = $obj.accountId
$script:projectName = $obj.projectName
write-host $obj.projectName
$script:file = "target/wasm32-unknown-unknown/release/$projectName.wasm"
}

function deploy-near{
get-nearconfig
build-near
near deploy --accountId $script:accountId --wasmFile $script:file
}

function call-near($func,$para){
get-nearconfig
$json = convertto-json $para
$zipped = $json.replace("`r`n","")
$zipped = $zipped.replace(" ","")
$zipped =$zipped.replace('"','\"')
$zipped = "`"$zipped`""
near call $script:accountId $func $zipped --accountId $script:accountId
}

function build-near{
get-nearconfig
$env:RUSTFLAGS='-C link-arg=-s'
cargo build --target wasm32-unknown-unknown --release
}

function clear-near {
get-nearconfig
near delete $script:accountId $script:masterAccount
near create_account $script:accountId --masterAccount $script:masterAccount
}

function new-near($projectName){
$cargo_template = "https://raw.githubusercontent.com/Syntacticlosure/near-rust-powershell-toolchain/master/cargo_template.txt"
$lib_template = "https://raw.githubusercontent.com/Syntacticlosure/near-rust-powershell-toolchain/master/lib_template.txt"
$accountId = read-host "your account id"
$masterAccount = read-host "your master account id"
$rawProjectName = $projectName.replace("-","_")
$nearconfig = @{"accountId"=$accountId;"masterAccount"=$masterAccount;"projectName"=$rawProjectName}
cargo new $projectName --lib
cd $projectName
invoke-webrequest $cargo_template|select-object -expandproperty content|out-file cargo.toml -append -encoding utf8
invoke-webrequest $lib_template|select-object -expandproperty content|out-file src/lib.rs -encoding utf8
convertto-json $nearconfig|out-file nearconfig.json
near login
}

