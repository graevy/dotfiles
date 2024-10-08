#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# lowercase w for absolute cwd
PS1='[\u\w]\$ '

# bash "improvements"
alias la='ls -ah --color=auto'
alias l='ls -lahr --color=auto'
alias ~='cd ~'
alias ..='cd ..'
cs() { cd "$1" && la "${@:2}"; }
mkcd() { mkdir -p $1 && cd $1; }
alias cdt="cd $(mktemp -d)"
alias please='sudo $(fc -ln -1)'
alias rmv='mv "$@" /tmp'
alias rmtmp='sudo rm -rf /tmp/* /tmp/.*'

# shortcuts
alias s='git status'
alias d='git diff'
alias ck='git checkout'
alias k='kubectl'
alias py='python'

# X tooling
alias xcl='xclip -sel c'
gamma() {
    # set the gamma value of each monitor i.e. "gamma 0.5" = extra screen dimming for 3am coding
    xrandr --listactivemonitors | tail -n +2 | awk '{print $NF}' | while IFS= read -r line; do
        xrandr --output $line --brightness "$1"
    done
}

# arch tooling
alias update='sudo pacman -Syu'
alias orphans='[[ -n $(pacman -Qdt) ]] && sudo pacman -Rs $(pacman -Qdtq) || echo "no orphans to remove"'

# web services. igor chubin <3
alias wttr='curl -s wttr.in/seattle'
alias cheat='curl cht.sh/$@'

# esoteric tooling
alias freeze='su -c "echo freeze > /sys/power/state"'
alias rescan='nmcli d wifi list --rescan yes'
alias ytdl="youtube-dl -f bestaudio --audio-quality 0 --embed-thumbnail -x --audio-format mp3 --add-metadata -o '%(title)s.%(ext)s'"
alias ish="ssh -o StrictHostKeyChecking=no $@"
alias icp="scp -o StrictHostKeyChecking=no $@"
sedd() {
  # sed debugger
  tf=`mktemp`
  command sed "$@" 2> >(tee $tf >&2)
  [[ "$?" == 1 ]] && grep -q . $tf && {
    echo "at: sed $@"
    count=$(command sed -En 's/^.*char ([0-9]+).*$/\1/p' $tf | tail -n 1)
    [[ "$count" ]] && {
       count=$(( $count + 8 + $(<<<"$@" grep -Eo "^(-\S+\s+)*" | wc -c) - 1 ))
       yes ' ' | tr -d '\n' | head -c $count && echo '^'
    }
  } >&2
  rm $tf
}

# :^)
#alias troll='ls $@ -Ad . ..'

# env vars
export EDITOR="vim"
export WWW_HOME="duckduckgo.com"
export KUBECONFIG=~/code/controlplane/kubeconfig.yaml
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

