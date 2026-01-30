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
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
cs() { cd "$1" && la "${@:2}"; }
complete -F _cd cs # complete cs like cd
mkcd() { mkdir -p $1 && cd $1; }
cdt() { cd $(mktemp -d); }
please() { sudo $(fc -ln -1); }
rmv() { mv "$@" /tmp; }
rmtmp() { sudo rm -rf /tmp/* /tmp/.*; }
# finds-and-replaces all instances of $1 with $2 inside files inside $3 (defaults to current dir)
# the complicated replace block is to escape & in sed which is treated as matched text i think
replace() {
  find "${3:-.}" -type f -print0 | xargs -0 sed -i "s|$1|${2//&/\\&}|g"
}
# pull all nested files into $1 (defaults to .)
# duplicate files don't get moved nor their dirs deleted (with mv -n)
flatten() {
  find "${1:-.}" -mindepth 2 -type f -exec mv -n -t . {} +
  find "${1:-.}" -mindepth 1 -type d -empty -delete
}

# common shortcuts
alias n='nvim'
alias v='vim'
alias k='kubectl'
alias py='python'
alias wlc='wl-copy'
alias wlp='wl-paste'

# esoteric tooling
alias freeze='su -c "echo freeze > /sys/power/state"'
alias rescan='nmcli d wifi list --rescan yes'
alias wttr='curl -s wttr.in/seattle'
# deprecated; keeping for ytdlp documentation
#"youtube-dl -f bestaudio --audio-quality 0 --embed-thumbnail -x --audio-format mp3 --add-metadata -o '%(title)s.%(ext)s'"
alias ytdlv="yt-dlp -f bestaudio --add-metadata -o '%(title)s.%(ext)s'"
alias ytdla="yt-dlp -x --audio-format opus --add-metadata -o '%(title)s.%(ext)s'"
ish() { ssh -o StrictHostKeyChecking=no "$@"; }
icp() { scp -o StrictHostKeyChecking=no "$@"; }
irc() { irssi -n ${NICKNAME:-$USER}; }
# sed debugger
sedd() {
  tf=$(mktemp)
  # this line runs "sed $@" and then redirects stderr to tee to debug sed
  command sed "$@" 2> >(tee $tf >&2)
  [[ "$?" == 1 ]] && grep -q . $tf && {
    echo "at: sed $@"
    count=$(command sed -En 's/^.*char ([0-9]+).*$/\1/p' $tf | tail -n 1)
    [[ "$count" ]] && {
      count=$(($count + 8 + $(<<<"$@" grep -Eo "^(-\S+\s+)*" | wc -c) - 1))
      yes ' ' | tr -d '\n' | head -c $count && echo '^'
    }
  } >&2
  rm $tf
}

######### git tooling #########
alias s='git status'
alias d='git diff'
alias ck='git checkout'
yeet() {
  git add -A && git commit -m "${*:-yeet}" && git push
}
amend() {
  git add -A && git commit --amend -C HEAD "$@" && git push --force
}
# commit files, use last arg as message
c() {
    args=("$@")
    last="${args[-1]}"
    unset 'args[-1]'
    git add "${args[@]}" && git commit -m "$last"
}
complete -o default -o filenames commit

######### k8s tooling #########
alias kcore='KUBECONFIG=~/.kube/coreconfig'
alias kmem='KUBECONFIG=~/.kube/memberprodconfig'
# what `kubectl get all` should be. i don't want to see events though
kgetall() {
  kubectl get $(kubectl api-resources --verbs=list --namespaced -o name | grep -v "^events" | paste -sd,) --show-kind --ignore-not-found "$@"
}
# remove finalizers from object
kkill() {
	if [[ $# -eq 2 ]]; then
      # case: cluster-wide non-namespaced resource 
		kubectl patch $1 $2 --type merge -p '{"metadata":{"finalizers":null}}'
	else
		kubectl -n $1 patch $2 $3 --type merge -p '{"metadata":{"finalizers":null}}'
	fi
}

######### nixos tooling #########
rebuild() { su -c "nixos-rebuild switch --flake /etc/nixos#a $@"; }
nixnix() { su -c "nix-env --delete-generations +$@ --profile /nix/var/nix/profiles/system"; }
ns() { nix-shell -p "$@"; }
nd() {
	if [ -n "$1" ]; then
		cd "$1" || return
	fi
	nix develop
}

# :^)
#troll() { ls $@ -Ad . ..; }

# https://direnv.net/docs/hook.html
eval "$(direnv hook bash)"

