#!/bin/bash
# Step 1: verify existence of local_values file
# step 2: rsync
# step 3: sed on .gitconfig
# step 4: chmod on .ssh
# Another way to do this is to use rsync -av
# rsync -av files/ ~
# chmod 700 ~/.ssh
# Then find a way to do template substitutions, such as with SED
# 
# NOTE: OSX doesn't have an ANSI compliant sed, so you'll need install gsed
# from macports, and make a link to it in the path before proceding.

# Step 1. source the local overrides.  This must define a couple of values, 
# others are optional.
df_source_dir=$( cd "$( dirname "$0" )" && pwd )
if [ ! -f $df_source_dir/local_env ]; then
    echo "Error: Can't find the local_env file."
    exit 1
fi

. $df_source_dir/local_env
. $df_source_dir/install_functions

echo -e "Installing to $df_home_dir - THIS IS DESCRUCTIVE!  Are you sure?"
read answer
if [ $answer != 'y' ]; then
  exit
fi

echo "rsync -av ${df_source_dir}/gui/ $df_home_dir"
rsync -av "${df_source_dir}/gui/" "$df_home_dir"
