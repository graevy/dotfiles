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

alias sue='sudo -E bash'
please() { sudo $(fc -ln -1); }

# move things to /tmp instead of deleting them. maintain a log for undoing 
rmv() {
    local f src dest base ext suffix
	 local log="/tmp/rmv-${UID}.log"

    for f in "$@"; do
        src="$(realpath -- "$f" 2>/dev/null)" || { printf 'rmv: %s: no such file or directory\n' "$f" >&2; continue; }

        base="$(basename -- "$f")"
        dest="/tmp/$base"

        # suffix for overwrite case. check for suffix existence and append if necessary
        if [[ -e "$dest" ]]; then
            suffix=1
            while [[ -e "${dest}.${suffix}" ]]; do (( suffix++ )); done
            dest="${dest}.${suffix}"
        fi

        mv -- "$f" "$dest" || continue
		  # append to log
        printf '%s\t%s\n' "$dest" "$src" >> "$log"
    done
}

# undo deletion via the log
urmv() {
    local log="/tmp/rmv-${UID}.log"
    local dest src lastline

    [[ -f "$log" ]] || { printf 'urmv: log not found\n' >&2; return 1; }
    [[ -s "$log" ]] || { printf 'urmv: nothing to undo\n' >&2; return 1; }

    lastline="$(tail -n 1 "$log")"
    dest="${lastline%%$'\t'*}"   # location inside /tmp
    src="${lastline##*$'\t'}"    # original location

    [[ -e "$dest" ]] || { printf 'urmv: %s: no longer in /tmp\n' "$dest" >&2; return 1; }

	 # just panic for the overwrite case
    if [[ -e "$src" ]]; then
        printf 'urmv: destination already exists, aborting: %s\n' "$src" >&2
        return 1
    fi

    mkdir -p -- "$(dirname -- "$src")" || return 1
    mv -- "$dest" "$src" && sed -i '$d' "$log"
}

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

alias freeze='su -c "echo freeze > /sys/power/state"'


# tooling
alias n='nvim'
alias v='vim'
alias vi='nvim'
alias k='kubectl'
alias py='python'
alias wlc='wl-copy'
alias wlp='wl-paste'
alias rescan='nmcli d wifi list --rescan yes'
alias wttr='curl -s wttr.in/seattle'
# deprecated; keeping for ytdlp documentation
#"youtube-dl -f bestaudio --audio-quality 0 --embed-thumbnail -x --audio-format mp3 --add-metadata -o '%(title)s.%(ext)s'"
alias ytdlv="yt-dlp -f bestaudio --add-metadata -o '%(title)s.%(ext)s'"
alias ytdla="yt-dlp -x --audio-format opus --add-metadata -o '%(title)s.%(ext)s'"
# "insecure shell", TERM for alacritty
ish() { TERM=xterm-256color ssh -o StrictHostKeyChecking=no "$@"; }
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

# silent neovim; attempt to not disturb mtime
svi() {
  local file="$1"
  local ts=$(stat -c %y "$file")
  nvim "$file"
  touch -d "$ts" "$file"
}

# leaving this (homebrew native) pattern here for when i inevitably do frontend things
# https://mijndertstuij.nl/posts/life-is-too-short-for-a-slow-terminal/
# export NVM_DIR="$HOME/.nvm"
# nvm() {
#   unset -f nvm
#   [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh" --no-use
#   [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
#   nvm "$@"
# }

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
  kubectl get $(kubectl api-resources --verbs=list --namespaced -o name | grep -iv "^events" | paste -sd,) --show-kind --ignore-not-found "$@"
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

######### nix/os tooling #########
rebuild() { su -c "nixos-rebuild switch --flake $@"; }
nixnix() { su -c "nix-env --delete-generations +$@ --profile /nix/var/nix/profiles/system"; }

ns() { nix-shell -p "$@"; }
nd() {
	if [ -n "$1" ]; then
		cd "$1" || return
	fi
	nix develop
}

# :^)
#ls() { ls $@ -Ad . ..; }

# https://direnv.net/docs/hook.html
eval "$(direnv hook bash)"

