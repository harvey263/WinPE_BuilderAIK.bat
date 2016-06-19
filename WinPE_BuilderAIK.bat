::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::\ \    / (_)_ _ | _ \ __| | _ )_  _(_) |__| |___ _ _    /_\ |_ _| |/ /::
:: \ \/\/ /| | ' \|  _/ _|  | _ \ || | | / _` / -_) '_|  / _ \ | || ' < ::
::  \_/\_/ |_|_||_|_| |___| |___/\_,_|_|_\__,_\___|_|   /_/ \_\___|_|\_\::
::HarveyTDixon2016::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:CONFIGAIK
cls
@echo off
ENDLOCAL
SET CURDIR=%~dp0\
title WinPE_BuilderAIK
SETLOCAL ENABLEDELAYEDEXPANSION
::-----------------------------------------------------------------------
"%WINDIR%\system32\cacls.exe" "%WINDIR%\system32\config\system" >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (echo Elevating... & GOTO UAC1) else (GOTO UAC2)
:UAC1
echo SET UAC = CreateObject^("Shell.Application"^) > "%TEMP%\uac.vbs"
echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%TEMP%\uac.vbs"
"%TEMP%\uac.vbs"
del /q /f "%TEMP%\uac.vbs" & exit /b
:UAC2
IF EXIST "%TEMP%\uac.vbs" (del /q /f "%TEMP%\uac.vbs")
pushd %CD% & CD /d %CURDIR%
::-----------------------------------------------------------------------
IF NOT EXIST "C:\Program Files\Windows AIK\Tools\PETools" ^
echo. & echo Windows 7 AIK does not exist. & echo. & pause & GOTO EOF
IF NOT EXIST "%CURDIR%\WinPE_AIK7-DRIVERS" md "%CURDIR%\WinPE_AIK7-DRIVERS"
IF NOT EXIST "%CURDIR%\WinPE_AIK7-FILES" md "%CURDIR%\WinPE_AIK7-FILES"
IF NOT EXIST "%CURDIR%\WinPE_AIK7-REG" md "%CURDIR%\WinPE_AIK7-REG"
IF NOT EXIST "%CURDIR%\WinPE_Temp" md "%CURDIR%\WinPE_Temp"
IF EXIST "%CURDIR%\WinPE_Temp\DELISOAIK.txt" del /q /f "%CURDIR%\WinPE_Temp\DELISOAIK.txt"
IF EXIST "%CURDIR%\WinPE_Temp\LISTVOLAIK.txt" del /q /f "%CURDIR%\WinPE_Temp\LISTVOLAIK.txt"
IF EXIST "%CURDIR%\WinPE_Temp\FORMATVOLAIK.txt" del /q /f "%CURDIR%\WinPE_Temp\FORMATVOLAIK.txt"
IF EXIST "%CURDIR%\WinPE_Temp\RegAddDirAIK.txt" del /q /f "%CURDIR%\WinPE_Temp\RegAddDirAIK.txt"
::-----------------------------------------------------------------------
echo ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
echo ³WinPE Builder AIK³
echo ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
echo ----------------------------
IF EXIST "C:\winpe_x86" (
SET WRKDIRSTAT=1 & echo ^(x^) Working directory exists
) else (
SET WRKDIRSTAT=0 & echo ^( ^) Working directory exists
)
IF EXIST "C:\winpe_x86\mount\windows" (
SET MOUNTSTAT=1 & echo ^(x^) Image is Mounted
) else (
SET MOUNTSTAT=0 & echo ^( ^) Image is Mounted
)
REG QUERY "HKLM\WinPE-AIK_HKCU" 2>nul >nul
IF %ERRORLEVEL%==0 (
SET REGSTAT1=1 & echo ^(x^) REG hive loaded "HKLM\WinPE-AIK_HKCU"
) else (
SET REGSTAT1=0
)
REG QUERY HKLM\WinPE-AIK_HKLM_SOFTWARE 2>nul >nul
IF %ERRORLEVEL%==0 (
SET REGSTAT2=1 & echo ^(x^) REG hive loaded "HKLM\WinPE-AIK_HKLM_SOFTWARE"
) else (
SET REGSTAT2=0
)
REG QUERY HKLM\WinPE-AIK_HKLM_SYSTEM 2>nul >nul
IF %ERRORLEVEL%==0 (
SET REGSTAT3=1 & echo ^(x^) REG hive loaded "HKLM\WinPE-AIK_HKLM_SYSTEM"
) else (
SET REGSTAT3=0
)
IF %REGSTAT1%==0 IF %REGSTAT2%==0 IF %REGSTAT3%==0 (
SET REGSTAT0=1 & echo ^( ^) REG hives loaded & GOTO ISOCHECKAIK
) else (
SET REGSTAT0=0
)

