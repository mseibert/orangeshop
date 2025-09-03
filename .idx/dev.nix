# To learn more about how to use Nix to configure your environment
# see: https://firebase.google.com/docs/studio/customize-workspace
let 
secrets = import ../.env;
in 
{ pkgs, ... }: {
  # Which nixpkgs channel to use.
  channel = "stable-24.05"; # or "unstable"
  
  # Use https://search.nixos.org/packages to find packages
  packages = [
    pkgs.nodejs_22  # Entspricht Node 24 aus dem devcontainer
    pkgs.pnpm      # Für package management
  ];

  # Sets environment variables in the workspace
  

  env = pkgs.lib.recursiveUpdate {
    TEST = "true";
  } secrets;
  
  idx = {
    # Search for the extensions you want on https://open-vsx.org/ and use "publisher.id"
    extensions = [
      "astro-build.astro-vscode"
      "unifiedjs.vscode-mdx"
      "dbaeumer.vscode-eslint"
      "esbenp.prettier-vscode"
      "bradlc.vscode-tailwindcss"
    ];
    
    # Enable previews
    previews = {
      enable = false;
      previews = {
        web = {
          command = ["pnpm" "run" "dev"];
          manager = "web";
          env = {
            PORT = "$PORT";
          };
        };
      };
    };
    
    # Workspace lifecycle hooks
    workspace = {
      # Runs when a workspace is first created
      onCreate = {
        install-deps = "pnpm install";
      };
      
      # Runs when the workspace is (re)started
      onStart = {
        dev-server = "pnpm dev";
      };
    };
  };
}