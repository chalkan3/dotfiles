export PATH=/Users/chalkan3/.local/bin:$PATH
export LUA_PATH="/opt/homebrew/share/lua/5.4/?.lua;/opt/homebrew/share/lua/5.4/?/init.lua;;"
export LUA_CPATH="/opt/homebrew/lib/lua/5.4/?.so;;"
export PATH="$HOME/.rbenv/bin:$PATH"

export PULUMI_CONFIG_PASSPHRASE=""
#export BW_SESSION=$(bw unlock --raw)


eval "$(rbenv init - zsh)"
eval $(luarocks path)
