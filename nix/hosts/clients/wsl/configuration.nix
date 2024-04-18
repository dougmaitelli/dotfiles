{ config, pkgs, inputs, ... }:

{
  imports =
    [
      inputs.home-manager.nixosModules.default
      ../../../modules/users/doug
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.hostName = "wsl";

  wsl.enable = true;
  wsl.defaultUser = "dougm";

  programs.nix-ld.enable = true;

  # Enable networking
  networking.networkmanager.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    curl
    wget
    killall
    neovim
    git
    python3
    jq
  ];

  environment.shells = with pkgs; [
    fish
  ];

  programs.fish.enable = true;

  # List services that you want to enable:

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
