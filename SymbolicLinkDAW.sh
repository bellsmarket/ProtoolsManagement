#!/bin/bash

####################################################
# Script name :symboricDAW
# Discription :Create a symbolic link to a file in Dropbox
# How to : #
#     $1 : -
#     $2 : -
#     Example: #
# Date :2019/11/13
# @see       https://github.com/bellsmarket/ProtoolsManagement
# @copyright  2019 Bell's market <bellsmarketweb+github@gmail.com>
####################################################



function symboricDAW() {
  rm -r "$HOME/Documents/Pro Tools"
  rm -r "$HOME/Documents/Universal Audio"
  rm -r "$HOME/Documents/FXpansion"
  ln -s "$HOME/Dropbox/Various DAW Setting Folder/Pro Tools"  "$HOME/Documents/Pro Tools"
  ln -s "$HOME/Dropbox/Various DAW Setting Folder/Universal Audio"  "$HOME/Documents/Universal Audio"
  ln -s "$HOME/Dropbox/Various DAW Setting Folder/FXpansion" "$HOME/Documents/FXpansion"
}


function main(){
  symboricDAW
}
