#!/bin/bash

#UAD Powered Plug-Ins:9.7.0
#UAD plugin creates all plugins for Ptotools each time it is updated.
#It is very troublesome to move plugins that are not authorized each time.
#If you read the authorized plug-in list, it automatically moves plug-ins that you do not use to unused folders.

# Copyright (c) 2019 Bell's market
#
# @copyright  2019 Bell's market <bellsmarketweb@gmail.com>
# @see       https://github.com/bellsmarket/ProtoolsManagement

#-------------------Valiable List----------------------
IFS=$',\n'
currentPath=$(cd $(dirname $0); pwd)
PTPluginDir="/Library/Application Support/Avid/Audio/"

movePluginList="unUsedPlug-Ins.txt"
moveListPath="$PTPluginDir""$movePluginList"
UAD="Universal Audio"
usedUAD=$PTPluginDir"Plug-Ins/"$UAD
unUsedDir=$PTPluginDir"Plug-Ins (Unused)/"
unUsedUAD=$unUsedDir$UAD
#-------------------Valiable List----------------------

# Output all variables
function echoValiable() {
	echo -e "\033[0;36mcurrentPath ->\033[0;39m" $currentPath
	echo -e "\033[0;36mPTPluginDir ->\033[0;39m" $PTPluginDir
	echo -e "\033[0;36mmovePluginList ->\033[0;39m" $movePluginList
	echo -e "\033[0;36mmoveListPath ->\033[0;39m" $moveListPath
	echo -e "\033[0;36mUAD ->\033[0;39m" $UAD
	echo -e "\033[0;36musedUAD ->\033[0;39m" $usedUAD
	echo -e "\033[0;36munUsedUAD ->\033[0;39m" $unUsedUAD
}

# Confirm existence of folder and create
function makeunUsedDir() {
	if [ ! -e $unUsedUAD ]; then
		mkdir -v $unUsedDir
	fi
}

#Load unused Plugin list and Assign it to array
function makePluginArray() {
	pluginArray=(`cat $moveListPath`)
	array_size=${#pluginArray[@]}
	echo "Plug-ins not using = $array_size"
}

#Display all contents of the list
function findPlugin () {
	i=0
	while [ $i -lt $array_size ] ; do
		eval echo  "${pluginArray[$i]}"
		find $usedUAD -iname "${pluginArray[$i]}" -maxdepth 3
		(( i ++ ))
	done
}


function movePluginToUnUsed() {
	i=0
	if [ -e "$usedUAD" ]; then
		while [ $i -lt $array_size ] ; do
			find "$usedUAD" -iname "${pluginArray[$i]}" -maxdepth 1 -exec mv -i {} $unUsedUAD \;
			(( i ++ ))
		done
		echo -e "\033[0;31mMovement of the file is complete\033[0;39m"
	else
		echo -e "\033[0;31mDirectory Path NG\033[0;39m"
	fi
}

function main() {
	# echoValiable
	makeunUsedDir
	makePluginArray
	# findPlugin
	movePluginToUnUsed
}

main
