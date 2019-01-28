#!/bin/bash

# protools.sh: A very simple ShellScript.
# ShellScript that builds an environment that manages DAW:Protools session data with git.
# Copyright (c) 2019 Bell's market
#
# Distributed under the terms of the MIT License.
# Redistributions of files must retain the above copyright notice.
#
# @copyright  2019 Bell's market <bellsmarketweb@gmail.com>
# @see       https://github.com/bellsmarket/ProtoolsManagement


# ----------------Required variable declaration
#Absolute path of executable File
SCRIPT_DIR=$(cd $(dirname $0); pwd)

#Declare the path after the document root
#ex ) ~/Protools/SongTitle > "/Protools"
PT_PATH="/Protools"
IFS_bak=$IFS
IFS=$'\n'
# ----------------Required variable declaration


function manageGit() {
  git init
  git status
}
function trashFile() {
  if [ -e "${findResult}_MixDown.ptx" ];then
    rm "${findResult}_MixDown.ptx"
  fi
  if [ -e "${findResult}_StartUp.ptx" ];then
    rm "${findResult}_StartUp.ptx"
  fi
  for dir in "${dirArray[@]}"; do
    if [ -e "$dir" ];then
      rm -R "$dir"
      rm -R .git
    fi
  done

}

# Enter the name of the song to search
function inputSongTitle() {
  echo "Please enter the SongTitle to be managed with Protool"
  read TITLE
}



# Search entered song title and assign result to variable
function findSongTitle() {
  findFlag=0
  findArray=($(find $HOME$PT_PATH -type d -iname "*$TITLE*"))
  echo 要素数は${#findArray[*]}
  echo ${findArray[@]}


  i=0
  if [ ${#findArray[*]} = 1 ] && [ "$findArray" = "" ];then
    echo "The file you entered does not exist."
    findFlag=1
    exit 0
  elif [ ${#findArray[*]} = 1 ] && [ ! "$findArray" = "" ];then
    findResult=$(basename "$findArray")
    cd "$findArray"
  else
    echo "Search results Songs will be below. Please enter the appropriate number."
    for song in "${findArray[@]}";do
      echo ${i}：$(basename $song)
      (( i ++))
    done
    read tmpInput
    findResult=$(basename "${findArray[$tmpInput]}")
    cd "${findArray[$tmpInput]}"
  fi

  #Determining the existence of the session directory of the input title
  # if [ -e "$findResult" ];then
  #   cd "$findResult"
  # fi
}


function exitstenceSubDirectory() {
  dirArray=("Audio Files" "Bounced Files" "Melodyne" "Session File Backups" ".gitignore")
  # Determine existence of subdirectory If False, create subdirectory
  for dir in "${dirArray[@]}"; do
    if [ -e "$dir" ];then
      echo "$dir is Exists"
    else
      if [ ! "$dir" = ".gitignore" ]; then
        mkdir -v "$dir"
      else
        touchIgnoreFile #----------------------関数呼び出し
      fi
    fi
  done
}

#Declare document to describe .gitignore
function touchIgnoreFile() {
  ignoreArray=("/Audio Files" "/Bounced Files" "/Clip Groups" "/Melodyne" "/Session File Backups" "/Video Files" "WaveCache.wfm" "*_StartUp.ptx" "*.ptx" "!*_MixDown.ptx")

  touch .gitignore;
  for dir in "${ignoreArray[@]}"; do
    echo "$dir" >> .gitignore
  done
}

function cpyPTFile() {
  ptx="$findResult.ptx"
  if [ -e "$ptx" ];then
    cp -vn "$ptx" "${findResult}_MixDown.ptx"
    cp -vn "$ptx" "${findResult}_StartUp.ptx"
  else
    echo "${findResult}.ptx is Not Exists."
  fi
}

function main() {
  inputSongTitle
  findSongTitle
  if [ $findFlag -eq 0 ];then
    exitstenceSubDirectory
    cpyPTFile
    manageGit
  fi
}


main
