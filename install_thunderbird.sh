#!/bin/bash
# Install thunderbird customizations to the thunderbird profile directory.
#
# NOTE: OSX doesn't have an ANSI compliant sed, so you'll need install gsed
# from macports, and make a link to it in the path before proceding.

# This script requires the profile directory as an argument.
if [ $# -lt 1 ]; then
    echo "Usage: install_thunderbird.sh <profile_dir>"
    exit 1
fi

profile_dir=$1
# Does the profile directory exist?
if [ ! -d "$profile_dir" ]; then
    echo "Thunderbird profile $profile_dir does not exist!"
    exit 1
fi

# Step 1. source the local overrides.  This must define a couple of values, 
# others are optional.
df_source_dir=$( cd "$( dirname "$0" )" && pwd )
if [ ! -f $df_source_dir/local_env ]; then
    echo "Error: Can't find the local_env file."
    exit 1
fi

. $df_source_dir/local_env
. $df_source_dir/install_functions

echo -e "Installing to $profile_dir - THIS IS DESCRUCTIVE!  Are you sure?"
read answer
if [ $answer != 'y' ]; then
  exit
fi


# This script adds to the thunderbird profile directory, but it strictly manages
# the chrome directory, so start by clearing out the chrome directory.
mkdir -p "${profile_dir}/chrome"
rm -r "${profile_dir}/chrome"
echo "rsync -av ${df_source_dir}/thunderbird/ $profile_dir"
rsync -av "${df_source_dir}/thunderbird/" "$profile_dir"
