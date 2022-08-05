# This checks if the number of arguments is correct
# If the number of arguments is incorrect ( $# != 2) print error message and exit
if [[ $# != 2 ]]
then
  echo "backup.sh target_directory_name destination_directory_name"
  exit
fi

# This checks if argument 1 and argument 2 are valid directory paths
if [[ ! -d $1 ]] || [[ ! -d $2 ]]
then
  echo "Invalid directory path provided"
  exit
fi

# read the target and dest directories
targetDirectory=$1
destinationDirectory=$2

# Print the directories
echo "The target directory is: $1"
echo "The destination directory is: $2"

# initialize the current date in seconds
currentTS=`date +%s`

# initialize the backup file name
backupFileName="backup-[$currentTS].tar.gz"

# We're going to:
  # 1: Go into the target directory
  # 2: Create the backup file
  # 3: Move the backup file to the destination directory

# To make things easier, we will define some useful variables...

# read the present working directory
origAbsPath=`pwd`

# Navigate to the destination directory and read it
cd $destinationDirectory # <-
destDirAbsPath=`pwd`

# Navigate to the target directory
cd $origAbsPath # <-
cd $targetDirectory # <-

# compute the date range in seconds for new files to be backed up 
yesterdayTS=$(($currentTS - 24*60*60))

# Declare the backup array to store all files to be backed up
declare -a toBackup

for file in $(ls) # read files in the target directory
do
  # Check for the recent downloaded files (24 hours ago)
  if [ `date -r $file +%s` -gt $yesterdayTS ]
  then
    # assign files to an array to backup them all in once
    toBackup+=($file)
  fi
done

# archive the files within the backup array array
tar -czvf $backupFileName ${toBackup[@]}
# move backup file to the destination directory
mv $backupFileName $destDirAbsPath

