# dotfiles

Neovim (LazyVim), tmux and starship configs, managed with [chezmoi](https://chezmoi.io).

## Install on a new machine

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply euick0
```

## Sync

```sh
chezmoi update                      # pull + apply latest
chezmoi re-add                      # copy local edits back into the repo
chezmoi git -- commit -am "msg" && chezmoi git push
```
