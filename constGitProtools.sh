#!/bin/bash

# protools.sh: A very simple ShellScript.
# ShellScript that builds an environment that manages DAW:Protools session data with git.
# Copyright (c) 2019 Bell's market
#
# Distributed under the terms of the MIT License.
# Redistributions of files must retain the above copyright notice.
#
# @copyright  2019 Bell's market <bellsmarketweb@gmail.com>
# @see       https://github.com/seikan/Cart


# ----------------Required variable declaration
#Absolute path of executable File
SCRIPT_DIR=$(cd $(dirname $0); pwd)

#Declare the path after the document root
#ex ) ~/Protools/SongTitle > "/Protools"
PT_PATH="/Protools"
# ----------------Required variable declaration


function manageGit() {
  git init
  git status
}
function trashFile() {
  if [ -e "${TITLE}_MixDown.ptx" ];then
    rm "${TITLE}_MixDown.ptx"
  fi
  if [ -e "${TITLE}_StartUp.ptx" ];then
    rm "${TITLE}_StartUp.ptx"
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
  findArray=$(find $HOME$PT_PATH -type d -iname "$TITLE")
  IFS_bak=$IFS
  IFS=$'\n'

  #Determining the existence of the session directory of the input title
  if [ -e "$findResult"  ];then
    cd "$findResult"
  else
    findFlag=1
  fi
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
  ptx="$TITLE.ptx"
  if [ -e "$ptx" ];then
    cp -vn "$ptx" "${TITLE}_MixDown.ptx"
    cp -vn "$ptx" "${TITLE}_StartUp.ptx"
  else
    echo "${TITLE}.ptx is Not Exists."
  fi
}

function main() {
  inputSongTitle
  findSongTitle
  if [ ! $findFlag -eq 1 ];then
    exitstenceSubDirectory
    cpyPTFile
    manageGit
  else
    echo "The file you entered does not exist."
  fi
}



main
