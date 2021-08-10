if [ -d "$HOME/.dotfiles" ]; then
  echo "Removing $HOME/.dotfiles"
  rm -drf $HOME/.dotfiles
fi

# clone .dotfiles
echo "Cloning to $HOME/.dotfiles"
git clone https://github.com/flejz/.dotfiles.git $HOME/.dotfiles &>/dev/null

# load functions
source $HOME/.dotfiles/.functionsrc

# profile setup
PROFILE_PATH=$(detect_profile)
echo "Setting up profile $PROFILE_PATH"
if [ -w "$PROFILE_PATH" ]; then 
  INJECTION="source $HOME/.dotfiles/.profile"
  INJECTION_EXISTS=$(cat $PROFILE_PATH | grep "$INJECTION")

  LINK_PATH=$(is_link "$PROFILE_PATH")
  if [ -n $LINK_PATH ] && [ $LINK_PATH == "$HOME/.dotfiles/.profile" ]; then
    echo "Profile $PROFILE_PATH is already a link of $LINK_PATH"
  else 
    echo "WARNING: Profile $PROFILE_PATH already linked to $LINK_PATH. Fix it manually"
  fi

  if [ -z $LINK_PATH ] && [ -z $INJECTION_EXISTS ]; then
    echo "source $HOME/.dotfiles/.profile" >> $PROFILE_PATH
  fi
else 
  ln -s $HOME/.dotfiles/.profile $PROFILE_PATH &>/dev/null
fi

# tmux setup
echo "Setting up tmux $HOME/.tmux.conf"
ln -s $HOME/.dotfiles/.tmux.conf $HOME/.tmux.conf &>/dev/null

# setting up tools
echo "Setting up tools"
ln -s $HOME/.dotfiles/tools/cpumode /usr/local/sbin/cpumode &>/dev/null

if [ -d "$HOME/.vim" ]; then
  ln -s "$HOME/.vim/coc-settings.json" "$HOME/.config/nvim/coc-settings.json" 
fi
