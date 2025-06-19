# nix config file
{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./modules/nixvim.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_6_14;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # graphics
  hardware.graphics.enable = true;
  boot.initrd.kernelModules = ["amdgpu"];
  services.xserver.videoDrivers = ["amdgpu"];
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Dubai";
  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;
  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # configure syncthing service (starts on boot and runs in background)
  services.syncthing = {
    enable = true;
    openDefaultPorts = true; # Open ports in the firewall for Syncthing
    user = "alfin";
    dataDir = "/home/alfin";
    configDir = "/home/alfin/.config/syncthing";
  };

  # configure jellyfin media server
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    user = "alfin";
    dataDir = "/home/alfin/Jellyfin";
    cacheDir = "/home/alfin/Jellyfin/.cache";
  };
  systemd.services.jellyfin.wantedBy = lib.mkForce []; # do not start jellyfin on boot

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.alfin = {
    isNormalUser = true;
    description = "alfin";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };
  programs.ssh.startAgent = true;

  # pretty outputs for nix commands
  programs.nh = {
    enable = true;
    clean.enable = true;
    flake = "/home/alfin/nixconfig";
  };

  # gaming
  programs.gamemode.enable = true;
  programs.steam = {
    enable = true;
  };

  # bash is needed for system scripts to work. switch to fish for interactive shell
  programs.fish = {
    enable = true;
  };

  programs.bash = {
    interactiveShellInit = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };

  # Install firefox.
  programs.firefox = {
    enable = true;
    policies = {
      ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };
      };
      #Bitwarden
      ExtensionSettings = {
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
          installation_mode = "force_installed";
        };
      };
    };
  };
  programs.nix-ld = {
    enable = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # system packages
  environment.systemPackages = with pkgs; [
    #avr
    pkgsCross.avr.buildPackages.gcc

    # software
    lutris
    librewolf
    protonup-qt
    wineWowPackages.stable
    winetricks
    qbittorrent
    vim
    tor-browser-bundle-bin
    mpv
    cargo
    rustc
    signal-desktop
    fooyin
    protonvpn-gui
    gtkterm
    screen
    gamescope

    # KDE
    kdePackages.kcalc # Calculator
    kdePackages.ksystemlog # KDE SystemLog Application
    kdePackages.partitionmanager # Manage the disk devices, partitions and file systems on your computer
    hardinfo2 # System information and benchmarks for Linux systems
    haruna # Open source video player built with Qt/QML and libmpv
    wayland-utils # Wayland utilities

    # misc
    wget
    gcc
    gnumake
    unzip
    rocmPackages.clr.icd
    clinfo
    fastfetch
    unrar

    # nixvim dependencies (formatter/lsps)
    alejandra
    rustfmt
    astyle
  ];

  # install fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  programs.git = {
    enable = true;
    config = {
      user.name = "Alfin";
      user.email = "alfinbaiju@proton.me";
      init.defaultBranch = "main";
    };
  };

  # do not change this
  system.stateVersion = "25.05";
}
