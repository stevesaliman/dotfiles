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

verify_value "df_xterm_font" "$df_xterm_font"

echo -e "Installing to $df_home_dir - THIS IS DESCRUCTIVE!  Are you sure?"
read answer
if [ $answer != 'y' ]; then
  exit
fi

# We used to use .Xdefaults, now we use .Xresoruces.  Remove the old file before we sync.
rm $df_home_dir/.Xdefaults

echo "rsync -av ${df_source_dir}/gui/ $df_home_dir"
rsync -av "${df_source_dir}/gui/" "$df_home_dir"

# Cygwin requires .startxwinrc to be executable
chmod 755 $df_home_dir/.startxwinrc

# some files had tokens in them.  Replace the tokens.
sed -i "s/@xterm.font@/$df_xterm_font/" $df_home_dir/.Xresources
sed -i "s/@font.size@/$df_font_size/" $df_home_dir/.local/share/konsole/Green.profile
