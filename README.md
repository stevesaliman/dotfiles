TODO:
-----

1. Move functions to .bash_functions
2. add mechanism to source .bash_localhost, which has things like JAVA_HOME
   We'll need a pre-bashrc and post-bashrc variant.  This is because JAVA_HOME
   needs to be set before bashrc runs, and additions to the path need to
   happen after.
3. Add mechanism to source .bash_aliases.