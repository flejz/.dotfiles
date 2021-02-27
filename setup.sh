
try_profile() {
  if [ -z "${1-}" ] || [ ! -f "${1}" ]; then
    return 1
  fi
  echo "${1}"
}

detect_rc() {
  if [ "${PROFILE-}" = '/dev/null' ]; then
    return
  fi

  if [ -n "${PROFILE}" ] && [ -f "${PROFILE}" ]; then
    echo "${PROFILE}"
    return
  fi

  local DETECTED_RC
  DETECTED_RC=''

  if [ -n "${BASH_VERSION-}" ]; then
    if [ -f "$HOME/.bashrc" ]; then
      DETECTED_RC="$HOME/.bashrc"
    fi
  elif [ -n "${ZSH_VERSION-}" ]; then
    DETECTED_RC="$HOME/.zshrc"
  fi

  if [ -z "$DETECTED_RC" ]; then
    for EACH_PROFILE in ".bashrc" ".zshrc"
    do
      if DETECTED_RC="$(nvm_try_profile "${HOME}/${EACH_PROFILE}")"; then
        break
      fi
    done
  fi

  if [ -n "$DETECTED_RC" ]; then
    echo "$DETECTED_RC"
  fi
}

detect_profile() {
  RC_PATH=$(detect_rc)
  RC=$(echo $RC_PATH | sed 's/.*\///g')

  case "$RC" in
    .bashrc*)
      echo "$HOME/.bash_profile"
      ;;
    .zshrc*)
      echo "$HOME/.zprofile"
      ;;
    *)
      ;;
  esac
}

is_link() {
  [ -z $(file $@ | grep -i link) ]
}

if [ -d "$HOME/.dotfiles" ]; then
  rm -drf $HOME/.dotfiles
fi

# clone .dotfiles
echo "Cloning .dotfiles"
git clone https://github.com/flejz/.dotfiles.git $HOME/.dotfiles &>/dev/null

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
