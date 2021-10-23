# load functions
source "$HOME/.dotfiles/.functionsrc"

# load rc
RC_PATH=$(detect_rc)
if [ -f "$RC_PATH" ]; then
    source "$RC_PATH"
fi

# vim
export VISUAL=vim
export EDITOR="$VISUAL"

# go
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
export PATH="$PATH:/usr/local/go/bin:$GOBIN"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"

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

    local NPMRC_PATH
    local NVMRC_PATH
    local NVM_DEFAULT_VERSION
    local NVM_VERSION
    local LOCALLY_RESOLVED_NVM_VERSION

    NVMRC_PATH=$(find_out .nvmrc | tr -d '\n')
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

alias vim="nvim"
alias cd="smart_cd"
smart_cd "$PWD"
