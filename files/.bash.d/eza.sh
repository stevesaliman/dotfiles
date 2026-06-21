# Configuration fragment for eza

# Set the extended colors for exa per at https://the.exa.website/docs/colour-themes
export EXA_COLORS=$LS_COLORS
# Set the "user" permission bits to the terminal color
export EXA_COLORS="${EXA_COLORS}ur=0:uw=0:ux=0:ue=0:"
# Set the "group" permission bits to yellow
export EXA_COLORS="${EXA_COLORS}gr=33:gw=33:gx=33:"
# Set the "other" permission bits to bold versions of the terminal color
export EXA_COLORS="${EXA_COLORS}tr=1;0:tw=1;0:tx=1;0:"
# Set the setuid and setgid colors
export EXA_COLORS="${EXA_COLORS}sf=30;43:"
# Set the user and group colors.  Yellow for me and my groups, bold yellow otherwise.
export EXA_COLORS="${EXA_COLORS}uu=33:un=1;33:gu=33:gn=1;33:"
# Set the file size colors to normal terminal color
export EXA_COLORS="${EXA_COLORS}sn=0:sb=0:"
# Dates are bold blue.
export EXA_COLORS="${EXA_COLORS}da=1;34:"

if [ $os_type == Linux -a -f "$HOME/.cargo/bin/eza" ]; then
    alias dir='eza -laF --group --git'       
    alias lstr='eza -laF --group --git --sort=mod'
elif [ $os_type == Darwin -a -f "$(brew --prefix)/bin/eza" ]; then
    alias dir='eza -laF --group --git'       
    alias lstr='eza -laF --group --git --sort=mod'
fi

