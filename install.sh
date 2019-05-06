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

verify_value "df_git_name" "$df_git_name"
verify_value "df_git_email" "$df_git_email"
verify_value "df_env_label" "$df_env_label"

force_deploy="N"
while getopts :f flag; do
	case $flag in 
	f)
		force_deploy="Y"
		;;
	\?)
		echo -e "Unknown option $flag"
		echo -e ""
		echo -e "Usage: install.sh [-f]"
		echo -e "Options:"
		echo -e "  -f: Force deployment. This options dupresses the 'are you sure' question"
		exit 1
		;;
	esac
done

if [ "$force_deploy" == "N" ]; then
	echo -e "Installing to $df_home_dir - THIS IS DESCRUCTIVE!  Are you sure?"
	read answer
	if [ $answer != 'y' ]; then
	  exit
	fi
fi

echo "rsync -av ${df_source_dir}/files/ $df_home_dir"
rsync -av "${df_source_dir}/files/" "$df_home_dir"

# Cygwin requires .startxwinrc to be executable
chmod 755 $df_home_dir/.startxwinrc

# some files had tokens in them.  Replace the tokens.
sed -i "s/@git.name@/$df_git_name/" $df_home_dir/.gitconfig
sed -i "s/@git.email@/$df_git_email/" $df_home_dir/.gitconfig

sed -i "s/@home.user@/$df_home_user/" $df_home_dir/.ssh/config
sed -i "s/@work.user@/$df_work_user/" $df_home_dir/.ssh/config
sed -i "s/@app.user@/$df_app_user/" $df_home_dir/.ssh/config
sed -i "s/@local.user@/$df_user/" $df_home_dir/.ssh/config

sed -i "s/@local.user@/$df_user/" $df_home_dir/.bash_vars
sed -i "s/@env.label@/$df_env_label/" $df_home_dir/.bash_vars

sed -i "s/@xterm.font@/$df_xterm_font/" $df_home_dir/.Xdefaults

sed -i "s/@local.user@/$df_user/" $df_home_dir/bin/backup.sh
