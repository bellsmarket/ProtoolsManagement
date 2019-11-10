#!/bin/bash

# テスト用プログラム


HOSTNAME=`uname -n`
BASEDIR="$(cd $(dirname $0) && pwd)"
BASENAME=${0##*/}
LOGDIR="${HOME}//Dropbox/Program/log"
LOGFILE=update_brew.log
SUCCESSFLG=0
IFS=$',\n'

########################################
###        Variable List
########################################
ALLPLUGINLIST=(`cat ./all.txt`)
AllPLUG_len=${#ALLPLUGINLIST[@]}


AuthFILELIST=(`cat ./Authorized-Plug-ins.txt`)
Auth_len=${#AuthFILELIST[@]}

Unused_len=0 

# Adjust the files to be moved.
function makeMoveList() {
  MOVELIST="./removePlugin.txt"
  i=0

  #Check file Exists.  
  if [ ! -e "$MOVELIST" ];then
    mkdir -v $MOVELIST

    while [ $i -lt $AllPLUG_len ] ; do
      tmp=(`eval echo "${all[$i]}"`)
      echo $tmp >> $MOVELIST
      # eval echo  "${ALLPLUGINLIST[$i]}"
      (( i ++ ))
    done

  fi

  #Check file empty.
  if [ ! -s "$MOVELIST" ];then

    while [ "$i" -lt "$AllPLUG_len" ] ; do

      tmp=(`eval echo "${ALLPLUGINLIST[$i]}"`)
      echo $tmp >> $MOVELIST
      (( i ++ ))
      # eval echo  "${all[$i]}"
    done

    echo File was added List because it was empty.
    echo ""
  fi
}

###########################################################


# j=0
# while [ $j -lt $Auth_len ] ; do

#   eval echo  "${AuthFILELIST[$j]}"
#   (( j ++ ))
# done

###########################################################
#Unused Plug-ins are extracted by comparing All Plug-ins with Authentication Plug-ins.
function matchPlugin () {
  UNUSEDFILE="removePlugin.txt"
  i=0

  while [ $i -lt $AllPLUG_len ]; do

    tmpALL=(`eval echo "${ALLPLUGINLIST[$i]}"`)
    (( i ++ ))
    j=0

    while [ $j -lt $Auth_len ]; do
      tmpUSE=(`eval echo  "${AuthFILELIST[$j]}"`)

      if [ "$tmpALL" = "$tmpUSE" ]; then
        echo $tmpUSE" : Matched -> File has been moved. "
        gsed  -i "/${tmpUSE}/d" $UNUSEDFILE
        (( Unused_len ++ ))
      fi
      (( j ++ ))
    done
  done
}

function cntPlugin() {
  echo "全てのプラグインの数は "$AllPLUG_len
  echo "認証されたプラグインの数は "$Auth_len
  echo "不要なプラグインの数は " $(( AllPLUG_len - Auth_len ))
}

function main() {
  cntPlugin
  makeMoveList
  matchPlugin
}

main