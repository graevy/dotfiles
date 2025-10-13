i try to avoid porting complex configs to nixos to maintain distro portability, so i dump them here

neovim is a special headache where i [mkOutOfStoreSymlink inside the home-manager module](https://github.com/graevy/nixos/blob/f0d23fa23fe78265e086eadffd358343422395d1/home-manager-a.nix#L18). this fixes mason/treesitter/hardcoding binaries with a store object while providing lazy-nvim a *writeable* symlink. i haven't found a better way yet. i'm also attempting to use neovim's native config as much as possible; nixos isn't adequate here. config is only stored in nixos insofar as `fzf` and `lazygit` etc. are being managed by nix instead of `luarocks` under lazy.

TODO: i think the symlinks pointing directly to nix store blobs might interfere with recovery

i keep having to explain the whitelist .gitignore pattern. every fucking program under the sun wants to write to `~`, so eventually whitelisting (by gitignoring `*` and `.*` and then e.g. `!.config`) becomes less onerous. you also don't want to accidentally shove sensitive homedir things into git.

