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
cdt() { cd $(mktemp -d); }
please() { sudo $(fc -ln -1); }
rmv() { mv "$@" /tmp; }
rmtmp() { sudo rm -rf /tmp/* /tmp/.*; }

# shortcuts
alias s='git status'
alias d='git diff'
alias c='git commit'
alias ck='git checkout'
alias k='kubectl'
alias py='python'

# X tooling
if [ -f ~/.bashxrc ]; then
	source ~/.bashxrc
fi

# arch tooling
if [ -f ~/.basharchrc ]; then
	source ~/.basharchrc
fi

# web services. igor chubin <3
alias wttr='curl -s wttr.in/seattle'
alias cheat='curl cht.sh/$@'

# esoteric tooling
alias freeze='su -c "echo freeze > /sys/power/state"'
alias rescan='nmcli d wifi list --rescan yes'
# deprecated; keeping for ytdlp documentation
#alias ytdl="youtube-dl -f bestaudio --audio-quality 0 --embed-thumbnail -x --audio-format mp3 --add-metadata -o '%(title)s.%(ext)s'"
alias ytdlp="yt-dlp -f bestaudio --add-metadata -o '%(title)s.%(ext)s'"
ish() { ssh -o StrictHostKeyChecking=no $@; }
icp() { scp -o StrictHostKeyChecking=no $@; }
irc() { irssi -n ${NICKNAME:-$USER}; }
sedd() {
  # sed debugger
  tf=`mktemp`
  # this line runs "sed $@" and then redirects stderr to tee to debug sed
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
#troll() { ls $@ -Ad . ..; }

# env vars
if [ -f ~/.bashenv ]; then
	source ~/.bashenv 
fi

