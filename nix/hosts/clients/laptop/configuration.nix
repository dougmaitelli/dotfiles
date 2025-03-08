{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
      ../../../modules/nixos/locale.nix
      ../../../modules/nixos/desktop.nix
      ../../../modules/nixos/audio.nix
      ../../../modules/users/doug
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
  boot.initrd.kernelModules = [ "nvidia" ];

  hardware = {
    graphics = {
      enable = true;
    };
    nvidia.modesetting.enable = true;
  };

  networking.hostName = "laptop";

  # Enable networking
  networking.networkmanager.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    curl
    wget
    killall
    vim
    git
    python3
    jq
    unzip
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
