This directory contains the customizations for Firefox.  It consists of a user.js file with custom
values for Firefox settings, and a chrome directory with tweaks to the Firefox css files.  The
bulk of the code came from the https://github.com/Aris-t2/CustomCSSforFx project, and the dotfiles
contains a directory for each version of Firefox we use, with the Aris-t2 tweaks appropriate for
that version of Firefox.

Adding support for a new Firefox version
----------------------------------------

To add a new version of Firefox, do the following:

1. Clone or update git@github.com:aris-t2/CustomCssforFx.

2. Copy the `current` directory of the aris project into the dotfile's `chrome `directory, renaming
  it `fx###` so we know what version of Firefox it is for.

3. From the chrome directory, run `cp fx###/userChrome.css userChrome-fx###.css` to make a new
  userChrome.css file specific to the version of Firefox.  We'll modify this new file so we can see
  what changes we made to the original aris options.

4. Edit the new userChrome file and change all the `./` references to `./fx###`.

5. Create a `myUserChrome-fx###.css` file to hold customizations to the css so we don't have to 
  make any changes to the files in fx###.  This is where our color variables and other things will
  go.  The best way to start is to copy the myUserChrome file from the last version.

6. Edit `userChrome.css.sample` and add imports for the 2 new files, commenting out the ones from
  the previous version.

7. Commit the changes so far so we know what the `userChrome-fx###.css` file looked like out of the
  box.

8. Compare the `userChrome-fx###.css` file to the previous version that was in use.  Make the same
  changes to the new file.  To help identify specifica changes made in the future, any import that
  gets added or removed should have "SCS ENABLED" or "SCS DISABLED" in the comments.

  Make sure that all the icon colors are disabled - they are an OS specific thing, and need to be
  imported later.  Also note that `icons_black_icons.css` doesn't exist, and will need to be made
  by making a copy of `icons_white_icons.css`.

  Also note that when installing the new version, it will be necessary to edit the `userChrome.css`
  file manually one time to get the right versions.

Debugging style problems
------------------------

It may be helpful to view the elements of firefox.  To do this, do the following:

1. Press F12 to open the Page Inspector.

2. Press F1 to open settings.

3. Make sure "Enable Browser chrome and add-on debugging toolbox" and "Enable remote debugging" are
  checked.

4. Press ctrl-alt-shift-i to open the browser toolbox. Searching for text in the "html" can be an 
  easy way to find a component in the debugging toolbox, and the styles on the right can be used 
  to figure out where a color came from.  It may be necessary to force popups to stay open for 
  inspection, which can be done from the "customize tools" menu (the button with the three dots).
  Choose the "disable popup auto-hide" option.


