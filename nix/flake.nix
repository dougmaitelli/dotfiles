{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    nixos-wsl.url = "github:nix-community/nixos-wsl/release-25.11";
    vscode-server.url = "github:nix-community/nixos-vscode-server";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/clients
        ./hosts/clients/laptop/configuration.nix
        inputs.home-manager.nixosModules.default
      ];
    };

    nixosConfigurations.wsl = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/clients
        ./hosts/clients/wsl/configuration.nix
        inputs.nixos-wsl.nixosModules.wsl
        inputs.vscode-server.nixosModules.default
        inputs.home-manager.nixosModules.default
      ];
    };
  };
}