:ISOCHECKAIK
IF EXIST "C:\winpe_x86\winpe_x86.iso" (
echo ^(x^) ISO file exists
) else (
echo ^( ^) ISO file exists
)
echo ----------------------------
echo ----------------------------
echo [W] Create Working directory
echo [M] Mount/Unmount image
echo [F] Add FILES to image
echo [R] Load REG hives
echo [D] Add DRIVERS
echo [B] Batch mode
echo [I] Make ISO
echo [U] Make USB
echo [X] Exit
echo ----------------------------
echo.
choice /c WMFRDBIUX /N /M ">"
echo.
IF ERRORLEVEL 9 GOTO EOF
IF ERRORLEVEL 8 GOTO MAKEUSBAIK1
IF ERRORLEVEL 7 GOTO MAKEISOAIK1
IF ERRORLEVEL 6 GOTO BATCHMODEAIK
IF ERRORLEVEL 5 GOTO ADDDRIVERSAIK
IF ERRORLEVEL 4 GOTO LOADREGISTRYAIK
IF ERRORLEVEL 3 GOTO ADDFILESAIK
IF ERRORLEVEL 2 GOTO MOUNTUNMOUNTIMAGEAIK
IF ERRORLEVEL 1 GOTO CREATEDIRECTORYAIK1

