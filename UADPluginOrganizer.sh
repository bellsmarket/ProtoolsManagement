#!/bin/bash

#UAD Powered Plug-Ins:9.7.0 -> 9.10.02
#UAD plugin creates all plugins for Ptotools each time it is updated.
#It is very troublesome to move plugins that are not authorized each time.
#If you read the authorized plug-in list, it automatically moves plug-ins that you do not use to unused folders.

# @copyright  2019 Bell's market <bellsmarketweb+github@gmail.com>
# @see       https://github.com/bellsmarket/ProtoolsManagement
# @Update 2019/11/11 

#-------------------Valiable List----------------------
IFS=$',\n'
BASSPATH=$(cd $(dirname $0); pwd)
UAD="Universal Audio"

WORKPATH="/Library/Application Support/Avid/Audio"
#UsedDirName
USEDPLUGIN="Plug-Ins"

# UnusedDirName
UNUSEDPLUGIN="Plug-Ins (Unused)"

GITHUBPATH="/Users/bellsmarket/Github/ProtoolsManagement"
PlugInsList=("AllPlugIns.txt" "AuthorizedPlugIns.txt" "NotAuthPlugIns.txt")

TARGETPATH="/Library/Application Support/Avid/Audio/Plug-Ins (Unused)/Universal Audio"
LISTPATH=${WORKPATH}/${USEDPLUGIN}/${UAD}
# ${PlugInsList[0]}  All
# ${PlugInsList[1]}  Auth
# ${PlugInsList[2]}  NotAuth
#-------------------Valiable List----------------------


#Create a file with all plug-ins listed
function makeAllList() {
	echo "makeAllList() is Called"
	cd $WORKPATH
	cd $USEDPLUGIN
	cd $UAD

	ls -l ${LISTPATH}|awk '{print $9" "$10" "$11" "$12" "$13" "$14}' > $GITHUBPATH/${PlugInsList[0]}
}


function makeUADNotAuthDir() {
	echo "makeUADNotAuthDir() is Called"
	cd $WORKPATH
	cd $UNUSEDPLUGIN
	if [ ! -e "$UAD"  ]; then
		mkdir $UAD
	fi

}
# Confirm existence of folder and create
function dirCheck() {
	cd $1

	if [ ! -e "$2" ];then
		mkdir -v $2
	fi

	cd $2
	if [ ! -e "$3" ];then
		mkdir -v $3
	fi
	echo $2 Folder check complete!.
}


function test() {
	# Auth Plug-In Folerの判定　-> Create Dir
	dirCheck $WORKPATH $USEDPLUGIN $UAD

	# NotAuth Plug-In Folerの判定　-> Create Dir
	dirCheck $WORKPATH $UNUSEDPLUGIN $UAD
}


# function makeSymboricLink() {
# 	sudo ln -s ${HOME}/Github/ProtoolsManagement/AuthorizedPlugIns.txt  ${WORKPATH}/AuthorizedPlugIns.txt
# 	sudo ln -s ${HOME}/Github/ProtoolsManagement/AllPlugIns.txt  ${WORKPATH}/AllPlugIns.txt
# 	sudo ln -s ${HOME}/Github/ProtoolsManagement/NotAuthPlugIns.txt  ${WORKPATH}/NotAuthPlugIns.txt
# }

