{ config, lib, pkgs, modulesPath, ... }:

let
  sshPort = 41298;
  hostName = "nixos";
  stateVersion = "24.05";
  sshAuthorizedKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFNENHqsxWyb9JOsuK+Tj3eELtIUu17Mb1tSb6urTC88";
in {
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  system.stateVersion = stateVersion;

  networking = {
    inherit hostName;
    networkmanager.enable = true;

    firewall = {
      enable = true;
    };
  };

  users.users.nixos = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      sshAuthorizedKey
    ];
  };

  services.openssh = {
    enable = true;
    ports = [ sshPort ];
    openFirewall = true;
    settings = {
      X11Forwarding = false;
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  security.pam = {
    sshAgentAuth = {
      enable = true;
      authorizedKeysFiles = [ "/etc/ssh/authorized_keys.d/%u" ];
    };
  };

  # Hardware configuration

  boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  swapDevices = [
    { device = "/dev/disk/by-label/swap"; }
  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp1s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
