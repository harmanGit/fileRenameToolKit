#!/bin/bash

#@author Harman Dhillon

#global final variable
declare -r SCRIPTNAME="fileRenameToolKit.sh"
declare -r CURRENTFILEPATH=$(readlink -m "$SCRIPTNAME")
declare -r CURRENTDIRECTORY=$(pwd)

fileCounter=1
currentDate=""
oldFileName=""
newFileName=""
requireNewFolder=false

userInput(){
  read -p "Enter a few common letters in the $1 to be renamed: " oldFileNameTemp
  read -p "Enter new name for the $1: " newFileNameTemp
  read -p "Auto append date at the end ( y/n ): " requireDate
  read -p "Place $1s in a new folder ( y/n ): " requireNewFolderTemp

  oldFileName="$oldFileNameTemp"
  newFileName="$newFileNameTemp"
  
  if [[ "$requireDate" == "y" || "$requireDate" == "Y" ]]; then
      currentDate=`date +%Y-%m-%d`
  fi

  if [[ "$requireNewFolderTemp" == "y" || "$requireNewFolderTemp" == "Y" ]]; then
      requireNewFolder=true
      mkdir "$newFileName"
  fi
}

renamer(){
	local newFileNameTemp="$newFileName$currentDate--$fileCounter"

	if $requireNewFolder ; then
		mv $1 "$newFileNameTemp"
		mv "$newFileNameTemp" "$newFileName"
		((fileCounter++))
	else
		mv $1 "$newFileNameTemp"
		((fileCounter++))
	fi
}

renameFiles(){
userInput "file"

  for file in $(find . -name "$oldFileName*")
    do
	#not renaming this file itself
      if [[ "$file" != *$SCRIPTNAME* && -f "$file" ]]; then
	renamer "$file"
      fi
  done
}

renameFolders(){
userInput "folder"

for file in $(find . -name "$oldFileName*")
    do
      if [[ -d "$file" ]]; then
	renamer "$file"
      fi
  done
}

fileLocation(){

  echo "Enter path of the folder: "
  echo "Enter here if the location is the current directory"
  
  find -name "*c*" -type d
  read -p "   Choice: " folderPath
}

fileLocationBasedOfName(){
  read -p "	Enter folder name: " folderName
  local filePath=$(find -name "*$folderName*" -type d)
  echo "Is this the correct file path $filePath"
  read -p "( y/n ): " userResponse
  if [[ "$userResponse" == "y" || "$userResponse" == "Y" ]]
    then
        find -name "*$folderName*" -type d
   fi

}

userMenu(){
  echo "Select A Number Below."
  echo "  1. Rename files."
  echo "  2. Rename folders."
  echo "  3. Find folder and rename files inside it."
  echo "  4. Cancel." #BUG fix this
}

program(){
  userMenu

  read -p "Selection: " userOption

  case "$userOption" in
  1)
      renameFiles
      ;;
  2)
      renameFolders
      ;;
  3)
      echo "NOT COMPLETE YET, Pick again..."
      ;;
  4)
      echo "Exiting Skynet Compute Host [UPDATE BLOCKCHAIN LEDGER] ..."
      ;;
  *)
      echo "Invalid Choice, Pick again..."
      program
      ;;
  esac
}

#program starts Here
program
