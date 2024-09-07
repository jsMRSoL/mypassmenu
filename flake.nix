{
  description = "My passmenu script customized for my preferred dependencies";

  # inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs }:
      let
        system = "x86_64-linux";
        pkgs = import nixpkgs { inherit system; };
        my-name = "mypassmenu";
        my-buildInputs = with pkgs; [ ydotool wmenu ];
        my-script = (pkgs.writeScriptBin my-name (builtins.readFile ./mypassmenu.sh)).overrideAttrs(old: {
          buildCommand = "${old.buildCommand}\n patchShebangs $out";
        });
      in rec {
        defaultPackage = packages.my-script;
        packages.my-script = pkgs.symlinkJoin {
          name = my-name;
          paths = [ my-script ] ++ my-buildInputs;
          buildInputs = [ pkgs.makeWrapper ];
          postBuild = "wrapProgram $out/bin/${my-name} --prefix PATH : $out/bin";
        };
      };
}