:::::::::::::::::::::::::::::::::::::::
::|  \/  |__ _| |_____| | | / __| _ )::
::| |\/| / _` | / / -_) |_| \__ \ _ \::
::|_|  |_\__,_|_\_\___|\___/|___/___/::
:::::::::::::::::::::::::::::::::::::::
:MAKEUSBAIK1
title WinPE_BuilderAIK [Make USB]
IF NOT %WRKDIRSTAT%==1 echo WinPE working directory does not exist. & echo. & pause & GOTO CONFIGAIK
IF %MOUNTSTAT%==1 echo Cannot make USB, image is currently Mounted. & echo. & pause & GOTO CONFIGAIK
IF NOT %REGSTAT0%==1 echo Cannot make USB, REG hives are still loaded. & echo. & pause & GOTO CONFIGAIK
cls
@echo off
echo ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
echo ³WinPE Builder AIK³
echo ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
echo [Make USB]
echo.
IF NOT EXIST %CURDIR%\WinPE_Temp\LISTVOLAIK.txt (
echo list vol
) > %CURDIR%\WinPE_Temp\LISTVOLAIK.txt
for /F "delims=" %%D in ('diskpart /s %CURDIR%\WinPE_Temp\LISTVOLAIK.txt ^| ^
 findstr /i /v /c:"microsoft" /c:"copyright" /c:"on computer"')  do echo(%%D
echo   ----------  ---  -----------  -----  ----------  -------  ---------  --------

:SELVOLNUMAIK
echo.
SET "VNCHOICEAIK=0123456789"
choice /c %VNCHOICEAIK% /n /m "Select volume number [0-9]:"
SET /a "n=%ERRORLEVEL%-1"
SET "VOLNUMAIK=!VNCHOICEAIK:~%n%,1!"

:SELVOLLETAIK
echo.
SET "VLCHOICEAIK=ABCDEFGHIJKLMNOPQRSTUVWXYZ"
choice /c %VLCHOICEAIK% /n /m "Select volume letter [A-Z]:"
SET /a "n=%ERRORLEVEL%-1"
SET "VOLLETAIK=!VLCHOICEAIK:~%n%,1!"

:CONFIRMVOLUME
echo.
echo   Volume ###  Ltr
echo   ----------  ---
diskpart /s %CURDIR%\WinPE_Temp\LISTVOLAIK.txt | findstr /i /c:"Volume %VOLNUMAIK%     %VOLLETAIK%"
IF %ERRORLEVEL% NEQ 0 (
echo   Volume %VOLNUMAIK%     %VOLLETAIK%
echo.
echo ^> ERROR^^! Selections do not match. & echo. & pause & GOTO CONFIGAIK
)
echo.
for /f "tokens=2 delims==" %%S in ('wmic volume where "driveletter='%VOLLETAIK%:'" ^
get capacity /value ^| find "=" ') do set "VOLSIZEAIK=%%S"

for /f "tokens=2 delims==" %%T in ('wmic logicaldisk where "deviceid='%VOLLETAIK%:'" ^
get description /value ^| find "=" ') do set "VOLTYPEAIK=%%T"

SET "MAXSIZEAIK=34359738368"
CALL :ADDZEROSAIK VOLSIZEAIK
CALL :ADDZEROSAIK MAXSIZEAIK

IF "%VOLTYPEAIK%" EQU "CD-ROM Disc" echo ^> ERROR^^! Invalid volume - optical drive. & echo. & pause & GOTO CONFIGAIK
IF 0%VOLSIZEAIK% EQU 0 echo ^> ERROR^^! Invalid volume - no free space. & echo. & pause & GOTO CONFIGAIK
IF 0%VOLSIZEAIK% GTR %MAXSIZEAIK% echo ^> ERROR^^! Volume size cannot exceed 32 GB. & echo. & pause & GOTO CONFIGAIK

choice /c YN /N /M "> Proceed with format? <Y/N>"
IF ERRORLEVEL 2 GOTO CONFIGAIK
IF ERRORLEVEL 1 GOTO FORMATVOLAIK

:FORMATVOLAIK
echo.
echo.
(
echo sel vol %VOLNUMAIK%
echo del vol
echo create partition primary
echo format quick fs=fat32 label="WINPE_AIK"
echo active
echo assign letter=%VOLLETAIK%
) > %CURDIR%\WinPE_Temp\FORMATVOLAIK.txt
echo Formatting volume...
echo ------------------------------
for /F "delims=" %%D in ('diskpart /s %CURDIR%\WinPE_Temp\FORMATVOLAIK.txt ^
| findstr /i /v /c:"microsoft" /c:"copyright" /c:"on computer"')  do echo(%%D

:MAKEUSBAIK2
echo.
echo.
echo Copying WinPE boot files...
echo ------------------------------
copy /y C:\winpe_x86\winpe.wim C:\winpe_x86\ISO\sources\boot.wim
xcopy C:\winpe_x86\ISO\*.* /s /e /f %VOLLETAIK%:\
echo.
pause
GOTO CONFIGAIK

:ADDZEROSAIK
SET "n=000000000000000!%~1!"
SET "n=!n:~-15!"
SET "%~1=%n%"
GOTO EOF

:::::::::::::::::::::::::::::::::::::::
::|  \/  |__ _| |_____|_ _/ __|/ _ \ ::
::| |\/| / _` | / / -_)| |\__ \ (_) |::
::|_|  |_\__,_|_\_\___|___|___/\___/ ::
:::::::::::::::::::::::::::::::::::::::
:MAKEISOAIK1
title WinPE_BuilderAIK [Make ISO]
IF NOT %WRKDIRSTAT%==1 echo WinPE working directory does not exist. & echo. & pause & GOTO CONFIGAIK
IF %MOUNTSTAT%==1 echo Cannot make ISO, image is currently Mounted. & echo. & pause & GOTO CONFIGAIK
IF NOT %REGSTAT0%==1 echo Cannot make ISO, REG hives are still loaded. & echo. & pause & GOTO CONFIGAIK
IF EXIST "c:\winpe_x86\winpe_x86.iso" GOTO DELETEISOAIK
GOTO MAKEISOAIK2

:DELETEISOAIK
choice /c YN /N /M "ISO already exists, overwrite file? <Y/N>"
echo.
IF ERRORLEVEL 2 GOTO CONFIGAIK
IF ERRORLEVEL 1 GOTO MAKEISOAIK2

:MAKEISOAIK2
IF EXIST "C:\winpe_x86\winpe_x86.iso" del /q /f "C:\winpe_x86\winpe_x86.iso" > nul 2> %CURDIR%\WinPE_Temp\DELISOAIK.txt
findstr /i /c:"process cannot access the file" %CURDIR%\WinPE_Temp\DELISOAIK.txt > nul 2> nul (
IF %ERRORLEVEL%==0 echo Can't overwrite file, ISO is in use by another process. & echo. & pause & GOTO CONFIGAIK
)
echo Making ISO...
echo -------------
IF EXIST "c:\winpe_x86\winpe_x86.iso" del /f /q "c:\winpe_x86\winpe_x86.iso" 
copy c:\winpe_x86\winpe.wim c:\winpe_x86\ISO\sources\boot.wim
"C:\Program Files\Windows AIK\Tools\x86\oscdimg.exe" -n -bc:\winpe_x86\etfsboot.com c:\winpe_x86\ISO c:\winpe_x86\winpe_x86.iso
echo.
pause
GOTO CONFIGAIK

