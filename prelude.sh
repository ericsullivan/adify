#!/usr/bin/env bash

#############
### USAGE ###
#############
# From the terminal:
# $ bash <(wget -qO- https://raw.githubusercontent.com/aditya7iyengar/adify/master/prelude.sh)
# OR
# $ bash <(curl -s https://raw.githubusercontent.com/aditya7iyengar/adify/master/prelude.sh)


####################
### SUPPORTED OS ###
####################
# This Script is setup to run only on the following OS (Kernels):
# - Arch Linux (Manjaro, Antergos, Anacrchy)
# - Mac OS
# - Ubuntu
# - PopOS
# - Debian

####################
### REQUIREMENTS ###
####################
# - Internet Connection
# - Unzip
# - Wget/Curl
# - Sudo
# - Git
# - One of the Supported OS(s)
# - Admin Privileges of the computer being adified

###############
### PRELUDE ###
###############
# Detects Shell Type
# Detects Kernel and previous adification

################
### VERSIONS ###
################
# To override run command with: `$ VSN=develop ./prelude.sh`
ADIFY_VERSION=${VSN-"0.2.0"}
ELIXIR_VERSION="1.10.4"
ERLANG_VERSION="23.0.2"
ASDF_VERSION="0.7.8"

YELLOW='\033[0;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
BOLD=$(tput bold)
NORMAL=$(tput sgr0)

_announce_step() {
  echo -e """$BLUE
==========================================================
$1.......
==========================================================$NC"""
}

_announce_error(){
  echo -e """
$RED[\u2717] $1 $NC
  """
  exit 1
}

_announce_success() {
  echo -e """
$GREEN[\u2713] $1 $NC
  """
}

_announce_info() {
  echo -e """$BLUE
---> $1 $NC
  """
}

_get_confirmation() {
  echo -e """
$BOLD $1? (y/N)
  """
  if $noconfirm == true; then
    read confirmation
    if (($confirmation == "y") || ($confirmation == "Y")); then
      _announce_success "Got Yes"
    else
      _announce_error "Got No"
      exit 1
    fi
  else
    _announce_info "[NO_CONFIRM mode is on]"
  fi
}

check_os() {
  _announce_step "Detecting OS"

  kernel="`uname`"

  case $kernel in
    'Linux')
      check_linux
    ;;
    'Darwin')
      OS='osx'
      _announce_success "OS is $OS. Adify is supported for $OS"
    ;;
    *)
      _announce_error "Adify isn't supported for kernel, $kernel"
    ;;
  esac
}

check_linux() {
  OS="`cat /etc/os-release | grep ^NAME`"

  case $OS in
    *Arch*)
      OS='arch_linux'
      _announce_success "OS is $OS. Adify is supported for $OS"
    ;;
    *Antergos*)
      OS='arch_linux'
      _announce_success "OS is $OS. Adify is supported for $OS"
    ;;
    *Manjaro*)
      OS='arch_linux'
      _announce_success "OS is $OS. Adify is supported for $OS"
    ;;
    *Ubuntu*)
      OS='ubuntu'
      _announce_success "OS is $OS. Adify is supported for $OS"
    ;;
    *Debian*)
      OS='debian'
      _announce_success "OS is $OS. Adify is supported for $OS"
    ;;
    *Pop!_OS*)
      OS='pop_os'
      _announce_success "OS is $OS. Adify is supported for $OS"
    ;;
    *)
      _announce_error "Adify isn't supported for Linux OS: $OS"
    ;;
  esac
}

check_shell() {
  _announce_step "Detecting Shell Type"

  case $SHELL in
    *zsh)
      shell="zsh"
      zsh=true
      _announce_success "Detected shell: '$shell' is supported by Adify! "
    ;;
    *bash)
      shell="bash"
      _announce_info "Detected Shell: '$shell' isn't supported, but can be changed"
    ;;
  *)
      _announce_error "Shell: '$SHELL' not supported"
  esac

}

check_asdf() {
  _announce_step "Checking ASDF-VM"

  if [ -d "$HOME/.asdf" ]; then
    echo -e "\n. ${HOME}/.asdf/asdf.sh" >> ${HOME}/.${1}rc
    echo -e "\n. ${HOME}/.asdf/completions/asdf.bash" >> ${HOME}/.${1}rc
    . ${HOME}/.asdf/asdf.sh
    . ${HOME}/.asdf/completions/asdf.bash
    _announce_success "ASDF already installed"
    asdf=true
  else
    _announce_success "No ASDF Found"
    asdf=false
  fi
}

install_asdf() {
  _announce_step "Installing ASDF ${ASDF_VERSION}"
  git clone https://github.com/asdf-vm/asdf.git ${HOME}/.asdf --branch v${ASDF_VERSION}
  echo -e "\n. ${HOME}/.asdf/asdf.sh" >> ${HOME}/.${1}rc
  echo -e "\n. ${HOME}/.asdf/completions/asdf.bash" >> ${HOME}/.${1}rc
  . ${HOME}/.asdf/asdf.sh
  . ${HOME}/.asdf/completions/asdf.bash
  asdf=true
}

