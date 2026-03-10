{ config, pkgs, ... }:
let
  secrets = import ./secrets.nix;
in {
  services.monero = {
    enable = true;
    rpc = {
      address = "0.0.0.0";
      user = secrets.moneroRpcUser;
      password = secrets.moneroRpcPassword;
    };
    extraConfig = ''
      prune-blockchain=1
      db-sync-mode=safe
      confirm-external-bind=1
    '';
  };

  systemd.services.monero-wallet-rpc = {
    description = "Monero Wallet RPC";
    after = [ "monero.service" ];
    wants = [ "monero.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      User = "monero";
      WorkingDirectory = "/var/lib/monero";
      ExecStart = ''
        ${pkgs.monero-cli}/bin/monero-wallet-rpc \
          --rpc-bind-ip=0.0.0.0 \
          --rpc-bind-port=18083 \
          --rpc-login=${secrets.moneroRpcUser}:${secrets.moneroRpcPassword} \
          --daemon-address=127.0.0.1:18081 \
          --daemon-login=${secrets.moneroRpcUser}:${secrets.moneroRpcPassword} \
          --wallet-file=/var/lib/monero/wallet \
          --password-file=/var/lib/monero/wallet.passwd \
          --non-interactive \
          --confirm-external-bind
      '';
      Restart = "on-failure";
    };
  };
}

