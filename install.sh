#!/bin/bash
# Step 1: verify existence of local_values file
# step 2: rsync
# step 3: sed on .gitconfig
# step 4: chmod on .ssh
# Another way to do this is to use rsync -av
# rsync -av files/ ~
# chmod 700 ~/.ssh
# Then find a way to do template substitutions, such as with SED

# define a function to check the existince of a property
function verify_value() {
    name="$1"
	value="$2"
	if [ -z "$value" ]; then
		echo "Missing value for $name. Is it in local_env?"
		exit 1
	fi
}

# Defaults
# Find out install dir, default to $HOME
home_dir=$HOME

if [[ $# > 0 ]]; then
  home_dir=$1
fi

# find out install user, default to $USER This is the user for determining the 
# custom prompt.
dotfile_user=$USER

# Find out where to backup, default to $install_dir/dotfiles_bak
backup_dir=$home_dir/.dotfiles.bak

# Make sure we've got values for all the tokens we need
dotfile_dir=$( cd "$( dirname "$0" )" && pwd )
if [ ! -f $dotfile_dir/local_env ]; then
    echo "Error: No local_env file."
    exit 1
fi

. $dotfile_dir/local_env

verify_value "df_git_name" "$df_git_name"
verify_value "df_git_email" "$df_git_email"

echo -e "We're gonna destroy files in $home_dir Are you sure?"
read answer
if [ $answer != 'y' ]; then
  exit
fi

echo "rsync -av ${dotfile_dir}/files/ $home_dir"
rsync -av "${dotfile_dir}/files/" "$home_dir"

sed -i "s/@git.name@/$df_git_name/" $home_dir/.gitconfig
sed -i "s/@git.email@/$df_git_email/" $home_dir/.gitconfig
