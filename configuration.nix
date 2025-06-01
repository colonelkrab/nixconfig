# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_6_13;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  #amdgpu
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];

  hardware.graphics.enable = true;

  boot.initrd.kernelModules = ["amdgpu"];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

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
  services.xserver.videoDrivers = ["amdgpu"];
  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.syncthing = {
    enable = true;
    openDefaultPorts = true; # Open ports in the firewall for Syncthing
    user = "alfin";
    dataDir = "/home/alfin";
    configDir = "/home/alfin/.config/syncthing";
  };

  services.jellyfin = {
    enable = true;
    openFirewall = true;
    user = "alfin";
    dataDir = "/home/alfin/Jellyfin";
    cacheDir = "/home/alfin/Jellyfin/.cache";
  };

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
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.alfin = {
    isNormalUser = true;
    description = "alfin";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [
      kdePackages.kate
      #  thunderbird
    ];
  };
  programs.ssh.startAgent = true;

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
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  nix.settings.experimental-features = ["nix-command" "flakes"];
  environment.systemPackages = with pkgs; [
    #avr
    pkgsCross.avr.buildPackages.gcc

    # software
    kitty
    lutris
    librewolf
    protonup-qt
    wineWowPackages.stable
    winetricks
    qbittorrent
    vim

    # misc
    wget
    gcc
    gnumake
    unzip
    rocmPackages.clr.icd
    clinfo
    fastfetch

    # nixvim
    alejandra
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  programs.steam = {
    enable = true;
  };
  programs.git = {
    enable = true;
    config = {
      user.name = "Alfin";
      user.email = "alfinbaiju@proton.me";
      init.defaultBranch = "main";
    };
  };
  programs.fish = {
    enable = true;
  };

  programs.nixvim = {
    enable = true;
    colorschemes.catppuccin.enable = true;
    keymaps = [
      {
        action = "<cmd>Telescope find_files<CR>";
        key = "ff";
      }
      {
        key = "<Up>";
        action = "";
      }
      {
        key = "<Down>";
        action = "";
      }

      {
        key = "<Left>";
        action = "";
      }

      {
        key = "<Right>";
        action = "";
      }
    ];
    plugins = {
      web-devicons.enable = true;
      nvim-autopairs.enable = true;
      telescope.enable = true;
      conform-nvim = {
        enable = true;
        settings = {
          format_on_save.lsp_format = "fallback";
          formatters_by_ft = {
            nix = ["alejandra"];
          };
        };
      };
      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          auto_install = true;
        };
      };
      lspkind.enable = true;
      lsp-lines.enable = true;
      lsp-signature.enable = true;

      lualine = {
        enable = true;
      };
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings.sources = [{name = "nvim_lsp";} {name = "path";} {name = "buffer";}];
      };
      lsp = {
        enable = true;
        inlayHints = true;
        servers = {
          nixd = {
            enable = true;
          };
        };
      };
    };
  };

  system.stateVersion = "25.05";
}
