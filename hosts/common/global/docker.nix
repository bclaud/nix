{ config, lib, ... }:
let
  dockerEnabled = config.virtualisation.docker.enable;
in
{
  users.extraGroups.docker.members = lib.mkIf dockerEnabled [ "nclaud" ];
}
