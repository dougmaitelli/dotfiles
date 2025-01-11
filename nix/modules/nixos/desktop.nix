{ config, pkgs, inputs, ... }:

{
  environment.systemPackages = with pkgs; [
    hyprland
    hypridle
    hyprlock
    swww
    waybar
    rofi-wayland
    wl-clipboard
    libnotify
    mako
    hyprpicker

    networkmanagerapplet
    pavucontrol

    dolphin

    papirus-icon-theme
  ];

  fonts = {
    packages = with pkgs; [
      nerd-fonts.fira-code
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
