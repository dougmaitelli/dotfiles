# ~/.dotfiles

## For installing dotfiles only
`curl -sS https://raw.githubusercontent.com/dougmaitelli/dotfiles/master/setup.sh | sh`

## For building nix system

### Possible flakes

- laptop
- wsl

### First time / no git available
```shell
env NIX_CONFIG="experimental-features = nix-command flakes" \
  nix shell nixpkgs#git --command sudo nixos-rebuild switch --flake github:dougmaitelli/dotfiles/nix#{flake}
```

### Rebuild
`sudo nixos-rebuild switch --flake .#{flake}`

### If using WSL terminate the instance to ensure proper user is used

`wsl --terminate NixOS`

`wsl --set-default NixOS`