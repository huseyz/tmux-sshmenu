#!/usr/bin/env bash

if [ ! -f ~/.ssh/config ]; then
    tmux display-message "Couldn't find ~/.ssh/config"
    exit 1
fi

key=$(tmux show-option -gqv @sshmenu-key)
key=${key:-C}

IFS=$'\n' hosts=($(grep -E "^Host\s+([a-zA-Z0-9]+$)" ~/.ssh/config | OFS="\t" awk '{ print $2 }'))
CMD="display-menu -T \"#[align=centre fg=green]SSH\" -x R -y P "
N=1
for host in ${hosts[@]}; do
    CMD+="\"$host\" \"$N\" \"send-keys 'ssh $host' C-m\" "
    N=$((N+1))
done
tmux bind-key "$key" "$CMD"