::::::::::::::::::::::::::::::::::::::::::::::::
::| _ ) __ _| |_ __| |_ |  \/  |___  __| |___ ::
::| _ \/ _` |  _/ _| ' \| |\/| / _ \/ _` / -_)::
::|___/\__,_|\__\__|_||_|_|  |_\___/\__,_\___|::
::::::::::::::::::::::::::::::::::::::::::::::::
:BATCHMODEAIK
title WinPE_BuilderAIK [Batch Mode]
IF NOT EXIST "C:\winpe_x86" GOTO BMCONFIRMAIK
echo Existing image will be deleted...

:BMCONFIRMAIK
echo.
choice /c YN /N /M "Proceed with batch mode? <Y/N>"
echo.
IF ERRORLEVEL 2 GOTO CONFIGAIK
IF ERRORLEVEL 1 GOTO BMUNLOADREGAIK

:BMUNLOADREGAIK
IF NOT %REGSTAT0%==1 (
echo.
echo Unloading WinPE REG hives...
echo ----------------------------
echo ^> Unloading {HKLM\WinPE-AIK_HKCU}
reg unload HKLM\WinPE-AIK_HKCU
echo.
echo ^> Unloading {HKLM\WinPE-AIK_HKLM_SOFTWARE}
reg unload HKLM\WinPE-AIK_HKLM_SOFTWARE
echo.
echo ^> Unloading {HKLM\WinPE-AIK_HKLM_SYSTEM}
reg unload HKLM\WinPE-AIK_HKLM_SYSTEM
echo.
) else (
echo.
)

:BMCREATEDIRECTORYAIK
IF EXIST "C:\winpe_x86\winpe_x86.iso" del /q /f "C:\winpe_x86\winpe_x86.iso" > nul 2> %CURDIR%\WinPE_Temp\DELISOAIK.txt
findstr /i /c:"process cannot access the file" %CURDIR%\WinPE_Temp\DELISOAIK.txt > nul 2> nul (
IF %ERRORLEVEL%==0 echo Can't overwrite files, ISO is in use by another process. & echo. & pause & GOTO CONFIGAIK
)
IF %MOUNTSTAT%==1 (
echo Unmounting image...
echo -------------------
"C:\Program Files\Windows AIK\Tools\x86\imagex.exe" /unmount c:\winpe_x86\mount
)
rd /s /q "C:\winpe_x86"
call "C:\Program Files\Windows AIK\Tools\PETools\copype.cmd" x86 c:\winpe_x86
echo.
cd C:\Windows\System32

:BMMOUNTIMAGEAIK
echo.
echo Mounting image...
echo -----------------
"C:\Program Files\Windows AIK\Tools\x86\imagex.exe" /mountrw c:\winpe_x86\winpe.wim 1 c:\winpe_x86\mount

:BMADDFILESAIK
takeown /f "C:\winpe_x86\mount\Windows\System32\winpe.bmp" >nul
IF NOT %ERRORLEVEL%==0 echo Failed to take ownership of "winpe.bmp" & echo.
icacls "C:\winpe_x86\mount\Windows\System32\winpe.bmp" /grant:r %USERNAME%:(F) >nul
IF NOT %ERRORLEVEL%==0 echo Failed to apply permissions to "winpe.bmp" & echo.

:BMCOPYWINPEADDAIK
echo Adding files to \mount\Windows\System32
echo ---------------------------------------
xcopy "%CURDIR%\WinPE_AIK7-FILES\*.*" "C:\winpe_x86\mount\Windows\System32" /e /y
echo.

