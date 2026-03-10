{ config, pkgs, ... }: {
  networking = {
    hostName = "nix-lab";
    useDHCP = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 80 3000 18080 18081 18082 18083 ];
    };
  };

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };
}

