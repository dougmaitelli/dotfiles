{ config, pkgs, lib, ... }:

{
  imports =
    [
      ../../home/fish.nix
    ];
  
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "dougm";
  home.homeDirectory = "/home/dougm";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  nixpkgs.config.allowUnfree = true;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    kitty
    ghostty
    starship
    neofetch
    eza
    lolcat
    fortune
    pipes
    fzf
    zoxide
    bat
    tlrc
    delta
    fnm

    tree-sitter
    google-chrome
    vscode
  ];

  programs.starship.enable = true;

  programs.git = {
    enable = true;
    userName = "Douglas Maitelli";
    userEmail = "dougmaitelli@gmail.com";
    extraConfig = {
      init = {
        defaultBranch = "master";
      };

      core = {
        pager = "delta";
      };

      interactive = {
        diffFilter = "delta --color-only";
      };

      delta = {
        navigate = true;
        line-numbers = true;
        side-by-side = false;
      };

      merge = {
        conflictstyle = "diff3";
      };

      diff = {
        colorMoved = "default";
      };
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
  };

  xdg.configFile."bat/themes/CatppuccinMocha.tmTheme".source = ../../../../config/bat/themes/CatppuccinMocha.tmTheme;
  xdg.configFile."nvim/init.lua".source = ../../../../config/nvim/init.lua;

  home.sessionVariables = {
    EDITOR = "nvim";
    BAT_THEME = "CatppuccinMocha";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