:BMLOADHIVESAIK
echo.
echo Loading WinPE REG hives...
echo --------------------------
echo ^> Loading {HKLM\WinPE-AIK_HKCU}
reg load HKLM\WinPE-AIK_HKCU C:\winpe_x86\mount\Windows\System32\config\DEFAULT
echo.
echo ^> Loading {HKLM\WinPE-AIK_HKLM_SOFTWARE}
reg load HKLM\WinPE-AIK_HKLM_SOFTWARE C:\winpe_x86\mount\Windows\System32\config\SOFTWARE
echo.
echo ^> Loading {HKLM\WinPE-AIK_HKLM_SYSTEM}
reg load HKLM\WinPE-AIK_HKLM_SYSTEM C:\winpe_x86\mount\Windows\System32\config\SYSTEM
echo.
echo.

:BMIMPORTREGAIK
echo Importing WinPE REG keys...
echo ---------------------------
dir /b "%CURDIR%\WinPE_AIK7-REG" > %CURDIR%\WinPE_Temp\RegAddDirAIK.txt
SET COUNTER=0
for /F "tokens=*" %%A in (%CURDIR%\WinPE_Temp\RegAddDirAIK.txt) do (
SET /A COUNTER=!COUNTER! + 1
SET !COUNTER!=%%A
echo ^> Importing {%%A}
REG IMPORT "%CURDIR%\WinPE_AIK7-REG\%%A"
)
echo.
echo.

:BMUNLOADHIVESAIK
echo Unloading WinPE REG hives...
echo ----------------------------
echo ^> Unloading {HKLM\WinPE-AIK_HKCU}
reg unload HKLM\WinPE-AIK_HKCU
echo.
echo ^> Unloading {HKLM\WinPE-AIK_HKLM_SOFTWARE}
reg unload HKLM\WinPE-AIK_HKLM_SOFTWARE
echo.
echo ^> Unloading {HKLM\WinPE-AIK_HKLM_SYSTEM}
reg unload HKLM\WinPE-AIK_HKLM_SYSTEM
echo.
echo.

:BMADDDRIVERSAIK
echo Adding drivers to image...
echo --------------------------
"C:\Program Files\Windows AIK\Tools\Servicing\Dism.exe" /image:c:\winpe_x86\mount /Add-Driver /Driver:"%CURDIR%\WinPE_AIK7-DRIVERS" /Recurse /ForceUnsigned
echo.
echo.

:BMUNMOUNTCOMMITIMAGEAIK
echo Committing and Unmounting image...
echo ----------------------------------
"C:\Program Files\Windows AIK\Tools\x86\imagex.exe" /unmount c:\winpe_x86\mount /commit
IF %ERRORLEVEL%==2 (
"C:\Program Files\Windows AIK\Tools\x86\imagex.exe" /unmount c:\winpe_x86\mount
)

echo ^> Ready to make ISO or USB^^!
echo.
echo.
pause
GOTO CONFIGAIK

