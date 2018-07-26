$ErrorActionPreference = "Stop"

$uri = 'https://dl.bintray.com/boostorg/release/1.65.1/source/boost_1_65_1.zip'

$destination = "$PWD\boost_1_65_1.zip"


if(!(Test-Path "$PWD\boost"))
{
    if(!(Test-Path $destination))
    {
        Write-Host 'downloading ' $uri ' to ' $destination
        Write-Host 'It is 131.7 MB '

        try
        {
            [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
            $wc = new-object System.Net.WebClient
            $wc.DownloadFile($uri, $destination)
        }
        catch
        {
            Write-Host $_.exception.message
            Write-Host 'Error downloading boost.'
            return;
        }

        Write-Host 'Download Complete'
    }


    Write-Host 'Extracting '$destination' to ' $PWD '. This will take a bit... So be patient.'


    Add-Type -assembly “system.io.compression.filesystem”
    [io.compression.zipfile]::ExtractToDirectory($destination, $PWD)

    Move-Item "$PWD\boost_1_65_1" "$PWD\boost"
}

Set-Location "$PWD\boost"

if(!(Test-Path "$PWD\b2.exe"))
{
    & $PWD\bootstrap.bat
}

.\b2.exe  architecture=x86 address-model=64 --with-thread --with-filesystem --with-regex --with-date_time stage link=static variant=debug,release runtime-link=static threading=multi



Set-Location ..

If (Test-Path $destination){
	Remove-Item $destination
}
