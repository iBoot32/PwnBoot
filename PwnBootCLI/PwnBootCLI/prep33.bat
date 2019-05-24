@echo off


echo Downloading iBSS, iBEC, DeviceTree, and Kernelcache. (This could take a while)
echo.
partialzip "http://appldnld.apple.com/iOS7/031-1864.20131114.P3wE4/iPhone3,3_7.0.4_11B554a_Restore.ipsw" "Firmware/dfu/iBSS.n92ap.RELEASE.dfu" ibss.dfu
partialzip "http://appldnld.apple.com/iOS7/031-1864.20131114.P3wE4/iPhone3,3_7.0.4_11B554a_Restore.ipsw" "Firmware/dfu/iBEC.n92ap.RELEASE.dfu" ibec.dfu
partialzip "http://appldnld.apple.com/iOS7/031-1864.20131114.P3wE4/iPhone3,3_7.0.4_11B554a_Restore.ipsw" "Firmware/all_flash/all_flash.n92ap.production/DeviceTree.n92ap.img3" devicetree.img3
partialzip "http://appldnld.apple.com/iOS7/031-1864.20131114.P3wE4/iPhone3,3_7.0.4_11B554a_Restore.ipsw" "kernelcache.release.n92" kern.n92
partialzip "http://appldnld.apple.com/iOS7/031-1864.20131114.P3wE4/iPhone3,3_7.0.4_11B554a_Restore.ipsw" "058-1056-002.dmg" ramdisk.dmg

::
::First we patch all the components (except devicetree) using ssh_rd's patches, and for the ramdisk untar ssh_rd's ssh.tar
::

::Ramdisk
xpwntool "ramdisk.dmg" "decramdisk.dmg" -iv 5d018cef7bd97e01d3f461c41a9ded19 -k 9638e18a42cbe483bd8e6794c18807141923e53c61cf5a2ae3f1238ae3e2723d
hfsplus "decramdisk.dmg" grow 35000000
hfsplus "decramdisk.dmg" untar "ssh.tar" "/"
xpwntool "decramdisk.dmg" "encramdisk.dmg" -t "ramdisk.dmg" -iv 5d018cef7bd97e01d3f461c41a9ded19 -k 9638e18a42cbe483bd8e6794c18807141923e53c61cf5a2ae3f1238ae3e2723d

::iBSS
xpwntool ibss.dfu ibss.dfu.dec -iv 6fb11b195173e9cb5326df526098be97 -k 6c9942847b842a6cb169e42f1e9405ff86a6d9aa522708ef7087b28ee71b223f
fuzzy_patcher --patch --orig ibss.dfu.dec --patched ibss.dfu.dec.p --delta ibss.ssh.patch
move ibss.dfu ibss.dfu.orig
xpwntool ibss.dfu.dec.p ibss.dfu -t ibss.dfu.orig -iv 6fb11b195173e9cb5326df526098be97 -k 6c9942847b842a6cb169e42f1e9405ff86a6d9aa522708ef7087b28ee71b223f

::iBEC
xpwntool ibec.dfu ibec.dfu.dec -iv a97a1bb44a7b1b0d3d66693b31b331ec -k a96a1e4bcfff0652a09524c2827362b3979ffc5eb0e17f17cc8dffc0488c0c94
fuzzy_patcher --patch --orig ibec.dfu.dec --patched ibec.dfu.dec.p --delta ibec.ssh.patch
move ibec.dfu ibec.dfu.orig
xpwntool ibec.dfu.dec.p ibec.dfu -t ibec.dfu.orig -iv a97a1bb44a7b1b0d3d66693b31b331ec -k a96a1e4bcfff0652a09524c2827362b3979ffc5eb0e17f17cc8dffc0488c0c94

::Kernelcache
xpwntool kern.n92 kern.n92.dec -iv ba71ffa1cf3d22a39ca6d5161bb315c7 -k f4a4bca780761ccb3424a3a206d243f17498d5a3fdd990a1861da9f1acf75ef8
fuzzy_patcher --patch --orig kern.n92.dec --patched kern.n92.dec.p --delta kern.ssh.patch
move kern.n92 kern.n92.orig
xpwntool kern.n92.dec.p kern.n92 -t kern.n92.orig -iv ba71ffa1cf3d22a39ca6d5161bb315c7 -k f4a4bca780761ccb3424a3a206d243f17498d5a3fdd990a1861da9f1acf75ef8

echo Connect your iPhone3,3 in DFU mode to continue
echo.
ufd.exe
timeout /t 5 /nobreak > NUL

echo Exploiting with limera1n
irec -e
timeout /t 5 /nobreak > NUL
irecovery -f "ibss.dfu"
timeout /t 5 /nobreak > NUL
irecovery -f "ibec.dfu"
timeout /t 5 /nobreak > NUL
rdetector.exe
timeout /t 5 /nobreak > NUL
irecovery -f "devicetree.img3"
irecovery -c devicetree
timeout /t 5 /nobreak > NUL
irecovery -f "encramdisk.dmg"
irecovery -c ramdisk 0x90000000
timeout /t 5 /nobreak > NUL
irecovery -f "kern.n92"
timeout /t 5 /nobreak > NUL
irecovery -c bootx