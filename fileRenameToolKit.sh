#!/bin/bash

#@author Harman Dhillon

#global final variable
declare -r SCRIPTNAME="fileRenameToolKit.sh"
declare -r CURRENTFILEPATH=find . -name $SCRIPTNAME #BUG

echo "$CURRENTFILEPATH"

renameFileInFolder(){ #set this up this to use a path

  read -p "Enter the first few letters of the file or file extension to be rename: " oldFileName
  read -p "Enter new file name: " newFileName
  read -p "Append date at the end of file name ( y/n ): " requireData

  local fileCounter=1
  local currentDate=""

  #$requireData = "$requireData" | awk '{print tolower($0)}' #BUG
  if [[ "$requireData" == "y" || "$requireData" == "Y" ]]
    then
      currentDate=`date +%Y-%m-%d`
   fi

  for file in $(find . -name "$oldFileName*") #BUG maybe use the string that contains instead of starting chars
    do
      if [[ "$file" != *$SCRIPTNAME* ]]; #not renaming this file itself
      then
            mv $file "$newFileName$currentDate--$fileCounter"
            ((fileCounter++))
      fi
  done
}

fileLocation(){

  echo "Enter path of the folder: "
  echo "Enter here if the location is the current directory"
  read -p "   Choice: " folderPath
}

userMenu(){
  echo "Select A Number Below."
  echo "  1. Rename all files in current folder."
  echo "  2. Rename all files in another folder."
  echo "  3. Rename all files from a folder and place in another folder."
  echo "  4. Find folder and rename files inside it."
  echo "  5. Cancel." #BUG fix this
}

program(){
  userMenu

  read -p "Selection: " userOption

  case "$userOption" in
  "1")
      renameFileInFolder
      ;;
  2)
      echo "This feature doesn't yet exist"
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
