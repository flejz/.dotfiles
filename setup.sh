if [ -d "$HOME/.dotfiles" ]; then
  rm -drf $HOME/.dotfiles
fi

# clone .dotfiles
echo "Cloning .dotfiles"
git clone https://github.com/flejz/.dotfiles.git $HOME/.dotfiles &>/dev/null

# load functions
source $HOME/.dotfiles/.functionsrc

# profile setup
echo "Setting up profile"
PROFILE_PATH=$(detect_profile)
if [ -w "$PROFILE_PATH" ]; then 
  INJECTION="source $HOME/.dotfiles/.profile"
  INJECTION_EXISTS=$(cat $PROFILE_PATH | grep "$INJECTION")

  if [ -z $INJECTION_EXISTS  ]; then
    echo "source $HOME/.dotfiles/.profile" >> $PROFILE_PATH
  fi
else 
  ln -s $HOME/.dotfiles/.profile $PROFILE_PATH &>/dev/null
fi

# tmux setup
echo "Setting up tmux"
ln -s $HOME/.dotfiles/.tmux.conf $HOME/.tmux.conf &>/dev/null
