<#
setup.ps1
.DESCRIPTION

    Windows Terminal - Supporter Profile Setup Script

    This script will download and install Windows Terminal, if it's not installed.
    Then it will create a folder "WT-SP" in public user files. There it will store the
    session scripts and downloads the background images and the icons. 
    You will also need Putty for the serial session. By enabeling $puttysetup this script
    will install this for you too.


    Default Wallpapers: https://imgur.com/a/u1Nn2xy
    Putty Official Website: https://www.putty.org/
    
https://github.com/thelamescriptkiddiemax/wt_supporterprofile
#>
#--- Variablen ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$makeupdl = "https://gofile.io/d/jFcJ5e"                                                        # Link to makup zip-file            EX  https://domain.tld/share/file.zip

$puttysetup = "x"                                                                               # Enables the PuTTY setup           EX  x
$puttylink = "https://the.earth.li/~sgtatham/putty/latest/w64/putty-64bit-0.74-installer.msi"   # Link to PuTTY.MSI                 EX  https://domain.tld/share/file.msi


$scriptspeed = "3"                                                                              # Dauer der Einbledungen            EX  1
$fmode = ""                                                                                     # Floating Mode (Debugging)         EX  x

#--- Vorbereitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$wintermi = "*windowsterminal*"                                                                                                                     # Windows Terminal install check
$installcheck = (Get-AppxPackage -Name $wintermi | Select-Object PackageFullName)                                                                   # Windows Terminal install check

$scriptsource = "$PSScriptRoot\scripts\*"                                                                                                           # Copy source scripts
$profilesource = "$PSScriptRoot\settings.json"                                                                                                      # Copy source settings.json

$wtsppath = "%public%\WT_SP"                                                                                                                        # Directory working
$wtspscripts = "$wtsppath\scrips"                                                                                                                   # Directory scripts
$scriptdest = "$wtspscripts\"                                                                                                                       # Directory scripts
$wtspmakeup = "$wtsppath\makeup"                                                                                                                    # Directory makeup
$makeupzip = "$wtspmakeup\makeup.zip"                                                                                                               # makeup.zip - wallpapers and icons
$profbdest = "$wtsppath\settings_BACKUP.json"                                                                                                       # setting.json backup
$puttymsi = "$wtsppath\putty.msi"                                                                                                                   # PuTTX.MSI

$profilepath = "%HOMEPATH%\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"                                               # Windows Terminal profile path


