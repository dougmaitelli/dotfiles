{ config, pkgs, ... }:

{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    nh # Nix Helper
    curl
    wget
    killall
    git
    python3
    jq
    gcc
    unzip
    unrar
    
    neovim
    tree-sitter # Vim Parsers
  ];

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 3d --keep 3";
    flake = "/home/dougm/.dotfiles/nix/";
  };

  environment.shells = with pkgs; [
    fish
  ];

  programs.fish.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };
}