@echo off


echo Downloading iBSS, iBEC, DeviceTree, and Kernelcache. (This could take a while)
echo.
partialzip "http://appldnld.apple.com/iOS5.1.1/041-4347.20120427.o2yov/iPhone2,1_5.1.1_9B206_Restore.ipsw" "Firmware/dfu/iBEC.n88ap.RELEASE.dfu" "ibec.dfu"
partialzip "http://appldnld.apple.com/iOS5.1.1/041-4347.20120427.o2yov/iPhone2,1_5.1.1_9B206_Restore.ipsw" "Firmware/dfu/iBSS.n88ap.RELEASE.dfu" "ibss.dfu"
partialzip "http://appldnld.apple.com/iOS5.1.1/041-4347.20120427.o2yov/iPhone2,1_5.1.1_9B206_Restore.ipsw" "kernelcache.release.n88" "kern.n88"
partialzip "http://appldnld.apple.com/iOS5.1.1/041-4347.20120427.o2yov/iPhone2,1_5.1.1_9B206_Restore.ipsw" "Firmware/all_flash/all_flash.n88ap.production/DeviceTree.n88ap.img3" "devicetree.img3"
partialzip "http://appldnld.apple.com/iOS5.1.1/041-4347.20120427.o2yov/iPhone2,1_5.1.1_9B206_Restore.ipsw" "038-4349-020.dmg" "ramdisk.dmg"

::
::First we patch all the components (except devicetree) using ssh_rd's patches, and for the ramdisk untar ssh_rd's ssh.tar
::

::Ramdisk
echo.
echo Preparing Ramdisk...
xpwntool ramdisk.dmg ramdisk.dmg.dec -iv 26ec90f47073acaa0826c55bdeddf4bb -k 7af575ca159ba58b852dfe1c6f30c68220a7a94be47ef319ce4f46ba568b7a81 >nul 2>&1
hfsplus ramdisk.dmg.dec grow 45000000 >nul 2>&1
hfsplus ramdisk.dmg.dec untar ssh.tar "/" >nul 2>&1
move ramdisk.dmg ramdisk.dmg.orig >nul 2>&1
xpwntool ramdisk.dmg.dec ramdisk.dmg -t ramdisk.dmg.orig -k 7af575ca159ba58b852dfe1c6f30c68220a7a94be47ef319ce4f46ba568b7a81 -iv 26ec90f47073acaa0826c55bdeddf4bb >nul 2>&1

::iBSS
echo Preparing iBSS...
xpwntool ibss.dfu ibss.dfu.dec -iv 0cbb6ea94192ba4c4f215d3f503279f6 -k 36782ee3df23e999ffa955a0f0e0872aa519918a256a67799973b067d1b4f5e0 >nul 2>&1
fuzzy_patcher --patch --orig ibss.dfu.dec --patched ibss.dfu.dec.p --delta ibss.patch >nul 2>&1
move ibss.dfu ibss.dfu.orig >nul 2>&1
xpwntool ibss.dfu.dec.p ibss.dfu -t ibss.dfu.orig -iv 0cbb6ea94192ba4c4f215d3f503279f6 -k 36782ee3df23e999ffa955a0f0e0872aa519918a256a67799973b067d1b4f5e0  >nul 2>&1 

::iBEC
echo Preparing iBEC
xpwntool ibec.dfu ibec.dfu.dec -iv 1fe15472e85b169cd226ce18fe6de524 -k 677be330d799ffafad651b3edcb34eb787c2d6c56c07e6bb60a753eb127ffa75 >nul 2>&1
fuzzy_patcher --patch --orig ibec.dfu.dec --patched ibec.dfu.dec.p --delta ibec.verbose.patch >nul 2>&1
move ibec.dfu ibec.dfu.orig >nul 2>&1
xpwntool ibec.dfu.dec.p ibec.dfu -t ibec.dfu.orig -iv 1fe15472e85b169cd226ce18fe6de524 -k 677be330d799ffafad651b3edcb34eb787c2d6c56c07e6bb60a753eb127ffa75 >nul 2>&1

::Kernelcache
echo Preparing Kernelcache
xpwntool kern.n88 kern.n88.dec -iv 0dc795a64cb411c21033f97bceb96546 -k 0cc1dcb2c811c037d6647225ec48f5f19e14f2068122e8c03255ffe1da25dec3 >nul 2>&1
fuzzy_patcher --patch --orig kern.n88.dec --patched kern.n88.dec.p --delta kern.n88.patch >nul 2>&1
move kern.n88 kern.n88.orig >nul 2>&1
xpwntool kern.n88.dec.p kern.n88 -t kern.n88.orig -iv 0dc795a64cb411c21033f97bceb96546 -k 0cc1dcb2c811c037d6647225ec48f5f19e14f2068122e8c03255ffe1da25dec3 >nul 2>&1
echo.

echo Connect your iPhone2,1 in DFU mode to continue
echo.
ufd.exe
timeout /t 5 /nobreak > NUL

echo.
echo Exploiting with limera1n
irec -e
timeout /t 5 /nobreak > NUL
echo.
echo Sending iBSS
irecovery -f "ibss.dfu"
timeout /t 5 /nobreak > NUL
echo Sending iBEC
irecovery -f "ibec.dfu"
timeout /t 5 /nobreak > NUL
rdetector.exe
timeout /t 5 /nobreak > NUL
echo Sending DeviceTree
irecovery -f "devicetree.img3"
irecovery -c devicetree
timeout /t 5 /nobreak > NUL
echo Sending Ramdisk
irecovery -f "ramdisk.dmg" 
irecovery -c ramdisk 0x90000000
timeout /t 5 /nobreak > NUL
echo Sending Kernelcache
irecovery -f "kern.n88
timeout /t 5 /nobreak > NUL
echo Booting kernelcache
irecovery -c bootx