#!/bin/bash

SOURCE=${BASH_SOURCE[0]}
NVIM_DIR="$HOME/.config/nvim"
NVIM_PACK_DIR="$NVIM_DIR/pack"


if [ -d "$NVIM_DIR" ]; then
  if [ ! -L "$LINK_OR_DIR" ]; then
    read -p "The directory \"$NVIM_DIR\" is not a link to this directory. Would you like to replace with a link instead? (yes/no) " REPLACE_NVIM_DIR

    if [ "$REPLACE_NVIM_DIR" == "yes" ]; then
      echo "Copying \"$NVIM_DIR\" to \"$NVIM_DIR-bkp\""
      mv "$NVIM_DIR" "$NVIM_DIR-bkp"
      ln -s "$(dirname "$SOURCE")" "$NVIM_DIR"
    fi
  fi
fi

clone_repo() {
  REPO="$1"
  shift;
  ARGS="$*"
  [[ $REPO =~ \/(.*)$ ]]
  SHORT=${BASH_REMATCH[1]}
  echo "Clonning $REPO with args $ARGS $SHORT"
  eval "git clone $ARGS https://github.com/$REPO.git $NVIM_PACK_DIR/plugins/start/$SHORT"
}

LIST=(
  "neoclide/coc.nvim"
  "nvim-telescope/telescope.nvim"
  "nvim-lua/plenary.nvim"
  "BurntSushi/ripgrep"
  "hoob3rt/lualine.nvim"
  "sheerun/vim-polyglot"
)

ARGS=(
  "--depth 1 --quiet -b release"
  "--depth 1 --quiet"
  "--depth 1 --quiet"
  "--depth 1 --quiet"
  "--depth 1 --quiet"
  "--depth 1 --quiet"
)


if [ -d "$NVIM_PACK_DIR" ]; then
  read -p "The directory \"$NVIM_PACK_DIR\" exists, would you like to purge it? (yes/no) " REPLACE_NVIM_DIR
  rm -drf "$NVIM_PACK_DIR" 
fi

for i in "${!LIST[@]}"; do
  clone_repo "${LIST[i]}" "${ARGS[i]}"
done


ln -s ~/.vim/vimrc ~/.vimrc 2>/dev/null
echo "install https://github.com/golang/tools/blob/master/gopls for go"
echo "install https://github.com/MaskRay/ccls for cpp"
echo "install https://github.com/Microsoft/TypeScript/wiki/Standalone-Server-%28tsserver%29 for typescript"
echo "install https://github.com/koalaman/shellcheck for shell script"
echo "install https://github.com/rust-analyzer/rust-analyzer for rust"
