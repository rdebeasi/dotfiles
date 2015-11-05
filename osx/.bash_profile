# Our vagrantfiles are in an unusual place
export VAGRANT_VAGRANTFILE=conf/vagrant/Vagrantfile
# Put custom scripts on the path
PATH=$PATH:$HOME/bin
export PATH

# Application/utility shortcuts
alias pugdebug="python3 /Users/debeasi/Projects/pugdebug/app.py"
# SSH log utility - http://git.io/vcu0P
alias vagrant-tail="sshtail.sh vagrant@wp.stat.local /var/log/apache2/wp.stat.local.err ~/logs/wp.stat.log"
# Compile SASS in the style that wondersauce uses
alias wondersass="sass --watch ./scss/style.scss:./css/style.css -t expanded --line-numbers"

# Version control shortcuts
snl() {
  svn log $1 | less
}
snc() {
  if  [ -z "$1" ]; then
    svn commit
  else
    svn commit -m "$1"
  fi
}

# Use a visual merge tool for diffs. I'm not configuring svn do this because
# sometimes I actually do want to generate text-based diffs.
snd() {
  svn diff "$@" --diff-cmd=meld
}

alias snr="svn revert * --depth infinity; svn revert ."
alias sni="svn propedit svn:ignore ."
# Remove all unversioned files. Leave ignored files alone.
# Modified version of: http://stackoverflow.com/a/9144984/925475
alias svn-cleanup="svn status | grep '^[I?]' | cut -c 9- | while IFS= read -r f; do rm -rf "$f"; done"
# Add all unversioned files in the current directory and subdirectories.
# Props to https://github.com/hirozed
alias sna="svn status | grep "^\?" | awk '{print $2}' | xargs svn add"
