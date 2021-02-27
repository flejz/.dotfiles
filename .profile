# vim
export VISUAL=vim
export EDITOR=$VISUAL

# go
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:/usr/local/go/bin:$GOBIN

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# clever stuff
find_up() {
    path=$(pwd)
    while [[ "$path" != "" && ! -e "$path/$1" ]]; do
        path=${path%/*}
    done
    echo "$path"
}

smart_cd() {
    cd "$@";

    npmrc_path=$(find_up .npmrc | tr -d '\n')
    if [[ -s $npmrc_path/.npmrc && -r $npmrc_path/.npmrc ]]; then
        # do something
        echo ".npmrc exists"
    fi

    nvmrc_path=$(find_up .nvmrc | tr -d '\n')
    if [[ ! $nvmrc_path = *[^[:space:]]* ]]; then
        declare default_version;
        default_version=$(nvm version default);

        if [[ $default_version == "N/A" ]]; then
            nvm alias default node;
            default_version=$(nvm version default);
        fi

        if [[ $(nvm current) != "$default_version" ]]; then
            nvm use default;
        fi
    elif [[ -s $nvmrc_path/.nvmrc && -r $nvmrc_path/.nvmrc ]]; then
        declare nvm_version
        nvm_version=$(<"$nvmrc_path"/.nvmrc)

        declare locally_resolved_nvm_version
        locally_resolved_nvm_version=$(nvm ls --no-colors "$nvm_version" | tail -1 | tr -d '\->*' | tr -d '[:space:]')

        if [[ "$locally_resolved_nvm_version" == "N/A" ]]; then
            nvm install "$nvm_version";
        elif [[ $(nvm current) != "$locally_resolved_nvm_version" ]]; then
            nvm use "$nvm_version";
        fi
    fi
}

alias cd='smart_cd'
cd $PWD
