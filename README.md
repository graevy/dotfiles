don't clone as root

yet another dotfiles repo. here are my quirks:
- i `.gitignore` `*` and `.*`. then i unignore e.g. `!.config`. this is because linux developers get off to dumping state in `~`
- `root` inherits my `.bashrc` and `.gitconfig`, so they're `644 root root`
- [neovim is a special headache](https://quatl.ooo/posts/neovim-1/) where i [mkOutOfStoreSymlink inside the home-manager module](https://github.com/graevy/nixos/blob/f0d23fa23fe78265e086eadffd358343422395d1/home-manager-a.nix#L18). this fixes mason/treesitter/hardcoding binaries with a store object while providing lazy-nvim a *writeable* symlink


