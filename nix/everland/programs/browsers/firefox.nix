{ pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    
    profiles.default = {
      isDefault = true;
      
      settings = {
        # Privacy settings
        "privacy.trackingprotection.enabled" = true;
        "dom.security.https_only_mode" = true;
        "privacy.donottrackheader.enabled" = true;
        
        # Performance settings
        "browser.cache.disk.enable" = false;
        "browser.cache.memory.enable" = true;
        "browser.cache.memory.capacity" = 262144;
        
        # UI settings
        "browser.toolbars.bookmarks.visibility" = "always";
        "browser.startup.homepage" = "about:home";
        "browser.newtabpage.enabled" = true;
        
        # Download settings
        "browser.download.useDownloadDir" = false;
        "browser.download.always_ask_before_handling_new_types" = true;
      };

      # Extensions - commented out since NUR isn't available
      # extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
      #   ublock-origin
      #   bitwarden
      #   privacy-badger
      #   decentraleyes
      #   clearurls
      # ];

      bookmarks = {
        force = true;
        settings = [
          {
            name = "Development";
            bookmarks = [
              {
                name = "GitHub";
                url = "https://github.com";
              }
              {
                name = "NixOS Manual";
                url = "https://nixos.org/manual/nixos/stable/";
              }
              {
                name = "Home Manager Options";
                url = "https://nix-community.github.io/home-manager/options.html";
              }
            ];
          }
        ];
      };
    };
  };
}