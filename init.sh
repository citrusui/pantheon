#!/usr/bin/env bash

function checkTools() {
  if [ ! "$(which git)" ]; then
    echo "Git is required." # TODO: install these automatically
    echo "Please install them from your package manager."
    echo "If you are on macOS, run xcode-select --install."
    sleep 5;
    exit 1;
  fi
}

function pullSource() {
  rsync --exclude ".git" --exclude ".travis.yml" --exclude "*.md" --exclude "*.sh" -avh --no-perms . ~; # TODO: suppress output with -s and report if files were untouched
  if [ "$(lsb_release -si 2>&1)" == "elementary" ] || [ "$1" == "--force" ]; then
    ~/.pantheon
  fi
}

checkTools

cd "$(dirname "${BASH_SOURCE}")";
echo -e "\nPulling updates...\n"
git pull origin master;
if [ "$1" == "-y" ]; then
  pullSource
elif [ "$1" == "--force" ]; then
  echo -e "\n\033[1;31mWARNING: Running script with --force.\033[0m\n"
  sleep 5
  pullSource --force
else
  echo ""
  read -p "This may overwrite your existing preferences. Continue? [y/N] " REPLY
  echo ""
  if [[ "$REPLY" =~ ^([yY][eE][sS]|[yY])+$ ]]; then
    pullSource
  else
    echo "Aborted."
  fi
fi
