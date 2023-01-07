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
      ## Francesco
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAEAQCuvNZDHAKFXCSzypX4tnukUCYPmtqvD5DlJzl5fLN0GvJqss3gg6tI+SJjYltNjnhHbnUBQpQRSMj+RfXf9EPVyAbHCA+r1ws31nXIehYKqdyzMdC2GdMqSKgLw4MwkF4AO32+bUFMTO4WOUqFLP3GQCjz277S67Y2FoWdiImGRw9VJPZT3pv41vSLay3XP7LCLw2y0ppisaRFu8JAwa9c1AU7a8qqMS5Bv8TVwzw7rzuD7/Ubg6dra74wAHMmvA1byP+H9teDplHUxAOvi6NTlZOmkdj+zK0GLhHd3/5RkgFqt7vN8L/IIXgbeym7Ddrv2OHKLVlmknIp8WvXA75M/fZEeTrQtTtTWZ2eDNcEmuGiPRq0wWxftSnvvzJWGLogtgpYF/qE0gGKi9BeWT8ggm1v6wNr36JrkyK5Pf+B9Dr0ePG8M+l5/Y2H2/8yMWfEobqm6hzwosCrU2A1KjAZIPOWdI9O1E8A0M5Deop2ZID3Rh0eDhpoNPPSlRMhhs2CW3b3C8y4GqY+tRGNKPpN0Vs2DRVtutaIqBSkcr3BapaAB96MGIQtT6WMbSW4uyjLy51x0n+AXtqYR+M0U4pFpX33kJuoUlgVSkPmEIVTK9dL2ZYSNEsnmHw0yupeecJp1PlKbzWiQ4voPjro1nmLH8sMzUEtTz9wIS5s6l/ucaQtQTtAmvQhwd2r/EXB1aBb3eE5NUD3lFNFTeOkF1RPIVA8D1AqoSqSzZo9qEBRV4xp5jFMgj1XhQBBov5ywK3rDMl2YSVOh1IMJvYVYSlIsGelRCuFhcJc0nNkh+xwjTuNVsdSAlF4ci7TLtn+YYw/U9bE1MRdnWZYid2f4h9VK8rXhfY89LrU2XNoheq4npq5PmZKLdpSXWL/GTiUQduxbe2uvs3RYhZhvZWKSw7R8rzh+Pq8i5kkb+cURq2zw89rNfyKJJIh2BJxjXBf/ZTzMkD3Y9UPSx9DKK79+3C2+m3rS6l6yDF2swVTzG6vODMzBb1TwHbOYbPA8gvb67wtrmQCkk6q6OCIzEBdyJNnXnXPrNb6huFuG8No45Ogkamb1XEJTnUuDIH8LUxuj8cog+Xpm2VNGDnl2kRbZM1MoTZp8PYzQi8lIq5i/Ofi20/pAgdl67PqGmhGb9yrYBT6s62IhNIA9hVeHao/a1FGdAuQGjdDQRnFCq14fsuRNQVkrT7SUZ32BpOq4PLikooP39lirS1gUT0Fnpvz+XmXRHorhrIW+hISz+AvLbX1HM76LI+Nl/EFFIZyZhxq4pGhzFqvAL7/ayGYsG3nbmo8sQC1RLZ7wSnbvQkMfqRfwCIFWT6NcUFVv9H2nBJ0kDilg2MhNNAQVbYWBbmJ2i9D"
    ];
  };

  services.openssh = {
    enable = true;
    permitRootLogin = "prohibit-password";
  };
}
