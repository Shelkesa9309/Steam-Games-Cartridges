# Disclaimer

This project is a hobby experiment and is not an official Steam product.

Automatic launching depends on your operating system settings and security policies. Some systems may require additional configuration for automounting drives or allowing scripts to run automatically.

Always be careful when executing scripts from removable storage. Only use cartridges you trust. <br>
**!!! Anyone with physical access to your PC can create a launch script on their drive and plug it in and it WILL be executed !!!**



# Steam Games Cartridges

Physical game cartridges for your Steam library using 2.5" SATA SSDs.

Turn your digital Steam games into something that feels physical: insert a cartridge, and your PC automatically detects it and launches the configured game or action.

Each cartridge is a simple storage device containing a small launcher script. When inserted, the system detects the cartridge and executes the script file the drive. 
Launching a Steam game, opening a game's details page, or running a custom command.

## Quickstart
### Linux

Clone the repository:

```bash
git clone https://github.com/LewdM3at/Steam-Games-Cartridges.git
```
Enter the project directory:
```bash
cd Steam-Games-Cartridges
```
Run the installer:
```bash
sudo ./setup-linux.sh
```
The installer will install the required udev rule, systemd service, and launcher helper.

To remove the installation:
```bash
sudo ./uninstall-linux.sh
```

### Windows

Clone the repository:
```bash
git clone https://github.com/LewdM3at/Steam-Games-Cartridges.git
```
Or download the repo:
1. Click Code → Download ZIP
2. Extract it
   
Enter the project directory:
```bash
cd Steam-Games-Cartridges
```
Run the installer:
```bash
.\setup-windows.ps1
```
The installer will create the background cartridge monitor using Windows Task Scheduler.

If PowerShell blocks script execution, run:
```bash
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```
and run the installer again.

To remove the installation:
```bash
.\uninstall-windows.ps1
```

## Supported Storage

The project is designed around **2.5" SATA SSDs**.

However, the same concept may work with other storage devices such as:

- SD cards
- USB flash drives
- External HDDs
- Other removable storage

Compatibility with other storage types is **not guaranteed** and depends on your operating system, filesystem, automount configuration, and hardware.

## How It Works

Each cartridge contains a launcher script (launch.sh/launch.ps1) that will be executed by the helpers (depending on OS).
Configure these scripts to whatever you need with Steam URL Protocol.

### Linux

The Linux version uses three components:

- **udev rule**<br>
The udev rule detects when a new storage partition is connected.<br>
Its only job is to notify systemd that a game cartridge may have been inserted.<br>
It does not execute the cartridge directly.<br>

- **systemd service**<br>
A systemd template service is used to handle cartridge launches.<br>
The template allows the same service to work with any inserted device.<br>
The service starts the launcher helper and passes the detected device name.<br>

- **cartridge-launcher-helper**<br>
The helper script waits for the desktop environment to mount the drive, then searches the cartridge at rool level for: `launch.sh` <br>
If found, it executes the script.<br>
Example cartridge:<br>
SSD<br>
└── launch.sh<br>
└── SteamLibrary<br>
The contents of `launch.sh` decide what happens next.

---

#### Windows

The Windows version uses two components:


- **Task Scheduler**<br>
The installer creates a scheduled task that starts the cartridge monitor when the user logs in.<br>
The task keeps the monitor running silently in the background.<br>
- **cartridge-monitor.ps1**<br>
The PowerShell monitor watches for newly inserted storage devices.<br>
When a new drive is detected, it checks the root of the cartridge for: `launch.ps1` <br>
If found, it executes the script.<br>
Example cartridge:<br>
SSD<br>
└── launch.ps1<br>
└── SteamLibrary<br>
The contents of `launch.ps1` decide what happens next.
