{
  description = "Your new nix config";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprwm-contrib= {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors.url = "github:misterio77/nix-colors";

  };

  outputs = { nixpkgs, home-manager, hyprwm-contrib, sops-nix, ... }@inputs: let

    systems = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];

    pkgsFor = nixpkgs.lib.genAttrs systems (system: import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      allowUnfreePredicate = (_: true);
      overlays = import ./overlays { inherit inputs; };
    });

    forEachSystem = f: nixpkgs.lib.genAttrs systems (system: f pkgsFor.${system});

  in {
    packages = forEachSystem (pkgs: import ./pkgs { inherit pkgs; });
    pkgs = forEachSystem (pkgs: pkgs);

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {

      inix = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; }; # Pass flake inputs to our config
        # > Our main nixos configuration file <
        pkgs = pkgsFor.x86_64-linux;
        modules = [
          ./hosts/inix 
          home-manager.nixosModules.default
          sops-nix.nixosModules.sops
        ];
      };
    };

    templates = {
      elixir = {
        path = ./templates/elixir;
        description = "simple elixir template";
      };
    };
  };
}
