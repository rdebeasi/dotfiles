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
alias wondersass="sass --watch ./scss/:./css/ -t expanded --line-numbers"

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
}

gogo-ryan-theme() {
  pwd | sed "s/^/Current path: /"
  grunt stop
  cd ~/Projects/stat/branches/ryan-theme
  merge-from-theme
  open-project
}

gogo-ryan-theme-mk2() {
  pwd | sed "s/^/Current path: /"
  grunt stop
  cd ~/Projects/stat/branches/ryan-theme-mk2
  merge-from-theme
  open-project
}

gogo-theme() {
  pwd | sed "s/^/Current path: /"
  grunt stop
  cd ~/Projects/stat/branches/theme
  svn up
  grunt
  open-project
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

alias snr="svn revert * --depth infinity; svn revert ."
alias sni="svn propedit svn:ignore ."
# Remove all unversioned files. Leave ignored files alone.
# http://stackoverflow.com/a/10414599/925475
alias svn-cleanup="svn st | grep '^?' | awk '{print $2}' | xargs rm -rf"
# Add all unversioned files in the current directory and subdirectories.
# Props to https://github.com/hirozed
alias sna="svn status | grep "^\?" | awk '{print $2}' | xargs svn add"
