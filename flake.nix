{
  description = "Personal website — CV, blog, publications, projects";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = {
    self,
    nixpkgs,
  }: let
    systems = ["x86_64-linux" "aarch64-linux"];
    forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
  in {
    # The built site — a directory of static files, nothing else.
    # The homeserver flake consumes this as `inputs.website.packages.<system>.default`
    # and points nginx's `root` straight at the store path.
    packages = forAllSystems (pkgs: {
      default = pkgs.stdenvNoCC.mkDerivation {
        pname = "website";
        version = "0.1.0";
        src = ./.;

        nativeBuildInputs = [pkgs.zola];

        # Build into ./public first rather than straight into $out: zola refuses
        # to write into an existing non-empty directory without --force, and
        # --force means "delete the target", which is not something to point at
        # a store path.
        buildPhase = ''
          runHook preBuild
          zola build --output-dir public
          runHook postBuild
        '';

        installPhase = ''
          runHook preInstall
          cp -r public $out
          runHook postInstall
        '';
      };
    });

    # `nix develop` then `zola serve` for a live-reloading preview on :1111.
    devShells = forAllSystems (pkgs: {
      default = pkgs.mkShell {
        packages = [pkgs.zola];
      };
    });

    # `nix run` — preview without entering a shell.
    apps = forAllSystems (pkgs: {
      default = {
        type = "app";
        program = "${pkgs.writeShellScript "serve" "exec ${pkgs.zola}/bin/zola serve"}";
      };
    });

    formatter = forAllSystems (pkgs: pkgs.alejandra);
  };
}
