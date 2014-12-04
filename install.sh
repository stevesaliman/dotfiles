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

# define a function to check the existince of a property
function verify_value() {
    name="$1"
	value="$2"
	if [ -z "$value" ]; then
		echo "Missing value for $name. Is it in local_env?"
		exit 1
	fi
}

# Step 1. Set up defaults for some of our variables.  We assume we're installing
# to the current user's home directory. These defaults can be overridden in 
# the local_env file, if for example we want to set up a different user, or
# create a subdirectory in an application user's home to source my environment
# from elsewhere.
df_home_dir=$HOME
df_user=$USER
df_source_dir=$( cd "$( dirname "$0" )" && pwd )

# source the local overrides.  This must define a couple of values, others are 
# optional.
if [ ! -f $df_source_dir/local_env ]; then
    echo "Error: Can't find the local_env file."
    exit 1
fi

. $df_source_dir/local_env

verify_value "df_git_name" "$df_git_name"
verify_value "df_git_email" "$df_git_email"

echo -e "Installing to $df_home_dir - THIS IS DESCRUCTIVE!  Are you sure?"
read answer
if [ $answer != 'y' ]; then
  exit
fi

echo "rsync -av ${df_source_dir}/files/ $df_home_dir"
rsync -av "${df_source_dir}/files/" "$df_home_dir"

# some files had tokens in them.  Replace the tokens.
sed -i "s/@git.name@/$df_git_name/" $df_home_dir/.gitconfig
sed -i "s/@git.email@/$df_git_email/" $df_home_dir/.gitconfig

sed -i "s/@home.user@/$df_home_user/" $df_home_dir/.ssh/config
sed -i "s/@work.user@/$df_work_user/" $df_home_dir/.ssh/config
sed -i "s/@app.user@/$df_app_user/" $df_home_dir/.ssh/config
sed -i "s/@local.user@/$df_user/" $df_home_dir/.ssh/config

sed -i "s/@local.user@/$df_user/" $df_home_dir/.bash_vars
