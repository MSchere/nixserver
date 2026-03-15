{ config, pkgs, tiponero, ... }:

let
  secrets = import /etc/nixos/secrets.nix;
  tiponeroPkg = tiponero.packages.${pkgs.system}.default;
in {
  users.users.tiponero = {
    isSystemUser = true;
    group = "tiponero";
    home = "/var/lib/tiponero";
    createHome = true;
  };
  users.groups.tiponero = {};

  systemd.services.tiponero = {
    description = "Tiponero - Monero donation platform";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" "monero-wallet-rpc.service" ];
    wants = [ "monero-wallet-rpc.service" ];
    serviceConfig = {
      Type = "simple";
      User = "tiponero";
      Group = "tiponero";
      WorkingDirectory = "/var/lib/tiponero";
      ExecStart = "${tiponeroPkg}/bin/tiponero";
      Restart = "on-failure";
      RestartSec = 10;
    };
    environment = {
      PORT = "3001";
      DATABASE_PATH = "/var/lib/tiponero/tiponero.db";
      MONERO_RPC_URL = "http://127.0.0.1:18083/json_rpc";
      MONERO_RPC_USER = secrets.moneroRpcUser;
      MONERO_RPC_PASSWORD = secrets.moneroRpcPassword;
      ADMIN_USERNAME = secrets.tiponeroAdminUser;
      ADMIN_PASSWORD = secrets.tiponeroAdminPassword;
      SESSION_SECRET = secrets.tiponeroSessionSecret;
      FIAT_CURRENCY = "EUR";
      BASE_URL = secrets.tiponeroBaseUrl;
    };
  };

  services.nginx.virtualHosts."tiponero" = {
    listen = [{ addr = "0.0.0.0"; port = 8080; }];
    locations."/" = {
      proxyPass = "http://127.0.0.1:3001";
      proxyWebsockets = true;
    };
  };
}
