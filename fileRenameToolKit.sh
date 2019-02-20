#!/bin/bash

#@author Harman Dhillon

#global final variable
declare -r SCRIPTNAME="fileRenameToolKit.sh"
declare -r CURRENTFILEPATH=$(readlink -m "$SCRIPTNAME")
declare -r CURRENTDIRECTORY=$(pwd)

fileCounter=1
currentDate=""
oldObjectName=""
newObjectName=""
requireNewFolder=false

userInput(){
  read -p "Enter a few common letters in the $1 to be renamed: " oldObjectNameTemp
  read -p "Enter new name for the $1s: " newObjectNameTemp
  read -p "Auto append date at the end ( y/n ): " requireDate
  read -p "Place $1s in a new folder ( y/n ): " requireNewFolderTemp

  oldObjectName="$oldObjectNameTemp"
  newObjectName="$newObjectNameTemp"

  if [[ "$requireDate" == "y" || "$requireDate" == "Y" ]]; then
      currentDate=`date +%Y-%m-%d`
  fi

  if [[ "$requireNewFolderTemp" == "y" || "$requireNewFolderTemp" == "Y" ]]; then
      requireNewFolder=true
      mkdir "$newObjectName"
  fi
}

renamer(){
	local newObjectNameTemp="$newObjectName$currentDate--$fileCounter"

	if $requireNewFolder ; then
		mv $1 "$newObjectNameTemp"
		mv "$newObjectNameTemp" "$newObjectName"
		((fileCounter++))
	else
		mv $1 "$newObjectNameTemp"
		((fileCounter++))
	fi
}

renameFiles(){
  userInput "file"

  for file in $(find . -name "$oldObjectName*")
    do
	     #not renaming this file itself
      if [[ "$file" != *$SCRIPTNAME* && -f "$file" ]]; then
	       renamer "$file"
      fi
  done
}

renameFolders(){
  userInput "folder"

  for file in $(find . -name "$oldObjectName*")
      do
        if [[ -d "$file" ]]; then
	         renamer "$file"
         fi
  done
}

objectsNotRenamed(){
  if [[ $fileCounter -eq 1 ]];then
    echo ""
    echo "No files or folders renamed. Make sure the common letters match the"
    echo "files or folders names. Also make sure the $SCRIPTNAME script is in"
    echo "folder with your files or folders to be renamed, or use option 3"
    echo "and give a file path to your files and folders to renamed."
  fi
}

pathRenamer(){
  read -p "	Enter path to the folder where to rename files/folders: " filePath

  cp $SCRIPTNAME $filePath

  cd $filePath

  echo "Select A Number Below."
  echo "  1. Rename files."
  echo "  2. Rename folders."
  echo "  3. Cancel." #BUG fix this

  read -p "Selection: " userPathOption
  case "$userPathOption" in
  1)
      renameFiles
      objectsNotRenamed
      ;;
  2)
      renameFolders
      objectsNotRenamed
      ;;
  3)
      echo "Exiting Skynet Compute Host [UPDATE BLOCKCHAIN LEDGER] ..."
      ;;
  *)
      echo "Invalid Choice, Pick again..."
      program
      ;;
  esac

  rm $SCRIPTNAME
}

userMenu(){
  echo "Select A Number Below."
  echo "  1. Rename files."
  echo "  2. Rename folders."
  echo "  3. Rename files/folders in given file path."
  echo "  4. Cancel." #BUG fix this
}

program(){
  userMenu

  read -p "Selection: " userOption

  case "$userOption" in
  1)
      renameFiles
      objectsNotRenamed
      ;;
  2)
      renameFolders
      objectsNotRenamed
      ;;
  3)
      pathRenamer
      #objectsNotRenamed
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
