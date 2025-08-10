{ pkgs, ... }:

{
  programs.chromium = {
    enable = true;
    
    extensions = [
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # uBlock Origin
      { id = "nngceckbapebfimnlniiiahkandclblb"; } # Bitwarden
      { id = "pkehgijcmpdhfbdbbnkijodmdjhbjlgp"; } # Privacy Badger
      { id = "fihnjjcciajhdojfnbdddfaoknhalnja"; } # I don't care about cookies
    ];

    commandLineArgs = [
      "--enable-features=VaapiVideoDecoder"
      "--use-gl=egl"
      "--enable-zero-copy"
      "--disable-features=UseChromeOSDirectVideoDecoder"
    ];
  };
}