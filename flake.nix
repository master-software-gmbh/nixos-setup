{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11-small";
    utilities.url = "github:master-software-gmbh/nixos-utilities";
  };

  outputs = { self, nixpkgs, utilities }: {
    nixosConfigurations = {
      default = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          utilities.nixosModules.system
          ({ config, pkgs, ... }: {
            modules.system = {
              sshPort = 41298;
              hostName = "nixos";
              stateVersion = "24.05";
              sshAuthorizedKeys = [
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFNENHqsxWyb9JOsuK+Tj3eELtIUu17Mb1tSb6urTC88"
              ];
            };
          })
        ];
      };
    };
  };
}
