{
  description = "NixOS configuration for nix-lab LXC";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    tiponero = {
      url = "github:tiponero/tiponero-core";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, tiponero }: {
    nixosConfigurations.nix-lab = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit tiponero; };
      modules = [
        ./configuration.nix
      ];
    };
  };
}
