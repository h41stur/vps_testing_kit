#!/bin/bash

DIR=$(pwd)
INSTALLER="sudo apt install"

# UPDATE

apt update
apt upgrade -y
apt install -y git

# FONTS
mkdir -p $HOME/.local/share/fonts
cp -r fonts/* $HOME/.local/share/fonts/
fc-cache -fv
cp .xsettingsd $HOME

# CASE INSENSITIVE
cp .inputrc $HOME

# DOT
cp .vimrc $HOME
cp .bashrc $HOME/
mkdir -p /root/.config
apt install bat -y
cp .bash_aliases $HOME

# CARACTERES
localectl set-locale LANG=en_US.UTF-8

# DOCKER
apt install docker.io -y

# TERMINAL
apt install exa -y
cp .bash-preexec.sh $HOME

################################################################################

# TMUX
apt install -y tmux inetutils-tools ruby jq

gem install tmuxinator
set -e
set -u
set -o pipefail

is_app_installed() {
  type "$1" &>/dev/null
}

REPODIR="$(cd "$(dirname "$0")"; pwd -P)"
cd "$REPODIR";

if ! is_app_installed tmux; then
  printf "WARNING: \"tmux\" command is not found. \
Install it first\n"
  exit 1
fi

if [ ! -e "$HOME/.tmux/plugins/tpm" ]; then
  printf "WARNING: Cannot found TPM (Tmux Plugin Manager) \
 at default location: \$HOME/.tmux/plugins/tpm.\n"
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

if [ -e "$HOME/.tmux.conf" ]; then
  printf "Found existing .tmux.conf in your \$HOME directory. Will create a backup at $HOME/.tmux.conf.bak\n"
fi

cp -f "$HOME/.tmux.conf" "$HOME/.tmux.conf.bak" 2>/dev/null || true
cp -a ./tmux/. "$HOME"/.tmux/
ln -sf .tmux/tmux.conf "$HOME"/.tmux.conf;

# Install TPM plugins.
# TPM requires running tmux server, as soon as `tmux start-server` does not work
# create dump __noop session in detached mode, and kill it when plugins are installed
printf "Install TPM plugins\n"
tmux new -d -s __noop >/dev/null 2>&1 || true 
tmux set-environment -g TMUX_PLUGIN_MANAGER_PATH "~/.tmux/plugins"
"$HOME"/.tmux/plugins/tpm/bin/install_plugins || true
tmux kill-session -t __noop >/dev/null 2>&1 || true

cp -r tmuxinator/ $HOME/.config/

##################################################################

# INITIAL IPTABLES

bash ./iptables.sh

# OPENVPN

bash < <(curl -s https://git.io/vpn)

# SSH

cp authorized_keys ~/.ssh/
