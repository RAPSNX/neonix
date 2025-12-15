# self is an explicit not a global parameter
self:
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.programs.neonix = {
    enable = lib.mkEnableOption "neonix";
  };
  config = lib.mkIf config.programs.neonix.enable {
    home.packages = [ self.packages.${pkgs.stdenv.hostPlatform.system}.default ];
  };
}
