#!/bin/sh
if [ -f "$HOME/.ecryptfs/wrapped-passphrase" ];
then
  exit 0
else
  MOUNTPASS=`cat /dev/shm/.ecryptfs-$USER`
  if [ -f '/usr/bin/kdialog' ];
  then
    LOGINPASS=`kdialog --password "Please enter your password to finalize ecryptfs setup."`
  elif [ -f '/usr/bin/zenity' ];
  then
    zenity --info "You will be asked for your login password. This will finalize ecryptfs setup."
    LOGINPASS=`zenity --password`
  fi
  printf "%s\n%s" "$MOUNTPASS" "$LOGINPASS" | ecryptfs-wrap-passphrase "$HOME/.ecryptfs/wrapped-passphrase" -
  if [ $? != 0 ]; then
    if [ -f '/usr/bin/kdialog' ];
    then
      kdialog --error "Failed to setup ecryptfs. You won't be able to login after reboot."
    elif [ -f '/usr/bin/zenity' ];
    then
      zenity --info "Failed to setup ecryptfs. You won't be able to login after reboot."
      zenity --error
    fi
  fi
fi