install_osx_tools() {
  _announce_step "Installing Tools require for OTP for Mac OS"

  _announce_info "Installing XCode and command line tools"
  xcode-select --install

  _announce_info "Installing Homebrew"
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

  _announce_info "Testing Homebrew installation"
  brew doctor

  _announce_info "Installing brew cask"
  brew cask

  if $zsh; then
    _announce_success "System already uses zsh"
    _announce_info "Making Zsh default Shell"
    chsh -s /bin/zsh
  else
    _announce_info "Installing Zsh Shell"
    brew_install_new zsh

    touch ~/.zshrc

    _announce_info "Making Zsh default Shell"
    chsh -s /bin/zsh
  fi

  _announce_info "Installing Zenity"
  brew_install_new zenity

  if [ $? -eq 0 ]; then
    _announce_info "Installing Git"
    brew_install_new git
  else
    _announce_error "Failed!"
  fi

  if [ $? -eq 0 ]; then
    _announce_info "Installing Wget"
    brew_install_new wget
  else
    _announce_error "Failed!"
  fi

  if [ $? -eq 0 ]; then
    _announce_info "Installing autoconf"
    brew_install_new autoconf
  else
    _announce_error "Failed!"
  fi

  if [ $? -eq 0 ]; then
    _announce_info "Installing wxmac for widgets"
    brew_install_new wxmac
  else
    _announce_error "Failed!"
  fi


  if [ $? -eq 0 ]; then
    _announce_info "Installing wxwidgets, ODBC, gnupg and gnuppg2"
    brew_install_new wxwidgets
    brew_install_new unixodbc
    brew_install_new gnupg gnupg2
  else
    _announce_error "Failed!"
  fi
}

brew_install_new() {
  if brew ls --versions $1 > /dev/null; then
    _announce_info "'$1' already installed"
  else
    brew install $1
  fi
}

install_arch_linux_tools() {
  _announce_step "Installing Tools required for OTP for Arch Linux"

  if $zsh; then
    _announce_success "System already uses zsh"
  else
    _announce_info "Installing Zsh Shell"
    sudo pacman -S --noconfirm zsh zsh-completions

    _announce_info "Making Zsh default Shell"
    sudo -s 'echo /usr/local/bin/zsh >> /etc/shells' && chsh -s /usr/local/bin/zsh
  fi

  _announce_info "Installing 'base-devel' for most of the OTP needed tools"

  sudo pacman -S --needed --noconfirm base-devel libxslt unzip

  if [ $? -eq 0 ]; then
    _announce_info "Installing 'curses' for terminal handling"
    sudo pacman -S ncurses --noconfirm
  else
    _announce_error "Failed!"
  fi

  if [ $? -eq 0 ]; then
    _announce_info "Installing 'zenity' for asking password"
    sudo pacman -S zenity --noconfirm
  else
    _announce_error "Failed!"
  fi

  if [ $? -eq 0 ]; then
    _announce_info "Installing 'glu', 'mesa', 'wxgtk2' and 'libpng' for For building with wxWidgets (start observer or debugger!)"
    sudo pacman -S glu mesa wxgtk2 libpng --noconfirm
  else
    _announce_error "Failed!"
  fi

  if [ $? -eq 0 ]; then
    _announce_info "Installing 'libssh' for building ssl"
    sudo pacman -S libssh --noconfirm
  else
    _announce_error "Failed!"
  fi

  if [ $? -eq 0 ]; then
    _announce_info "Installing 'unixodbc' for ODBC support"
    sudo pacman -S unixodbc --noconfirm
  else
    _announce_error "Failed!"
  fi

  if [ $? -eq 0 ]; then
    _announce_info "Installing 'fop' for docs building"
    sudo pacman -S fop --noconfirm
  else
    _announce_error "Failed!"
  fi

  if [ $? -eq 0 ]; then
    _announce_success "System is Ready for OTP"
  else
    _announce_error "Failed!"
  fi
}

install_debian_ubuntu_pop_os_tools() {
  _announce_info "Installing 'build-essential' for most of OTP tools"

  sudo apt-get -y update

  sudo apt-get -y install build-essential

  if $zsh; then
    _announce_success "System already uses zsh"
  else
    _announce_info "Installing Zsh Shell"
    sudo apt-get -y install zsh zsh-completions

    _announce_info "Making Zsh default Shell"
    sudo -s 'echo /usr/local/bin/zsh >> /etc/shells' && chsh -s /usr/local/bin/zsh
  fi

  if [ $? -eq 0 ]; then
    _announce_info "Installing other erlang dependencies"
    sudo apt-get -y install build-essential autoconf m4 libncurses5-dev libwxgtk3.0-gtk3-dev libgl1-mesa-dev libglu1-mesa-dev libpng-dev libssh-dev unixodbc-dev xsltproc fop libxml2-utils libncurses-dev openjdk-11-jdk
  else
    _announce_error "Failed!"
  fi
}

