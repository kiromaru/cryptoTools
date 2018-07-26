$ErrorActionPreference = "Stop"

$MSBuild_14 = 'C:\Program Files (x86)\MSBuild\14.0\Bin\MSBuild.exe'
$MSBuild_15 = 'C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\MSBuild\15.0\Bin\MSBuild.exe'

# Update this if needed
$MSBuild = $MSBuild_15
$git = 'git'
$cmake = 'cmake'


if(!(Test-Path $MSBuild))
{
    Write-Host "Could not find MSBuild as"
    Write-Host "     $MSBuild"
    Write-Host ""
    Write-Host "Please update its location in the script"

    exit
}
 
$startDir = $PWD
 
$folder =  "$PWD\miracl"
if(!(Test-Path $folder))
{
    & $git clone https://github.com/kiromaru/miracl.git
}
else
{
    Write-Host "$folder already exists. Skipping dowload and extract."
}

Set-Location $folder

& $cmake . -G "Visual Studio 15 2017 Win64"
& $MSBuild miracl.sln  /p:Configuration=Release
& $MSBuild miracl.sln  /p:Configuration=Debug

Set-Location $startDir