:::::::::::::::::::::::::::::::::::::::::::::::
::  /_\  __| |__| |   \ _ _(_)_ _____ _ _ ___::
:: / _ \/ _` / _` | |) | '_| \ V / -_) '_(_-<::
::/_/ \_\__,_\__,_|___/|_| |_|\_/\___|_| /__/::
:::::::::::::::::::::::::::::::::::::::::::::::
:ADDDRIVERSAIK
title WinPE_BuilderAIK [Mount/Unmount image]
IF NOT %WRKDIRSTAT%==1 echo WinPE working directory does not exist. & echo. & pause & GOTO CONFIGAIK
IF %MOUNTSTAT%==0 echo Cannot add drivers, image is NOT Mounted. & echo. & pause & GOTO CONFIGAIK

echo Adding drivers to image...
echo --------------------------
"C:\Program Files\Windows AIK\Tools\Servicing\Dism.exe" /image:c:\winpe_x86\mount /Add-Driver /Driver:"%CURDIR%\WinPE_AIK7-DRIVERS" /Recurse /ForceUnsigned
echo.
pause
GOTO CONFIGAIK

::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::| |   ___  __ _ __| | _ \___ __ _(_)__| |_ _ _ _  _ ::
::| |__/ _ \/ _` / _` |   / -_) _` | (_-<  _| '_| || |::
::|____\___/\__,_\__,_|_|_\___\__, |_/__/\__|_|  \_, |::
::::::::::::::::::::::::::::::|___/::::::::::::::|__/:::
:LOADREGISTRYAIK
title WinPE_Builder AIK [Load Registry]
IF NOT %WRKDIRSTAT%==1 echo WinPE working directory does not exist. & echo. & pause & GOTO CONFIGAIK
IF NOT %REGSTAT0%==1 GOTO LOADHIVESAIK1
IF %MOUNTSTAT%==0 echo Can't load REG hives, image is not mounted. & echo. & pause & GOTO CONFIGAIK

:LOADHIVESAIK1
cls
@echo off
echo ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
echo ³WinPE Builder AIK³
echo ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF NOT %REGSTAT0%==1 echo. & echo REG hives already loaded... & GOTO UNLOADHIVESAIK1
echo.
echo Loading WinPE REG hives...
echo --------------------------
echo ^> Loading {HKLM\WinPE-AIK_HKCU}
reg load HKLM\WinPE-AIK_HKCU C:\winpe_x86\mount\Windows\System32\config\DEFAULT
echo.
echo ^> Loading {HKLM\WinPE-AIK_HKLM_SOFTWARE}
reg load HKLM\WinPE-AIK_HKLM_SOFTWARE C:\winpe_x86\mount\Windows\System32\config\SOFTWARE
echo.
echo ^> Loading {HKLM\WinPE-AIK_HKLM_SYSTEM}
reg load HKLM\WinPE-AIK_HKLM_SYSTEM C:\winpe_x86\mount\Windows\System32\config\SYSTEM
echo.

:UNLOADHIVESAIK1
echo --------------------
echo [I] Import reg files
echo [U] Unload reg hives
echo [X] Cancel
echo --------------------
echo.
choice /c IUX /N /M ">"
echo.
IF ERRORLEVEL 3 GOTO CONFIGAIK
IF ERRORLEVEL 2 GOTO UNLOADHIVESAIK2
IF ERRORLEVEL 1 GOTO IMPORTREGAIK

:UNLOADHIVESAIK2
echo Unloading WinPE REG hives...
echo ----------------------------
echo ^> Unloading {HKLM\WinPE-AIK_HKCU}
reg unload HKLM\WinPE-AIK_HKCU
echo.
echo ^> Unloading {HKLM\WinPE-AIK_HKLM_SOFTWARE}
reg unload HKLM\WinPE-AIK_HKLM_SOFTWARE
echo.
echo ^> Unloading {HKLM\WinPE-AIK_HKLM_SYSTEM}
reg unload HKLM\WinPE-AIK_HKLM_SYSTEM
echo.
pause
GOTO CONFIGAIK

:IMPORTREGAIK
dir /b "%CURDIR%\WinPE_AIK7-REG" > %CURDIR%\WinPE_Temp\RegAddDirAIK.txt
SET COUNTER=0
for /F "tokens=*" %%A in (%CURDIR%\WinPE_Temp\RegAddDirAIK.txt) do (
SET /A COUNTER=!COUNTER! + 1
SET !COUNTER!=%%A
echo ^> Importing {%%A}
REG IMPORT "%CURDIR%\WinPE_AIK7-REG\%%A"
echo.
)
GOTO UNLOADHIVESAIK1

::::::::::::::::::::::::::::::::::::
::  /_\  __| |__| | __(_) |___ ___::
:: / _ \/ _` / _` | _|| | / -_|_-<::
::/_/ \_\__,_\__,_|_| |_|_\___/__/::
::::::::::::::::::::::::::::::::::::
:ADDFILESAIK
title WinPE_BuilderAIK [Add Files]
IF NOT %WRKDIRSTAT%==1 echo WinPE working directory does not exist. & echo. & pause & GOTO CONFIGAIK
IF NOT %MOUNTSTAT%==1 echo Can't add files, image is not mounted. & echo. & pause & GOTO CONFIGAIK

takeown /f "C:\winpe_x86\mount\Windows\System32\winpe.bmp" >nul
IF NOT %ERRORLEVEL%==0 echo Failed to take ownership of "winpe.bmp" & echo.
icacls "C:\winpe_x86\mount\Windows\System32\winpe.bmp" /grant:r %USERNAME%:(F) >nul
IF NOT %ERRORLEVEL%==0 echo Failed to apply permissions to "winpe.bmp" & echo.

:COPYWINPEADDAIK
echo Adding files to \mount\Windows\System32
echo ---------------------------------------
xcopy "%CURDIR%\WinPE_AIK7-FILES\*.*" "C:\winpe_x86\mount\Windows\System32" /e /y
echo.
pause
GOTO CONFIGAIK

:::::::::::::::::::::::::::::::::::::::::::::::::::::
::|  \/  |___ _  _ _ _| |_|_ _|_ __  __ _ __ _ ___ ::
::| |\/| / _ \ || | ' \  _|| || '  \/ _` / _` / -_)::
::|_|  |_\___/\_,_|_||_\__|___|_|_|_\__,_\__, \___|::
::::::::::::::::::::::::::::::::::::::::::|___/::::::
:MOUNTUNMOUNTIMAGEAIK
title WinPE_BuilderAIK [Mount/Unmount image]
IF NOT %WRKDIRSTAT%==1 echo WinPE working directory does not exist. & echo. & pause & GOTO CONFIGAIK
IF NOT %REGSTAT0%==1 echo Cannot unmount image, REG hives are still loaded. & echo. & pause & GOTO CONFIGAIK
IF %MOUNTSTAT%==1 GOTO CONFIRMUNMOUNTAIK

:CONFIRMMOUNTAIK
choice /c YN /N /M "Image is UNMOUNTED. Do you want to MOUNT it? <Y/N>"
IF ERRORLEVEL 2 GOTO CONFIGAIK
IF ERRORLEVEL 1 GOTO MOUNTIMAGEAIK

:MOUNTIMAGEAIK
echo.
echo Mounting image...
echo -----------------
"C:\Program Files\Windows AIK\Tools\x86\imagex.exe" /mountrw c:\winpe_x86\winpe.wim 1 c:\winpe_x86\mount
pause
GOTO CONFIGAIK

:CONFIRMUNMOUNTAIK
choice /c YN /N /M "Image is MOUNTED. Do you want to commit and UNMOUNT it? <Y/N>"
IF ERRORLEVEL 2 GOTO CONFIGAIK
IF ERRORLEVEL 1 GOTO UNMOUNTCOMMITIMAGEAIK

:UNMOUNTCOMMITIMAGEAIK
echo.
echo Committing and Unmounting image...
echo ----------------------------------
"C:\Program Files\Windows AIK\Tools\x86\imagex.exe" /unmount c:\winpe_x86\mount /commit
IF %ERRORLEVEL%==2 (
"C:\Program Files\Windows AIK\Tools\x86\imagex.exe" /unmount c:\winpe_x86\mount
)
pause
GOTO CONFIGAIK

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::\ \    / /__ _ _| |_(_)_ _  __ _|   \(_)_ _ ___ __| |_ ___ _ _ _  _ ::
:: \ \/\/ / _ \ '_| / / | ' \/ _` | |) | | '_/ -_) _|  _/ _ \ '_| || |::
::  \_/\_/\___/_| |_\_\_|_||_\__, |___/|_|_| \___\__|\__\___/_|  \_, |::
:::::::::::::::::::::::::::::|___/:::::::::::::::::::::::::::::::|__/:::
:CREATEDIRECTORYAIK1
title WinPE_BuilderAIK [Create working directory]
IF NOT %REGSTAT0%==1 echo Cannot create working directory, REG hives are still loaded. & echo. & pause & GOTO CONFIGAIK
IF %WRKDIRSTAT%==1 GOTO DELETEDIRECTORYAIK
GOTO CREATEDIRECTORYAIK2

