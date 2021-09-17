#!/bin/bash
####################################################
# Script name : ---.sh
# Discription :
# How to : # ---.sh
#     \$1 : -
#     \$2 : -
#     Example: # ---.sh
# Date : 2021/MM/DD
echo $DATE
# @copyright  2021 Bell's market <bellsmarketweb+github@gmail.com>
# @see       https://github.com/bellsmarket

####################################################

UA="/Library/Application Support/Avid/Audio/Plug-Ins/Universal Audio"
jsonFILE="./UAPlugins.json"
# - $UAをリスト化 = AllPlugins.txt
# - 使えるプラグインをリスト化 = AuthPlugins.txt
# - 不要なプラグインをリスト化 = DisusePlugins.txt
# - JSONファイルにまとめられる
# - 不要なプラグインを移動する


function makePluginJson() {
  if [[ -d $UA ]]; then
    echo "Exist"
    count=1
    find "$UA" -type d -maxdepth 1|sort -f| sed "s|$UA||g"|sed "s|\(^/\)||g"|sed -e '1d'| while read plug

  do
    echo {
    echo    \"pluginID\": $count,
    echo    \"pluginName\": \"$plug\",
    echo    \"authentication\": 0,
    echo    \"position\": 0
    echo },
    count=$((count+1))
  done > $jsonFILE

  gsed -i '$ s/\}\,/\}/g' $jsonFILE
  gsed -i '1i[' $jsonFILE
  gsed -i '$a]' $jsonFILE
else
  echo "No Exist"
  fi
}

function checkAuthPlugin() {
  if [[ -f "./AuthorizedPlugIns.txt" ]]; then
    echo "Exists."
    while read tmp ; do
      jq '(.[]| select (.pluginName == "'"$tmp"'")| .authentication=1)' "$jsonFILE"
    done < ./AuthorizedPlugIns.txt
  fi

}

# function main {{{
function main() {
  # makePluginJson
  checkAuthPlugin
  return 0
}
# }}}

main "$@"
