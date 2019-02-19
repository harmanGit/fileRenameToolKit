#!/bin/bash

#@author Harman Dhillon

#global final variable
declare -r SCRIPTNAME="fileRenameToolKit.sh"
declare -r CURRENTFILEPATH=$(readlink -m "$SCRIPTNAME")
declare -r CURRENTDIRECTORY=$(pwd)

renameFileInFolder(){ #set this up this to use a path

  read -p "Enter the first few letters of the file or folder: " oldFileName
  read -p "Enter new file name: " newFileName
  read -p "Append date at the end of file name ( y/n ): " requireData
  read -p "Place files in a new folder ( y/n ): " newFolder

  local fileCounter=1
  local currentDate=""

  #$requireData = "$requireData" | awk '{print tolower($0)}' #BUG
  if [[ "$requireData" == "y" || "$requireData" == "Y" ]];
    then
      currentDate=`date +%Y-%m-%d`
   fi
   
   if [[ "$newFolder" == "y" || "$newFolder" == "Y" ]];
	then
		echo $CURRENTDIRECTORY
		local newFileNameTemp="$newFileName$currentDate--$fileCounter"
		mv $file "$newFileNameTemp"
		mkdir  "$newFileName"
		#mv "$newFileNameTemp" "$newFileName"
		#(fileCounter++))
		#else
		#mv $file "$newFileName$currentDate--$fileCounter"
		#((fileCounter++))
	fi
	
	echo "old code"

  for file in $(find . -name "$oldFileName*")
    do
      if [[ "$file" != *$SCRIPTNAME* ]]; #not renaming this file itself
      then
            local newFileNameTemp="$newFileName$currentDate--$fileCounter"
		mv $file "$newFileNameTemp"
            ((fileCounter++))
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
  echo "  1. Rename all files/folders." #BUG fix this, allow picking of one
  echo "  2. Find folder and rename files inside it."
  echo "  4. Cancel." #BUG fix this
}

program(){
  userMenu

  read -p "Selection: " userOption

  case "$userOption" in
  "1")
      renameFileInFolder
      ;;
  2)
      fileLocationBasedOfName
      ;;
  3)
      echo "This feature doesn't yet exist"
      ;;
  4)
      echo "This feature doesn't yet exist"
      ;;
  5)
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
