# Our vagrantfiles are in an unusual place
export VAGRANT_VAGRANTFILE=conf/vagrant/Vagrantfile
# Put custom scripts on the path
PATH=$PATH:$HOME/bin
export PATH
# Shortcuts for getting to commonly used directories
# alias go-theme="cd /Users/debeasi/Projects/stat/branches/ryan/www/content/dist/themes/stat-splash"

# Application/utility shortcuts
alias pugdebug="python3 /Users/debeasi/Projects/pugdebug/app.py"
# SSH log utility - http://git.io/vcu0P
alias vagrant-tail="sshtail.sh vagrant@wp.stat.local /var/log/apache2/wp.stat.local.err ~/logs/wp.stat.log"

# Version control shortcuts
snl() {
  svn log $1 | less
}
snc() {
  svn commit -m "$1"
}
alias snr="svn revert * --depth infinity; svn revert ."
alias sni="svn propedit svn:ignore ."


# Do we really need these?
# alias sns="svn stat"
# alias snd="svn diff"
# alias snu="svn up"
