{ config, pkgs, inputs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dougm = {
    isNormalUser = true;
    description = "Douglas";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.fish;
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "dougm" = import ./home.nix;
    };
  };
}
