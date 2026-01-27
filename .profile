# load functions
source "$HOME/.dotfiles/.functionsrc"
source "$HOME/.dotfiles/nvim/.nvimrc"

# cedilha support
export GTK_IM_MODULE=cedilla
export QT_IM_MODULE=cedilla

# load rc
RC_PATH=$(detect_rc)
if [ -f "$RC_PATH" ]; then
    . "$RC_PATH"
fi

# go
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
export PATH="$PATH:/usr/local/go/bin:$GOBIN"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"

# qt
export QT_AUTO_SCREEN_SCALE_FACTOR=1
export QT_FONT_DPI=96 clementine

# terminal
export PS1="\u@\h:\w$ "
export EDITOR="$(which vi)"

# gpg tty
export GPG_TTY="$(tty)"

# clever stuff
decease() {
    ps aux | pgrep -i "$1" | xargs kill -9
}


find_out() {
    local FIND_PATH
    FIND_PATH="$PWD"
    while [[ "$FIND_PATH" != "" && ! -e "$FIND_PATH/$1" ]]; do
        FIND_PATH=${FIND_PATH%/*}
    done
    echo "$FIND_PATH"
}

smart_cd() {
    \cd "$@"

    # local NPMRC_PATH=$(find_out .npmrc | tr -d '\n')
    # if [[ -s $NPMRC_PATH/.npmrc && -r $NPMRC_PATH/.npmrc ]]; then

    #     # audibene
    #     if [ -z $CODEARTIFACT_AUTH_TOKEN ]; then
    #         ca_acquire
    #     fi
    # fi

    local NVMRC_PATH=$(find_out .nvmrc | tr -d '\n')
    local NPMRC_PATH
    local NVMRC_PATH
    local NVM_DEFAULT_VERSION
    local NVM_VERSION
    local LOCALLY_RESOLVED_NVM_VERSION

    if [[ ! $NVMRC_PATH = *[^[:space:]]* ]]; then
        NVM_DEFAULT_VERSION=$(nvm version default);

        if [[ "$NVM_DEFAULT_VERSION" == "N/A" ]]; then
            nvm alias default node;
            NVM_DEFAULT_VERSION=$(nvm version default);
        fi

        if [[ $(nvm current) != "$NVM_DEFAULT_VERSION" ]]; then
            nvm use default;
        fi
    elif [[ -s "$NVMRC_PATH/.nvmrc" && -r "$NVMRC_PATH/.nvmrc" ]]; then
        NVM_VERSION=$(<"$NVMRC_PATH"/.nvmrc)
        LOCALLY_RESOLVED_NVM_VERSION=$(nvm ls --no-colors "$NVM_VERSION" | tail -1 | tr -d '\->*' | tr -d '[:space:]')

        if [[ "$LOCALLY_RESOLVED_NVM_VERSION" == "N/A" ]]; then
            nvm install "$NVM_VERSION";
        elif [[ $(nvm current) != "$LOCALLY_RESOLVED_NVM_VERSION" ]]; then
            nvm use "$NVM_VERSION";
        fi
    fi
}

export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
