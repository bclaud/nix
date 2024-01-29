{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprwm-contrib= {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };


    unison-nix = {
      url = "github:ceedubs/unison-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = { nixpkgs, home-manager, hyprland, hyprwm-contrib, unison-nix, ... }@inputs: let

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

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {

      inix = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; }; # Pass flake inputs to our config
        # > Our main nixos configuration file <
        pkgs = pkgsFor.x86_64-linux;
        modules = [
          ./hosts/inix 
          inputs.home-manager.nixosModules.default
        ];
      };
    };
  };
}
