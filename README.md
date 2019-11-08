# PwnBoot
An Open-Source Work-In-Progress iOS 6 Jailbreak Using a Custom Ramdisk

***

# What this Tool Can Do

This tool allows you to Verbose Boot a SSH Ramdisk, and hence get full RootFS access on your device. From here you can modify the RootFS in any way you please.



# How To Use

1. Set up a Window 7 Virtual Machine (this is a requirement)
2. Download the latest release of PwnBoot (found on the Releases Page) to your Windows 7 VM
3. Connect your iPhone2,1 to your VM in DFU mode
4. Run `PwnBootCLI` to see a list of uses of PwnBoot

# Common Uses

1. Booting a Custom SSH Ramdisk on your iPhone2,1 (`PwnBootCLI iPhone2,1 -b`)
2. VERBOSE BOOTING a Custom SSH Ramdisk on your iPhone2,1 (`PwnBootCLO iPhone2,1 -vb`)
3. Forwarding the resulting SSH connection over USB (`PwnBootCLI iPhone2,1 -j`) (This must be run AFTER booting the SSH Ramdisk using the above commands)

# How to Boot a Custom SSH Ramdisk and get full filesystem access on your iPhone2,1

1. `PwnBootCLI iPhone2,1 -vb`
2. `PwnBootCLI iPhone2,1 -j`
3. `C:/PwnBoot/itunnel_mux --lport 2022`
4. SSH into the device **in a new CMD window** (root@127.0.0.1 over port 2022 with password `alpine`). Don't close itunnel_mux window until you're done.
5. Over SSH run `mount.sh` and you will now be able to access the full root filesystem of your device

# Future Plans for this tool

- Support **FULLY JAILBREAKING YOUR DEVICE** (Cydia, etc.) (Just requires more kernel patches by me)
- Support more devices (iPhone 4 tethered, iPhone 3G untethered, etc.)
- Add custom bootlogos
- Utilize the `launchd.conf` untether bug for some cool stuff :)
