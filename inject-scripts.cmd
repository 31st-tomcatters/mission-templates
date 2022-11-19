<# : powershell-exec.bat
    :: Start batch
    @echo off
    setlocal
    powershell -ExecutionPolicy RemoteSigned -Command "Invoke-Expression $([System.IO.File]::ReadAllText('%~f0'))"
    endlocal
    goto :eof
    :: End batch
#>

function CheckDependencies()
{
    # Check npm installed
    $command = npm --version
    if(!$?)
    {
        Write-Host "ERROR: npm is not installed. Please install npm and try again." -ForegroundColor Red
        Exit
    }

    # Check node_modules installed
    $path = (Get-Item .).FullName + "\node_modules"
    if (![System.IO.Directory]::Exists($path))
    {
        Write-Host "ERROR: node_modules folder does not exist. Please run 'npm install' and try again." -ForegroundColor Red
        Exit
    }
}

function GetFile() {
    Add-Type -AssemblyName System.Windows.Forms
    $f = new-object Windows.Forms.OpenFileDialog
    $f.InitialDirectory = pwd
    $f.Filter = "Mission Files (*.miz)|*.miz"
    $f.Multiselect = $false
    [void]$f.ShowDialog()
    return $f.FileName
}

function Main()
{
    CheckDependencies

    $file = GetFile
    if ($file -eq "")
    {
        Write-Output("No file selected. Exiting...")
        return
    }

    $command = "npm run inject-scripts --mission=$file"
    Write-Output("Injecting scripts in: $file")
    Invoke-Expression $command
}

Main

pause
