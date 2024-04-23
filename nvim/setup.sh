#!/bin/bash

SOURCE=$(dirname BASH_SOURCE[0])
NVIM_DIR="$HOME/.config/nvim"

notify_sudo() {
  if [ "$(id -u)" -ne 0 ]; then 
    echo "Sudo privileges will be required"
    sleep 1
  fi

}

# download and copy
install_nvim() {
  notify_sudo
  if [ -d "/opt/nvim-linux64" ]; then
    sudo rm -drf /opt/nvim-linux64
  fi
  echo "Downloading nvim..."
  wget -q --show-progress https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
  echo "Extracting nvim"
  sudo tar -C /opt -xzvf nvim-linux64.tar.gz
  echo "Nvim installed"
  rm nvim-linux64.tar.gz*
}

if [ -d "/opt/nvim-linux64" ]; then
  read -rp "Would you like to update neovim? (yes/no): " INSTALL
else 
  INSTALL="yes"
fi

if [ "$INSTALL" == "yes" ]; then 
  install_nvim
fi

# soft link

backup_dir() {
  echo "Backing up \"$NVIM_DIR\" to \"$NVIM_DIR-bkp\""
  mv "$NVIM_DIR" "$NVIM_DIR-bkp"
}

link_dir() {
  echo "Linking"
  ln -s "$HOME/.dotfiles/nvim" "$NVIM_DIR"
}


if [ -d "$NVIM_DIR" ]; then
  if [ ! -L "$LINK_OR_DIR" ]; then
    echo "The directory \"$NVIM_DIR\" is not a link to this directory"
    read -rp "Would you like to replace with a link instead? (yes/no): " REPLACE_NVIM_DIR
    if [ "$REPLACE_NVIM_DIR" == "yes" ]; then
      backup_dir
      link_dir
    fi
  fi
else 
  link_dir
fi

NVIM_PACK_DIR="$NVIM_DIR/pack"
if [ -d "$NVIM_PACK_DIR" ]; then
  read -rp "The directory \"$NVIM_PACK_DIR\" exists, would you like to purge it? (yes/no): " REPLACE_NVIM_DIR
  rm -drf "$NVIM_PACK_DIR" 
fi

clone_repo() {
  REPO="$1"
  shift;
  ARGS="$*"
  [[ $REPO =~ \/(.*)$ ]]
  SHORT=${BASH_REMATCH[1]}
  echo "Clonning $REPO"
  eval "git clone $ARGS https://github.com/$REPO.git $NVIM_PACK_DIR/plugins/start/$SHORT"
}

REPO_LIST=(
  "neoclide/coc.nvim"
  "nvim-telescope/telescope.nvim"
  "nvim-lua/plenary.nvim"
  "BurntSushi/ripgrep"
  "hoob3rt/lualine.nvim"
  "sheerun/vim-polyglot"
)

REPO_ARGS=(
  "--depth 1 --quiet -b release"
  "--depth 1 --quiet"
  "--depth 1 --quiet"
  "--depth 1 --quiet"
  "--depth 1 --quiet"
  "--depth 1 --quiet"
)

for i in "${!REPO_LIST[@]}"; do
  clone_repo "${REPO_LIST[i]}" "${REPO_ARGS[i]}"
done


echo "install https://github.com/golang/tools/blob/master/gopls for go"
echo "install https://github.com/MaskRay/ccls for cpp"
echo "install https://github.com/Microsoft/TypeScript/wiki/Standalone-Server-%28tsserver%29 for typescript"
echo "install https://github.com/koalaman/shellcheck for shell script"
echo "install https://github.com/rust-analyzer/rust-analyzer for rust"
