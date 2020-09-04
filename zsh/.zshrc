# Antigen stuff; download antigen if not exists
if [ ! -f $HOME/.local/bin/antigen.zsh ]; then
    echo "Antigen missing, curl-ing it..."
    curl -sL git.io/antigen > $HOME/.local/bin/antigen.zsh
fi
source $HOME/.local/bin/antigen.zsh

# Oh-my-zsh is compulsory, ofc.
antigen use oh-my-zsh

# Default bundles that I need
if [ -f "/etc/arch-release" ]; then antigen bundle archlinux; fi
if [ -f "/etc/debian_version" ]; then antigen bundle debian; fi
antigen bundle colorize
antigen bundle colored-man-pages
antigen bundle command-not-found
antigen bundle git
antigen bundle pip

# Custom ones
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-history-substring-search
antigen bundle zsh-users/zsh-syntax-highlighting

# Theme!
antigen theme agnoster

# Apply all the bundles and theme
antigen apply

# Make history better
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000000
SAVEHIST=10000000
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_REDUCE_BLANKS

# Starting text
# Adjusted to my sleeping schedule :P
printf "こんにちわ $USER-kun! "
HOUR=$(date "+%k")
if (( HOUR < 7 )); then
    printf "You should go to sleep, y'know?"
elif (( HOUR < 14 )); then
    printf "Ah the fresh morning air... Wait, did you wake up at 1300 again?"
else
    printf "A perfect time for working, innit?"
fi
echo

# Fortune | Cowsay
if command -v "fortune" >/dev/null && \
        command -v "cowsay" >/dev/null; then
    fortune -c -a | cowsay
    echo
fi
