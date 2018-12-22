#!/bin/sh

# First things first: are we root?
if [ "${USER}" != "root" ]; then
  echo -e "Error: The deploy script needs to be run as root"
  exit 1
fi

# Default backup type
backup_type="full"

#----------------------------------------------------------------------------
# Function to print usage.  It takes one argument; the error message to display
# before the usage text.
usage() {
	local message=$1
    echo "${message}"
    echo ""
    echo "Usage: backup.sh [-d base_dir] [-t type] [-u user]"
    echo "Options:"
    echo "  -d <base_dir>: The base directory for backups.  The actual backup will"
	echo "                 will be in a subdirectory of this base directory, based"
	echo "                 on the hostname and backup type.  Defaults to the value of"
	echo "                 the 'BACKUP_HOME' variable."
	echo "  -t <type>: The type of backup.  Valid values are 'full' and 'file'."
	echo "             A 'full' backup backs up all files.  A 'file' backup backs"
	echo "             up known directories with working files, like Documents and"
	echo "             projects, to a time-stamped directory."
    echo "  -u <user>: The name of the primary user on the machine.  This is theuser"
	echo "             who owns the backup exclusion file, and the user whose files "
	echo "             we back up in 'file' mode. Defaults to '@local.user@'"
    exit 1
}

#-----------------------------------------------------------------------------
# Function to validate arguments.  It makes sure we're dealing with a known
# type, and that tll the directories we need exist.  This function will set two
# global variagles for other methods to use:
# BACKUP_DIR will be the destination directory for our backups.
# USER_HOME will be the user's home directory.
process_args() {
	local backup_type=$1
	local backup_user=$2
	local backup_base=$3

	# Were we given a base directory?
	if [[ -z "$backup_base" ]]; then
		usage "No base backup directory.  You muse either define BACKUP_HOME or specify a -d arg!"
	fi

	# Make sure we have a valid backup type.
	case "$backup_type" in 
	  full)
		BACKUP_DIR="${backup_base}/${HOSTNAME%%.*}/full"
	    ;;
	  file)
		BACKUP_DIR="${backup_base}/${HOSTNAME%%.*}/file"
	    ;;
	  \?) #Unrecognized option
	    usage "Unknown backup type: $backup_type"
	    ;;
    esac

	# is the user good? "~" doesn't work inside a script, and we don't want to
	# user eval, so figure out the path the hard way.
	local os_type=$(uname)
	if [[ $os_type == Linux ]]; then
		USER_HOME="/home/${backup_user}"
	elif [[ $os_type == CYGWIN* ]]; then
		USER_HOME="/home/${backup_user}"
	elif [[ $os_type == Darwin ]]; then
		USER_HOME="/Users/${backup_user}"
	fi
	if [ ! -d "${USER_HOME}" ]; then
		usage "Backup user ${backup_user}'s home directory does not exist!"
	fi

	# if the drive is not mounted, exit
	if [ ! -d "$backup_base" ]; then
		usage "Backup drive ${backup_base} not mounted!"
	fi

	mkdir -p "${BACKUP_DIR}"
	chown ${backup_user} "${BACKUP_DIR}"
}

#-----------------------------------------------------------------------------
# Function to perform a full backup.  It takes 1 arguments: name of the user 
# that uses the machine.  It also depends on the global BACKUP_DIR variable
# being set.
full_backup() {
	local backup_user=$1
	local exclude_file="${USER_HOME}/.backup_full_excludes"
	echo "Performing a full backup to $BACKUP_DIR for user $backup_user"
	rsync -avi --delete --exclude-from="${exclude_file}" / "${BACKUP_DIR}" | grep -v \.[fd]\/\/\/pog\.\.\.
}

#-----------------------------------------------------------------------------
# Function to perform backup of certain directories.  This is meant for 
# directories that change frequently, where we might want to keep multiple 
# versions of a file, such as project directories or document directories.
# The fastest way to do this is to keep a staging directory with the most 
# recent backup, use rsync to bring that directory current by only copying
# changed files, then making a tar of that directory.
file_backup() {
	local backup_user=$1
	local exclude_file="${USER_HOME}/.backup_file_excludes"
	echo "Performing a file backup to $BACKUP_DIR for user $backup_user"
	local dt=$(date +%Y-%m-%d_%H-%M)

	# This code gets a lot easier if we are in the directory of interest.  It
	# means the find command will always return files with just 2 characters 
	# (./) before the filename.
	pushd ${BACKUP_DIR}

    # Let's clean up anything older than 30 days - but only the tgz files.
	local max_age=30
	local oldfiles=$(find . -mindepth 1 -maxdepth 1 -mtime +${max_age} | grep tgz)
	for f in ${oldfiles}; do
		# Trim off the leading ./
		to_nuke=${f:2}
		echo "Removing ${to_nuke}"
		rm "${to_nuke}"
	done
	popd


	local subdir_list=("projects" "Documents")
	for subdir in ${subdir_list[@]}; do
		local src_dir="${USER_HOME}/${subdir}"
		local dest_dir="${BACKUP_DIR}/${subdir}"
		local dest_file="${BACKUP_DIR}/${subdir}-${dt}.tgz"
		mkdir -p "$dest_dir"
		chown ${backup_user} "$dest_dir"
		# Need the trailing slash on src to get contents without the src dir 
		# itself.
	    rsync -avi --delete --exclude-from="${exclude_file}" "${src_dir}/" "${dest_dir}" | grep -v \.[fd]\/\/\/pog\.\.\.
		# Use -C to change the directory so our files will be relative.
		tar -C "${BACKUP_DIR}" -czpf "${dest_file}" "${subdir}"
		chown ${backup_user} "${dest_file}"
	done
}

#-----------------------------------------------------------------------------
# main part of code
while getopts :d:t:u: opt; do
  case $opt in 
  d)
    backup_base=$OPTARG
    ;;
  t)
	backup_type=$OPTARG
	;;
  u)
    backup_user=$OPTARG
    ;;
  \?) #Unrecognized option
    usage "Unknown option: $opt"
    ;;
  esac
done


process_args $backup_type $backup_user $backup_base
if [[ -z "$BACKUP_DIR" ]]; then
	echo "Somehow, the backup directory was not set when processing args!"
	exit 1
fi
if [[ -z "$USER_HOME" ]]; then
	echo "Somehow, the user home directory was not set when processing args!"
	exit 1
fi
	
echo "Backup started: $(date)"
backup_func="${backup_type}_backup"
$backup_func $backup_user
echo "Backup finished: $(date)"
