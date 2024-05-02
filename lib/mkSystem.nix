{ self, ... } @ inputs: name: system: inputs.nixpkgs.lib.nixosSystem (
  {
    inherit system;
    specialArgs = { inherit inputs self; };
    modules = [
      "${self}/hosts/${name}/system.nix"
      "${self}/hosts/${name}/home-manager.nix"
      inputs.home-manager.nixosModule
    ];
  }
)
