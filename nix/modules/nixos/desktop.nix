{ config, pkgs, inputs, ... }:

{
  environment.systemPackages = with pkgs; [
    hyprland
    hyprlock
    hypridle
    waybar
    swww
    rofi-wayland
    wl-clipboard
    networkmanagerapplet
    pavucontrol
    libnotify
    mako

    dolphin

    papirus-icon-theme
  ];

  fonts = {
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
    ];
    fontconfig = {
      defaultFonts = {
        serif = [ "FiraCode Nerd Font" ];
        sansSerif = [ "FiraCode Nerd Font" ];
        monospace = [ "FiraCodeMono Nerd Font" ];
      };
    };
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
