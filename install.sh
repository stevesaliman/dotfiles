#!/bin/bash
# Step 1: verify existence of local_values file
# step 2: rsync
# step 3: sed on .gitconfig
# step 4: chmod on .ssh
# Another way to do this is to use rsync -av
# rsync -av files/ ~
# chmod 700 ~/.ssh
# Then find a way to do template substitutions, such as with SED

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

echo -e "We're gonna destroy files in $home_dir Are you sure?"
read answer
if [ $answer != 'y' ]; then
  exit
fi

dotfile_dir=$( cd "$( dirname "$0" )" && pwd )
echo "rsync -av ${dotfile_dir}/files/ $home_dir"
rsync -av "${dotfile_dir}/files/" "$home_dir"
