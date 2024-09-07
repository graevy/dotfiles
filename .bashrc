#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias la='ls -a --color=auto'
alias l='ls -lahr --color=auto'
alias py='python'
alias update='sudo pacman -Syu'
alias rescan='nmcli d wifi list --rescan yes'
alias ~='cd ~'
alias ..='cd ..'
alias s='git status'
alias d='git diff'
alias ck='git checkout'
alias k='kubectl'
alias please='sudo $(fc -ln -1)'
alias orphans='[[ -n $(pacman -Qdt) ]] && sudo pacman -Rs $(pacman -Qdtq) || echo "no orphans to remove"'
alias troll='ls $@ -Ad . ..'
alias freeze='su -c "echo freeze > /sys/power/state"'
alias rmtmp='sudo rm -rf /tmp/* && rm -rf /tmp/.*'

alias wttr='curl -s wttr.in/seattle'
alias ytdl="youtube-dl -f bestaudio --audio-quality 0 --embed-thumbnail -x --audio-format mp3 --add-metadata -o '%(title)s.%(ext)s'"

# use over rm -rf wherever possible
rmv() {
	mv "$@" /tmp
}

# most useful command
cs() {
        cd "$1" && ls -ah "${@:2}";
}

mkcd() { 
	mkdir -p $1
	cd $1
}

cdt() {
	cd $(mktemp -d)
}

# ssh without using known_hosts
ish() {
	ssh -o StrictHostKeyChecking=no $@	
}

icp() {
	scp -o StrictHostKeyChecking=no $@
}

cheat() {
      curl cht.sh/$@
}

# a sed debugger
seds() {
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

gamma() {
    xrandr --listactivemonitors | tail -n +2 | awk '{print $NF}' | while IFS= read -r line; do
        xrandr --output $line --brightness "$1"
    done
}

# lowercase w to display full wd path
PS1='[\u \w]\$ '


export EDITOR="vim"
export WWW_HOME="duckduckgo.com"
export KUBECONFIG=/home/a/code/controlplane/kubeconfig.yaml
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