install_debian_tools(){
  _announce_step "Installing Tools required for OTP for Debian"
  install_debian_ubuntu_pop_os_tools
}

install_ubuntu_tools(){
  _announce_step "Installing Tools required for OTP for Ubuntu"
  install_debian_ubuntu_pop_os_tools
}

install_pop_os_tools() {
  _announce_step "Installing Tools required for OTP for Pop!_OS"
  install_debian_ubuntu_pop_os_tools
}

install_erlang() {
  _announce_step "Installing Erlang ${ERLANG_VERSION}"

  if $asdf; then
    . ${HOME}/.asdf/asdf.sh
    . ${HOME}/.asdf/completions/asdf.bash
    asdf plugin-add erlang
    asdf install erlang $ERLANG_VERSION
    _announce_success "Successfully install erlang: ${ERLANG_VERSION}"
  else
    _announce_error "Need ASDF to install erlang"
  fi

}

set_global_erlang() {
  _announce_step "Setting Global Erlang to ${ERLANG_VERSION}"

  if $asdf; then
    . ${HOME}/.asdf/asdf.sh
    . ${HOME}/.asdf/completions/asdf.bash
    asdf global erlang ${ERLANG_VERSION}
    _announce_success "Successfully set global erlang to ${ERLANG_VERSION}"
  else
    _announce_error "Need ASDF to set erlang"
  fi
}

set_global_elixir() {
  _announce_step "Setting Global Elixir to ${ELIXIR_VERSION}"

  if $asdf; then
    . ${HOME}/.asdf/asdf.sh
    . ${HOME}/.asdf/completions/asdf.bash
    asdf global elixir ${ELIXIR_VERSION}
    _announce_success "Successfully set global elixir to ${ELIXIR_VERSION}"
  else
    _announce_error "Need ASDF to set elixir"
  fi
}

install_elixir() {
  _announce_step "Installing Elixir ${ELIXIR_VERSION}"

  if $asdf; then
    asdf plugin-add elixir
    . ${HOME}/.asdf/asdf.sh
    . ${HOME}/.asdf/completions/asdf.bash
    asdf install elixir ${ELIXIR_VERSION}
    _announce_success "Successfully install elixir: ${ELIXIR_VERSION}"
  else
    _announce_error "Need ASDF to install elixir"
  fi
}

install_adify() {
  _announce_step "Installing Adify ${ADIFY_VERSION}"
  git clone https://github.com/aditya7iyengar/adify $HOME/.cloned_adify
  cd $HOME/.cloned_adify/adify_runner
  git checkout $ADIFY_VERSION
  mix deps.get
  mix compile

  _announce_step "Checking Adify installation"
  mix adify --help
  if [ $? -eq 0 ]; then
    _announce_success "Adify ${ADIFY_VERSION} successfully installed"
  else
    _announce_error "Failed!"
  fi
}

run_adify(){
  _announce_step "Running adify"

  cd $HOME/.cloned_adify/adify_runner

  if $noconfirm == true; then
    mix adify --os $1 --noconfirm
  else
    if [[ ! -z $tools_dir ]]; then
      _announce_info "With Tools dir=${tools_dir}"
      _announce_info "Running mix adify --os ${1} -t ${tools_dir}"
      mix adify --os $1 -t $tools_dir
    else
      mix adify --os $1
    fi
  fi
}

cleanup_on_aisle5() {
  _announce_step "Installing Adify ${ADIFY_VERSION}"

  cd $HOME
  rm -rf $HOME/.cloned_adify
  if [ $? -eq 0 ]; then
    _announce_success "Adify ${ADIFY_VERSION} successfully cleanedup"
  else
    _announce_error "Failed to cleanup"
  fi
}

main () {
  check_os
  check_shell

  check_asdf

  if [[ -z "$ADIFY_TEST" ]]; then
    adify_test=false
  else
    adify_test=${ADIFY_TEST}
  fi

  if [[ -z "$NO_CLEANUP" ]]; then
    no_cleanup=false
  else
    no_cleanup=${NO_CLEANUP}
  fi

  if [[ -z "$NO_CONFIRM" ]]; then
    noconfirm=false
  else
    noconfirm=${NO_CONFIRM}
  fi

  tools_dir=${TOOLS_DIR}

  if $asdf; then
    _announce_success "No need to install ASDF"
  else
    install_asdf zsh
  fi

  if $adify_test == true; then
    _announce_success "Mocking Tools, Erlang, Elixir and other deps"
  else
    $"install_${OS}_tools"
    install_erlang
    set_global_erlang
    install_elixir
    set_global_elixir

    install_adify

    run_adify $OS

    if $no_cleanup == true; then
      _announce_success "DONE! SKipping cleanup"
    else
      cleanup_on_aisle5
    fi
  fi
}

main
