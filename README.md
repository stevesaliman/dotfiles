This project has submodules.  This means that the first time you clone the 
project, you'll need to run

```
git submodule init
git submodule update
```

Then, to update the plugins at anytime, just do:

```
git submodule foreach git pull origin master
```

You still need to add/generate ssh keys.  I'm not checking those in a public 
repo.

TODO:
-----

1. Move functions to .bash_functions
2. add mechanism to source .bash_localhost, which has things like JAVA_HOME
   We'll need a pre-bashrc and post-bashrc variant.  This is because JAVA_HOME
   needs to be set before bashrc runs, and additions to the path need to
   happen after.
3. Add mechanism to source .bash_aliases.


order:
1. .bash_vars - defaults
1. .bashrc_local - local overrides of vars and other host spicific
1. .bashrc - does heavy lifting
1. .bash_aliases aliases, should set some conditionally.
1. .bash_functions