#--- Funktionen ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Scripthead
function scripthead
{

    # create stringhost
    $stringhost = [System.String]::Concat("[ ", $env:UserName, " @ ", $env:computername, " @ ", ((Get-WmiObject Win32_ComputerSystem).Domain), " ", (Get-CimInstance Win32_OperatingSystem | Select-Object Caption), ": ", 
    ((Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\" -Name ReleaseID).ReleaseId), " ]   ", (Get-Date -Format "dd/MM/yyyy HH:mm"), "`n") 
    $stringhost = $stringhost.replace("{Caption=Microsoft"," ").replace("}", " ")

    # fmode
    if (!$fmode)
    {
        Clear-Host                                                                                                                                  # Clear Screen
    }

    Write-Host $stringhost -ForegroundColor Magenta

    Write-Host "     _________       __                " -ForegroundColor Blue
    Write-Host "    /   _____/ _____/  |_ __ ________  " -ForegroundColor Blue
    Write-Host "    \_____  \_/ __ \   __\  |  \____ \ " -ForegroundColor Blue
    Write-Host "    /        \  ___/|  | |  |  /  |_> >" -ForegroundColor Blue
    Write-Host "   /_______  /\___  >__| |____/|   __/ " -ForegroundColor Blue
    Write-Host "           \/     \/           |__|    " -ForegroundColor Blue
    Write-Host "`n"
    Write-Host "   WINDOWS TERMINAL" -ForegroundColor Blue
    Write-Host "   SUPPORTER PROFILE" -ForegroundColor Blue
    Write-Host "`n"

}

# Dauer Einblendungen
function scriptspeed ($scriptspeed)
{
    Start-Sleep -Seconds $scriptspeed                                                                                                               # display timeout
}

# Downloads
function fileloader ($dlfile, $dllink, $scriptspeed)
{

    # Trash check
    if((Test-Path $dlfile -PathType leaf))
    {
        Remove-Item $dlfile                                                                                                                         # Remove old file
    }
    
    $fileloader = New-Object System.Net.WebClient                                                                                                   # Create downloader object
    $stringldloutput = [System.String]::Concat("Link: ", $trafficlink, "`n", "Link: ", $trafficlink)                                                # Create stringldloutput
  
    scripthead                                                                                                                                      # Scripthead
    Write-Host $stringldloutput                                                                                                                     # text output stringldloutput
    scriptspeed $scriptspeed                                                                                                                        # display timeout

    $fileloader.DownloadFile($dllink, $dlfile)                                                                                                      # Download file

}

# Zip Extractor
function zipout ($zipoutfile, $zipoutpath)
{
    Expand-Archive -LiteralPath $zipoutfile -DestinationPath $zipoutpath                                                                            # Extract Zip-File
    Remove-Item $zipoutfile                                                                                                                         # Remove Zip-File
}

#--- Verarbeitung -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

scripthead                                                                                                                                          # Scripthead
Write-Host "`n"                                                                                                                                     # text output
scriptspeed $scriptspeed                                                                                                                            # display timeout

scripthead                                                                                                                                          # Scripthead
Write-Host "   Preparation...."                                                                                                                     # text output
scriptspeed $scriptspeed                                                                                                                            # display timeout

scripthead                                                                                                                                          # Scripthead
Write-Host "   Search for Windows Terminal installation..."                                                                                         # text output
scriptspeed $scriptspeed                                                                                                                            # display timeout

# Windows Terminal check
if (!$installcheck)
{

    scripthead                                                                                                                                      # Scripthead
    Write-Host "   Can't find Windows Terminal Installation! `n   Install..."                                                                       # text output
    scriptspeed $scriptspeed                                                                                                                        # display timeout
    
    Add-AppxPackage -register "C:\Program Files\WindowsApps\$wintermi\AppxManifest.xml" -DisableDevelopmentMode                                     # Install Windows Terminal

    scripthead                                                                                                                                      # Scripthead
    Write-Host "   ...done!"                                                                                                                        # text output
    scriptspeed $scriptspeed                                                                                                                        # display timeout

}

scripthead                                                                                                                                          # Scripthead
Write-Host "   Looking for working directory..."                                                                                                    # text output
scriptspeed $scriptspeed                                                                                                                            # display timeout

if(!(Test-Path $wtscriptpath))                                                                                                                      # If working directory is not present create it
{
    
    scripthead                                                                                                                                      # Scripthead
    Write-Host "   ...not found. Creating..."                                                                                                       # text output
    scriptspeed $scriptspeed                                                                                                                        # display timeout
    
    New-Item -Path %public% -Name $rootgamesrvPATH -ItemType "directory"                                                                            # create directory
    
    scripthead                                                                                                                                      # Scripthead
    Write-Host "   ...done!"                                                                                                                        # text output
    scriptspeed $scriptspeed                                                                                                                        # display timeout

}
else
{

    scripthead                                                                                                                                      # Scripthead
    Write-Host "   ...found!"                                                                                                                       # text output
    scriptspeed $scriptspeed                                                                                                                        # display timeout

}

scripthead                                                                                                                                          # Scripthead
Write-Host "   Copy Scripts..."                                                                                                                     # text output
scriptspeed $scriptspeed                                                                                                                            # display timeout

Copy-Item -Path $scriptsource -Destination $scriptdest -Recurse                                                                                     # Copy scripts

scripthead                                                                                                                                          # Scripthead
Write-Host "   Profile overwrite"                                                                                                                   # text output
scriptspeed $scriptspeed                                                                                                                            # display timeout

Copy-Item -Path $profilesource -Destination $profilepath -Recurse                                                                                   # Overwrite Settings.json
Copy-Item -Path $profilesource -Destination $profbdest -Recurse                                                                                     # create Settings.json backup

scripthead                                                                                                                                          # Scripthead
Write-Host "   ...done! `n   Downloading Makeup..."                                                                                                 # text output
scriptspeed $scriptspeed                                                                                                                            # display timeout

$dllink = $makeupdl                                                                                                                                 # Set download link
$dlfile = $makeupzip                                                                                                                                # Set download file

fileloader $dlfile $dllink $scriptspeed                                                                                                             # Call fileloader

$zipoutfile =  $makeupzip                                                                                                                           # Set file to extract
$zipoutpath = $wtspmakeup                                                                                                                           # Set extraction destination path

zipout $zipoutfile $zipoutpath                                                                                                                      # Call zipextracor

scripthead                                                                                                                                          # Scripthead
Write-Host "   ...done!"                                                                                                                            # text output
scriptspeed $scriptspeed                                                                                                                            # display timeout

# PuTTY Setup
if ($puttysetup) 
{
    
    scripthead                                                                                                                                      # Scripthead
    Write-Host "   PuTTY installation enbaled! `n   Downloading..."                                                                                 # text output
    scriptspeed $scriptspeed                                                                                                                        # display timeout

    $dllink = $puttylink                                                                                                                            # Set download link
    $dlfile = $puttymsi                                                                                                                             # Set download file
    
    fileloader $dlfile $dllink $scriptspeed                                                                                                         # call fileloader

    scripthead                                                                                                                                      # Scripthead
    Write-Host "   ...done! `n   Setup..."                                                                                                          # text output
    scriptspeed $scriptspeed                                                                                                                        # display timeout

    MsiExec.exe /i $puttymsi /qn                                                                                                                    # Call PuTTY.MSI

    scripthead                                                                                                                                      # Scripthead
    Write-Host "   PuTTY installation complete!"                                                                                                    # text output
    scriptspeed $scriptspeed                                                                                                                        # display timeout

}

scripthead                                                                                                                                          # Scripthead
Write-Host "   INSTALLATION COMPLETE" -ForegroundColor White                                                                                        # text output
Write-Host "   ...first run..." -ForegroundColor White                                                                                              # text output
scriptspeed $scriptspeed                                                                                                                            # display timeout

Start-Process wt                                                                                                                                    # Start Windows Terminal

#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

stop-process -Id $PID                                                                                                                               # Kill Script Process