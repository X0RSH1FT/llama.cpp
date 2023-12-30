#region Documentation
<#
    .SYNOPSIS
        LLAMA.CPP PowerShell project script

    .DESCRIPTION
        Utility powerShell script to manage the LLAMA.CPP project
#>
#endregion

#region Parameters
param(
    [switch] $clear,   # Clear the console
    [switch] $debug,   # Enable debug logger
    [switch] $verbose, # Enable verbose logger
    [switch] $build    # Compile the executable
)
#endregion

#region Configuration
Set-StrictMode -Version 3.0
if ($clear) { Clear-Host }
if ($debug) { $DebugPreference = "Continue" }
if ($verbose) { $VerbosePreference = "Continue" }
$LLAMA_BUILD_DIR_PATH = "$PSScriptRoot\..\build"
#endregion

#region Operations

<# Compile LLAMA.CPP binary #>
function Build-LlamaCpp
{
    param([string] $build_path = $null)
    # Store the current working directory to restore after process
    $origin_dir = Get-Location
    try
    {
        # Set the build path to the default if not specified
        if (!$build_path) { $build_path = $LLAMA_BUILD_DIR_PATH }
        # Test if the build directory exists and create it if needed
        if (!(Test-Path -Path $build_path -PathType Container))
        {
            Write-Host "Creating build directory - $build_path" -ForegroundColor Yellow
            New-Item -Path $build_path -ItemType Directory | Out-Null
        }
        $build_path = Resolve-Path $build_path
        Write-Host "Building LLAMA.CPP at path - $build_path" -ForegroundColor Yellow
        # Set the location to the build directory
        Set-Location "$build_path"
        # Run the build commands
        cmake ..
        cmake --build . --config Release
        Assert-LlamaCpp # Validate the compiled binary exists
        Write-Host "LLAMA.CPP compiled successfully" -ForegroundColor Green
    }
    catch { Write-Error "An error occurred during the build process -`n$_" }
    # Reset the working directory
    finally { Set-Location $origin_dir }
}

<# Test that a compiled LLAMA.CPP binary exists. Raise exception if not #>
function Assert-LlamaCpp { if (!(Test-Path "$env:LLAMA_CPP")) { throw "Could not find llama-cpp.exe at path - $env:LLAMA_CPP"} }

#endregion

#region Execution

if ($build) { Build-LlamaCpp }

#endregion