function makeMoveList() {
	echo "makeMoveList() is Called"
	cd $GITHUBPATH

	ALLPLUGINLIST=(`cat ${PlugInsList[0]}`)
	AllPLUG_len=${#ALLPLUGINLIST[@]}

	AuthPLUGINLIST=(`cat ${PlugInsList[1]}`)
	Auth_len=${#AuthPLUGINLIST[@]}
	Unused_len=0 

	i=0
  #Check file Exists.  
  if [ ! -e "${PlugInsList[2]}" ];then
  	touch ${PlugInsList[2]}

  	while [ $i -lt $AllPLUG_len ] ; do
  		tmp=(`eval echo "${ALLPLUGINLIST[$i]}"`)
  		echo $tmp >> ${PlugInsList[2]}
      # eval echo  "${ALLPLUGINLIST[$i]}"
      (( i ++ ))
    done

  fi

  #Check file empty.
  if [ ! -s "${PlugInsList[2]}" ];then

  	while [ "$i" -lt "$AllPLUG_len" ] ; do

  		tmp=(`eval echo "${ALLPLUGINLIST[$i]}"`)
  		echo $tmp >> ${PlugInsList[2]}
  		(( i ++ ))
      # eval echo  "${all[$i]}"
    done

    echo File was added List because it was empty.
    echo ""
  fi
}



#Unused Plug-ins are extracted by comparing All Plug-ins with Authentication Plug-ins.
function matchPlugin () {
	echo "matchPlugin() is Called"
	i=0

	while [ $i -lt $AllPLUG_len ]; do
		tmpALL=(`eval echo "${ALLPLUGINLIST[$i]}"`)
		(( i ++ ))
		j=0
		while [ $j -lt $Auth_len ]; do
			tmpUSE=(`eval echo  "${AuthPLUGINLIST[$j]}"`)

			if [ "$tmpALL" = "$tmpUSE" ]; then
				echo ${tmpALL} " : Matched -> File has not been moved. "
				gsed  -Ei "/${tmpUSE}/d" ${PlugInsList[2]}
				(( Unused_len ++ ))
			fi
			(( j ++ ))
		done
	done


j=0




	gsed -i "/AllPlugIns.txt/d" ${PlugInsList[2]}
	gsed -i "/Icon/d" ${PlugInsList[2]}
	gsed -i "/.DS_Store/d" ${PlugInsList[2]}

}


function cntPlugin() {
	echo "cntPlugin() is Called"
	echo "Number of all Plug-Ins: "$AllPLUG_len
	echo "Number of Authentication Plug-Ins: "$Auth_len
	echo "Number of Not Authentication Plug-Ins: " $(( AllPLUG_len - Auth_len ))
}



# Output all variables
function echoValiable() {
	echo "echoValiable() is Called"
	echo -e "\033[0;36mcurrentPath ->\033[0;39m" $BASSPATH
	echo -e "\033[0;36mPLUGINDIR ->\033[0;39m" ${WORKPATH}
	echo -e "\033[0;36mmovePluginList ->\033[0;39m" ${movePluginList}
	echo -e "\033[0;36mmoveListPath ->\033[0;39m" $moveListPath
	echo -e "\033[0;36mUAD ->\033[0;39m" $UAD
	echo -e "\033[0;36musedUAD ->\033[0;39m" $usedUAD
	echo -e "\033[0;36munUsedUAD ->\033[0;39m" $unUsedUAD
}


# Load unused Plugin list and Assign it to array
function makePluginArray() {
	echo "makePluginArray() is Called"
	cd $GITHUBPATH

	NotAuthPLUGINLIST=(`cat ${PlugInsList[2]}`)
	NotAuth_len=${#NotAuthPLUGINLIST[@]}
	
}


function movePlugIns() {
	echo "findPlugin() is Called"
	cd $GITHUBPATH


	cd $WORKPATH
	cd $USEDPLUGIN
	cd $UAD

	i=0
	while [ $i -lt $NotAuth_len ] ; do
		tmp=$(eval echo "${NotAuthPLUGINLIST[$i]}")
		if [ ! -e "$tmp" ];then
			echo $tmp is not Exists.
		else
			mv $tmp $TARGETPATH
		fi
		echo -e "\033[0;32m$tmp -> \033[0;39m $TARGETPATH"
		(( i ++ ))
	done
}


function main() {
	makeUADNotAuthDir
	makeAllList
	makeMoveList
	matchPlugin
	makePluginArray
	movePlugIns
	cntPlugin

	echo "All UAD Plugin was Clean UP Complete."
	return 0
}

main
