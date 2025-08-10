{ pkgs, ... }:

{
  # GPG configuration
  programs.gpg = {
    enable = true;
    settings = {
      personal-cipher-preferences = "AES256 AES192 AES";
      personal-digest-preferences = "SHA512 SHA384 SHA256";
      personal-compress-preferences = "ZLIB BZIP2 ZIP Uncompressed";
      default-preference-list = "SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed";
      cert-digest-algo = "SHA512";
      s2k-digest-algo = "SHA512";
      s2k-cipher-algo = "AES256";
      charset = "utf-8";
      fixed-list-mode = true;
      no-comments = true;
      no-emit-version = true;
      keyid-format = "0xlong";
      list-options = "show-uid-validity";
      verify-options = "show-uid-validity";
      with-fingerprint = true;
      require-cross-certification = true;
      no-symkey-cache = true;
      use-agent = true;
    };
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
    pinentry.package = pkgs.pinentry-gtk2;
  };
  
  # SSH configuration
  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
    
    controlMaster = "auto";
    controlPath = "~/.ssh/master-%r@%n:%p";
    controlPersist = "10m";
    
    serverAliveInterval = 60;
    serverAliveCountMax = 3;
    
    extraConfig = ''
      # Security settings
      HostKeyAlgorithms ssh-ed25519,ssh-rsa
      KexAlgorithms curve25519-sha256@libssh.org,diffie-hellman-group16-sha512
      Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes256-ctr
      MACs hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com
    '';
  };

  # Security-related packages
  home.packages = with pkgs; [
    gnome-keyring
  ];
}