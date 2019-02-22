#!/bin/bash

#@author Harman Dhillon

#global final variable
declare -r SCRIPTNAME="fileRenameToolKit.sh"
declare -r CURRENTFILEPATH=$(readlink -m "$SCRIPTNAME")
declare -r CURRENTDIRECTORY=$(pwd)

fileCounter=1 #is appened at the end of each renamed object (also incremented)
currentDate=""
oldObjectName=""
newObjectName=""
requireNewFolder=false

#Function gets user input related to how they want the objects renamed. This also takes
#one parameter, which is the a string representing what kind of object is being renamed.
#That parameter is used to output a menu to the user
renamingUserInput(){
  echo ""
  echo "Files and or Folder From This Directory"
  echo "----------------------------------------"
  #displaying files to make it easy pick common letters, and to check if its the right directory
  ls -1 

  echo ""
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
      mkdir "$newObjectName" #making the new directory
  fi
}

#Function renames the objects and or moves them depending on the requireNewFolder
#variable (true equals rename and move). This also takes one parameter, the file to be
#renamed.
renamer(){
	local newObjectNameTemp="$newObjectName$currentDate--$fileCounter"

	# Checking if folder to rename is empty or not. Can only rename empty files
	if [[ -d "$1" && "$(ls -A $1)" ]]; then
 	    echo "Can not rename $1, as it is not Empty. Renaming could cause issues objects nested inside."
	else
  	  if $requireNewFolder ; then
		mv $1 "$newObjectNameTemp"
		mv "$newObjectNameTemp" "$newObjectName"
		((fileCounter++))
	  else
		mv $1 "$newObjectNameTemp"
		((fileCounter++))
	  fi
	fi
}

#Function is used when a file is being renamed. This calls the renamingUserInput
#and also the renamer. 
renameFiles(){
  renamingUserInput "file"
  #looping through all files starting with the given oldObjectName
  for file in $(find . -name "$oldObjectName*")
    do
	     #not renaming this script itself
      if [[ "$file" != *$SCRIPTNAME* && -f "$file" ]]; then
	       renamer "$file"
      fi
  done

  if [[ $fileCounter -eq 1 && $requireNewFolder ]]; then #if new folder was created, now its being removed	
	$( rm -r $newObjectName )
  fi
}

#Function is used when a folder is being renamed. This calls the renamingUserInput
#and also the renamer. 
renameFolders(){
  renamingUserInput "folder"
  #looping through all files starting with the given oldObjectName
  for folder in $(find . -name "$oldObjectName*")
      do
        if [[ -d "$folder" ]]; then
	         renamer "$folder"
        fi
  done

  if [[ $fileCounter -eq 1 && $requireNewFolder ]]; then #if new folder was created, now its being removed	
	$( rm -r $newObjectName )
  fi
}
#Function is used to display an error message, if user attempt rename files
#but none were ever renamed. Error message attempts to explain what issue may be. 
objectsNotRenamed(){
  if [[ $fileCounter -eq 1 ]];then
    echo ""
    echo "No files or folders renamed. Make sure the common letters match the"
    echo "files or folders names. Also make sure the $SCRIPTNAME script is in"
    echo "folder with your files or folders to be renamed, or use option 3"
    echo "and give a file path to your files and folders to renamed."
  fi
}

#Function used to get the file path to the files that need to be renamed.
#Also does a change directory based of the file path. Calls the userMenu
pathRenamer(){
  read -p "  Enter path to the folder where to rename files/folders: " filePath

  cd $filePath #check if its a valid directory

  if [[ -d "$filePath" ]]; then
   userMenu false
 else
   return
 fi
}

#Function is the main user menu for the user. Displays the appropriate
#menu based of what the user has selected. One parameter, used to check
#if the user has already selected the rename files/folders in given file
#path option. This function calls renameFiles, objectsNotRenamed, 
#renameFolders, and pathRenamer.
userMenu(){
echo "Select A Number Below."
echo "  1. Rename files."
echo "  2. Rename folders."

  if $1 ;then
    echo "  3. Rename files/folders in given file path."
    echo "  4. Cancel."
    read -p "Selection: " userOption
  else
    echo "  3. Cancel."
    read -p "Selection: " userOption

    if [[ $userOption -eq 3 ]] ;then
      userOption=4
    fi
  fi

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
      ;;
  4)
      return;
      ;;
  *)
      echo "Invalid Choice, Pick again..."
      program
      ;;
  esac
}

#starts the main script
program(){
  userMenu true
}

program
