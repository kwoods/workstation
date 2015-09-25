#!/usr/bin/env bash
####################################################################
#
# Initial OSX System Bootstrap for New Development Workstation
# Tested on OSX 10.10.5
#
####################################################################

# bash -e <(curl -fsSL https://raw.githubusercontent.com/kwoods/workstation/master/bootstrap.sh)

####################################################################
# Install Xcode Command Line Tools
####################################################################
# https://github.com/timsutton/osx-vm-templates/blob/ce8df8a7468faa7c5312444ece1b977c1b2f77a4/scripts/xcode-cli-tools.sh
if hash gcc 2>/dev/null; then
  echo "*- Command Line Tools Confirmed"
else
  read -r -p "Install Xcode Command Line Tools? [y/N] " response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]
  then
    touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress;
    PROD=$(softwareupdate -l |
      grep "\*.*Command Line" |
      head -n 1 | awk -F"*" '{print $2}' |
      sed -e 's/^ *//' |
      tr -d '\n')
    softwareupdate -i "$PROD" -v;
  fi
fi

####################################################################
# Generate SSH Key / Copy to Github
####################################################################
read -r -p "Generate SSH Key & Add to GitHub? [y/N] " response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]
then
  echo "Enter GitHub email: "
  read email
  ssh-keygen -t rsa -b 4096 -C "$email"
  pbcopy < ~/.ssh/id_rsa.pub
  eval "$(ssh-agent -s)"
  ssh-add ~/.ssh/id_rsa
  read -p "Opening Browser to GitHub, press any key to continue"
  open "https://github.com/settings/ssh"
  read -p "Press any key to test connection to GitHub"
  ssh -T git@github.com
fi

####################################################################
# Clone Repo and run bundler
####################################################################
read -r -p "Sprout-Wrap? [y/N] " response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]
then
  cd /tmp
  git clone https://github.com/kwoods/sprout-wrap.git
  cd sprout-wrap
  sudo gem install bundler
  bundle
  caffeinate bundle exec soloist
fi

echo "Finished!"
echo $'\360\237\215\273'
