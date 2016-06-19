# WinPE_BuilderAIK.bat
Batch for making custom WinPE images using AIK 7

Required: Windows Automated Installation Kit for Windows 7

https://www.microsoft.com/en-us/download/details.aspx?id=5753

- Create a working folder called "WinPE_Builder" and put "WinPE_BuilderAIK.bat" inside of it.
- On first run the batch will create 4 new folders; WinPE_AIK7-DRIVERS, WinPE_AIK7-FILES, WinPE_AIK7-REG and WinPE_Temp.
- The "WinPE_AIK7-DRIVERS" folder should contain fully extracted drivers that will be injected into your image such as network and video drivers.
- The "WinPE_AIK7-FILES" folder should contain files intended to be added to the X:\Windows\System32 direcotry of your WinPE image such as startnet.cmd, winpe.bmp, imagex.exe, other scripts...
- The "WinPE_AIK7-REG" folder should contain .reg files for customizing the PE environment such as command console settings.
- If you don't want to customize anything leave the above folders empty.
- The "WinPE_Temp" folder is what it sounds like, temp files are written here.

Once all of the files are in place, you can create a custom image by running Batch Mode then Make ISO or USB media.  Batch Mode runs the other options in succession: 
- Create Working Directory
- Mount/Unmount image
- Add FILES to image
- Load REG hives
- Add DRIVERS

You can run these options individually, but keep in mind that one is dependent on the other.  The script tries to check for error states like "You can't mount an image until you've created a working directory" or "You can't add files until you've mounted the image".  Comment if you come across a state I haven't accounted for.  Only x86 images are supported in this script so make sure your custom files are compatible.
