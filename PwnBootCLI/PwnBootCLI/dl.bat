@echo off

echo.
echo.
echo Downloading wget
mkdir "C:/PwnBoot"
powershell.exe -Command (new-object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/iBoot32/JailbreakTool/master/wget.exe', 'C:/PwnBoot/wget.exe') 2> nul
cd "C:/PwnBoot"

echo Downloading 7z.exe
wget.exe https://raw.githubusercontent.com/iBoot32/JailbreakTool/master/7z.exe 2> nul

echo Downloading 7z.dll
wget.exe https://raw.githubusercontent.com/iBoot32/JailbreakTool/master/7z.dll 2> nul

echo Downloading Binaries
wget.exe https://github.com/iBoot32/JailbreakTool/archive/master.zip 2> nul

echo Unzipping binaries
7z.exe x master.zip > nul 2>&1
cd JailbreakTool-master
move * .. > nul 2>&1
move otherfiles .. > nul 2>&1
cd ..
del master.zip
del /f /s /q "JailbreakTool-master" 1>nul && rmdir /s /q "JailbreakTool-master" 
exit