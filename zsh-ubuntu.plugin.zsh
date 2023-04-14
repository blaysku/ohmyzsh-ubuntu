(( $+commands[apt] )) && APT=apt || APT=apt-get

alias upgrade="sudo $APT update -y && sudo $APT upgrade -y && sudo snap refresh && sudo $APT autoclean -f && sudo $APT autoremove -f"
alias scr="scrcpy --disable-screensaver --turn-screen-off --stay-awake"
alias disable_keyboard="xinput float $(xinput list --id-only 'AT Translated Set 2 keyboard')"
alias enable_keyboard="xinput reattach $(xinput list --id-only 'AT Translated Set 2 keyboard') 3"

# Prints apt history
# Usage:
#   apt-history install
#   apt-history upgrade
#   apt-history remove
#   apt-history rollback
#   apt-history list
# Based On: https://linuxcommando.blogspot.com/2008/08/how-to-show-apt-log-history.html
function apt-history() {
  case "$1" in
    install)
      zgrep --no-filename 'install ' $(ls -rt /var/log/dpkg*)
      ;;
    upgrade|remove)
      zgrep --no-filename $1 $(ls -rt /var/log/dpkg*)
      ;;
    rollback)
      zgrep --no-filename upgrade $(ls -rt /var/log/dpkg*) | \
        grep "$2" -A10000000 | \
        grep "$3" -B10000000 | \
        awk '{print $4"="$5}'
      ;;
    list)
      zgrep --no-filename '' $(ls -rt /var/log/dpkg*)
      ;;
    *)
      echo "Parameters:"
      echo " install - Lists all packages that have been installed."
      echo " upgrade - Lists all packages that have been upgraded."
      echo " remove - Lists all packages that have been removed."
      echo " rollback - Lists rollback information."
      echo " list - Lists all contains of dpkg logs."
      ;;
  esac
}

# List packages by size
function apt-list-packages {
  dpkg-query -W --showformat='${Installed-Size} ${Package} ${Status}\n' | \
  grep -v deinstall | \
  sort -n | \
  awk '{print $1" "$2}'
}
