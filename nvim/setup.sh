#!/bin/bash

# git clone https://github.com/flejz/.vimfiles.git ~/.vim

clone() {
  REPO="$1"
  shift;
  ARGS="$*"
  [[ $REPO =~ \/(.*)$ ]]
  SHORT=${BASH_REMATCH[1]}
  echo "clonning $REPO with args $ARGS $SHORT"
  eval "git clone $ARGS https://github.com/$REPO.git $HOME/.config/nvim/pack/plugins/start/$SHORT"
}

LIST=(
  "neovim/nvim-lspconfig"
  "hrsh7th/nvim-cmp"
  "hrsh7th/cmp-nvim-lsp"
  "nvim-lua/plenary.nvim"
  "dense-analysis/ale"
  "nvim-telescope/telescope.nvim"
  "BurntSushi/ripgrep"
  "hoob3rt/lualine.nvim"
  "sheerun/vim-polyglot"
)

ARGS=(
  "--depth 1 --quiet"
  "--depth 1 --quiet"
  "--depth 1 --quiet"
  "--depth 1 --quiet"
  "--depth 1 --quiet"
  "--depth 1 --quiet"
  "--depth 1 --quiet"
  "--depth 1 --quiet"
  "--depth 1 --quiet"
)

for i in "${!LIST[@]}"; do
  clone "${LIST[i]}" "${ARGS[i]}"
done


ln -s ~/.vim/vimrc ~/.vimrc 2>/dev/null
echo "install https://github.com/golang/tools/blob/master/gopls for go"
echo "install https://github.com/MaskRay/ccls for cpp"
echo "install https://github.com/Microsoft/TypeScript/wiki/Standalone-Server-%28tsserver%29 for typescript"
echo "install https://github.com/koalaman/shellcheck for shell script"
echo "install https://github.com/rust-analyzer/rust-analyzer for rust"
