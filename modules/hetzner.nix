## a common hardware-configuration.nix for our hetzner servers

{ config, lib, pkgs, modulesPath, ... }:
{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot.initrd.availableKernelModules = [ "ata_piix" "virtio_pci" "virtio_scsi" "xhci_pci" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/sda1";
    fsType = "ext4";
  };

  swapDevices = [ ];

  boot.loader.grub = {
    enable = true;
    version = 2;
    devices = [ "/dev/sda" ];
  };

  networking = {
    useDHCP = false;
    interfaces.ens3 = {
      useDHCP = true;
      #ipv6.addresses  ## should be set for each host
    };
    defaultGateway6 = {
      address = "fe80::1";
      interface = "ens3";
    };
  };

  users.users.root = {
    openssh.authorizedKeys.keys = [
      ## J03
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDW+YfsFtRz1h/0ubcKU+LyGfxH505yUkbWa5VtRFNWF2fjTAYGj6o5M4dt+fv1h370HXvvOBtt8sIlWQgMsD10+9mvjdXWhTcpnYPx4yWuyEERE1/1BhItrog6XJKAedbCDpQQ+POoewouiHWVAUfFByPj5RXuE8zKUeIEkGev/QKrKTLnTcS8zFs/yrokf1qYYR571B3U8IPDjpV/Y1GieG3MSNaefIMCwAAup1gPkUA0XZ4A1L7NdEiUEHlceKVu9eYiWUM+wDRunBXnLHubeGyP8KmBA7PNKgml3WWRNTZjqNQk4u9Bl+Qea5eCkD8KI257EqgXYXy0QBWNyF8X j03@l302"
      ## Winzlieb
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC3iUaE0wXfRfG48bLs3pCSRi3TqH8a9yuh0JfycRv/Wai+hwJ/VopqxvN+L+NVFSEGWeTAvQRDzJZhgVgP29zrWALGnuvGCSi6jeuzhm57R2ebZcnXkS3fYiowfV34BJSmYkzM3mIg8ujxIp6R/7LqCx+7IKZfLqjeWAMFzVvZcF2aIs2OP59EWJYJN8fKSXpoMk6elnDwvxHD6zzNMhLu+n/7vKJccUoqJaEaPMd/AWyBi2aFn3C1btkFQ5fT8bO9Ob9t5eh97cyny9MAvlxPIHOR/xbJ80WMgVeqst/rb8atafe4UJVf643lzmzlbyxErBGAaeTY3p9Yc93QdvVP basti@basti-ThinkPad-T530"
    ];
  };

  services.openssh = {
    enable = true;
    permitRootLogin = "prohibit-password";
  };
}
