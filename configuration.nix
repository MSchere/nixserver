{ config, pkgs, lib, ... }: {
  imports = [
    ./hardware.nix
    ./networking.nix
    ./webserver.nix
    ./monero.nix
    ./tiponero.nix
  ];

  time.timeZone = "Europe/Madrid";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.systemPackages = with pkgs; [
    vim htop git curl wget nodejs_22 pnpm openssl python3
  ];

  system.stateVersion = "24.11";
}