:DELETEDIRECTORYAIK
choice /c YN /N /M "Working directory already exists, overwrite files? <Y/N>"
echo.
IF ERRORLEVEL 2 GOTO CONFIGAIK
IF ERRORLEVEL 1 GOTO CREATEDIRECTORYAIK2

:CREATEDIRECTORYAIK2
IF EXIST "C:\winpe_x86\winpe_x86.iso" del /q /f "C:\winpe_x86\winpe_x86.iso" > nul 2> %CURDIR%\WinPE_Temp\DELISOAIK.txt
findstr /i /c:"process cannot access the file" %CURDIR%\WinPE_Temp\DELISOAIK.txt > nul 2> nul (
IF %ERRORLEVEL%==0 echo Can't overwrite files, ISO is in use by another process. & echo. & pause & GOTO CONFIGAIK
)
IF %MOUNTSTAT%==1 (
echo Unmounting image...
echo -------------------
"C:\Program Files\Windows AIK\Tools\x86\imagex.exe" /unmount c:\winpe_x86\mount
)
IF EXIST "C:\winpe_x86" rd /s /q "C:\winpe_x86"
call "C:\Program Files\Windows AIK\Tools\PETools\copype.cmd" x86 c:\winpe_x86
echo.
cd C:\Windows\System32
pause
GOTO CONFIGAIK

:EOF
