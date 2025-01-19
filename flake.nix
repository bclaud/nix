{
  description = "Your new nix config";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprwm-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";

    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors.url = "github:misterio77/nix-colors";

  };

  outputs =
    {
      nixpkgs,
      home-manager,
      hyprwm-contrib,
      sops-nix,
      nixos-wsl,
      ...
    }@inputs:
    let

      systems = [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];

      expPkgs = import nixpkgs {
          localSystem = {
            gcc.arch = "tigerlake";
            gcc.tune = "tigerlake";
            system = "x86_64-linux";
          };
          config.allowUnfree = true;
          allowUnfreePredicate = (_: true);
          overlays = import ./overlays { inherit inputs; };
      };

      pkgsFor = nixpkgs.lib.genAttrs systems (
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          config.cudaSupport = true;
          allowUnfreePredicate = (_: true);
          config.permittedInsecurePackages = [
            "electron-27.3.11"
          ];
          overlays = import ./overlays { inherit inputs; };
        }
      );

      forEachSystem = f: nixpkgs.lib.genAttrs systems (system: f pkgsFor.${system});

    in
    {
      packages = forEachSystem (pkgs: import ./pkgs { inherit pkgs; });
      pkgs = forEachSystem (pkgs: pkgs);

      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = {

        inix = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          }; # Pass flake inputs to our config
          # > Our main nixos configuration file <
          pkgs = pkgsFor.x86_64-linux;
          modules = [
            ./hosts/inix
            home-manager.nixosModules.default
            sops-nix.nixosModules.sops
          ];
        };

        wsl = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };

          pkgs = pkgsFor.x86_64-linux;
          modules = [
            ./hosts/wsl
            nixos-wsl.nixosModules.wsl
            home-manager.nixosModules.default
            sops-nix.nixosModules.sops
          ];

        };
      };

      formatter = forEachSystem (pkgs: pkgs.nixfmt-rfc-style);

      templates = {
        elixir = {
          path = ./templates/elixir;
          description = "simple elixir template";
        };
      };
    };
}
