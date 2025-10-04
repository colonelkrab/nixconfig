{pkgs, ...}: let
  mpasmx-fhs = pkgs.buildFHSEnv {
    multiArch = true;
    name = "mpasm-fhs";
    targetPkgs = pkgs: [pkgs.pk2cmd];
    runScript = ''
      echo hi
    '';
  };
in {
  environment.systemPackages = [
    mpasmx-fhs
  ];
}
