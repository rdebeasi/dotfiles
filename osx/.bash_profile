# Our vagrantfiles are in an unusual place
export VAGRANT_VAGRANTFILE=conf/vagrant/Vagrantfile
# Put custom scripts on the path
PATH=$PATH:$HOME/bin:/usr/local/bin/pear
export PATH

# Use nano for git commits and the like.
# Look, I don't actually like vi _or_ emacs and I'm not afraid to admit it. ;)
export VISUAL=nano
export EDITOR="$VISUAL"
# Variable for STAT's Git/SVN sync tool (syncupstream.sh)
export STAT_WP_GIT_ROOT=/Users/debeasi/Projects/stat/

# Application/utility shortcuts
alias pugdebug="python3 /Users/debeasi/Projects/pugdebug/app.py"
# SSH log utility - http://git.io/vcu0P
alias vagrant-tail="sshtail.sh vagrant@wp.stat.local /var/log/apache2/wp.stat.local.err ~/Library/Logs/ryan/wp.stat.log"
# https://github.com/syntra/small-cli
source /Users/debeasi/.syntra/small
# Project switch shortcuts

merge-from-theme() {
  # Empty return text logic: http://stackoverflow.com/a/565966/925475
  # Non-metadata changes logic: http://stackoverflow.com/a/12137501/925475
  # All changes logic: http://stackoverflow.com/a/2693536/925475

  # Check for any changes.
  if [[ $(svn status | grep [AMCDG]) ]]; then
    echo "There are uncommitted changes. Not merging from theme branch."
  else
    svn up
    svn merge ^/stat/branches/theme .
    # Check for non-metadata changes.
    if [[ $(svn diff --summarize | grep '^. ') ]]; then
      echo "Merged in changes from theme branch."
      svn commit -m "Merged in changes from theme branch."
    else
      echo "No changes since last merge from theme branch."
      svn revert .
    fi
  fi
}

open-project() {
  cd www/content/dist
  atom .
  grunt
  # This way, I can make sure there aren't any errant VMs running around wild.
  vagrant global-status
}

gogo() {
  if  [ -z "$1" ]; then
    echo "Please include the name of the branch."
  else
    pwd | sed "s/^/Current path: /"
    grunt stop
    cd ~/Projects/stat/branches/$1
    merge-from-theme
    open-project
  fi
}

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

# "svn revert all"
sra() {
  read -p "Revert all changes (y/n)?"
  	if [ $REPLY == "y" ]; then
      svn revert * --depth infinity; svn revert .
  	fi
}

alias sni="svn propedit svn:ignore ."
# svn remove all unversioned files. Leave ignored files alone.
# "svn remove unversioned"
# http://stackoverflow.com/a/10414599/925475
alias sru="svn st | grep '^?' | awk '{print $2}' | xargs rm -rf"
# Add all unversioned files in the current directory and subdirectories.
# "svn add unversioned"
# Props to https://github.com/hirozed
alias sau="svn status | grep "^\?" | awk '{print $2}' | xargs svn add"
# Remove all missing files
# "svn remove missing"
# http://stackoverflow.com/a/11203174/925475
alias srm="svn status | grep '^\!' | sed 's/! *//' | xargs -I% svn rm %"
