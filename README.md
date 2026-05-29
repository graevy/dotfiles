don't clone as root

yet another dotfiles repo. here are my quirks:
- i `.gitignore` `*` and `.*`. then i unignore e.g. `!.config`. this is because linux developers get off to dumping state in `~`
- `root` inherits my `.bashrc` and `.gitconfig`, so they're `644 root root`

