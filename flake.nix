{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    hyprland={
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprwm-contrib= {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    unison-nix.url = "github:ceedubs/unison-nix";
    unison-lang.follows = "nixpkgs";

  };

  outputs = { nixpkgs, home-manager, hyprland, hyprwm-contrib, unison-nix, ... }@inputs: let
    systems = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];

    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {

    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {

      inix = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; }; # Pass flake inputs to our config
        # > Our main nixos configuration file <
        modules = [
          ./nixos/inix/configuration.nix 
          inputs.home-manager.nixosModules.default
        ];
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {

      "nclaud@inix" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = { inherit inputs unison-nix; }; # Pass flake inputs to our config
        # > Our main home-manager configuration file <
        modules = [ 
          ./home-manager/home.nix
          hyprland.homeManagerModules.default
          {wayland.windowManager.hyprland.enable = true;}
         ];
      };
    };
  };
}
