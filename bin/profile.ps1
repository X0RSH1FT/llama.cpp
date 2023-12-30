#region Documentation
<#
    .SYNOPSIS
        LLAMA.CPP PowerShell profile script

    .DESCRIPTION
        This script is loaded by PowerShell when the user profile is loaded.
        Defines functions for interacting with the LLAMA.CPP executable.
    
    .NOTES
        Add import statement for this script to the user powershell profile
        Open profile script with command -
            notepad $PROFILE
        Add import statement -
            if (Test-Path "<PATH_TO_THIS_SCRIPT>") { . "<PATH_TO_THIS_SCRIPT>" }
        Example -
            if (Test-Path "F:\Code\llama.cpp\bin\profile.ps1") { . "F:\Code\llama.cpp\bin\profile.ps1" }
            
#>
#endregion

Set-StrictMode -Version 3.0

#region Operations

<# Print environment variables #>
function Write-LlamaEnvironment
{
    Write-Host "-- LLAMA.CPP environment variables --" -ForegroundColor Magenta
    Write-Host "LLAMA_CPP_PROJECT_PATH = $env:LLAMA_CPP_PROJECT_PATH" -ForegroundColor DarkGray
    Write-Host "LLAMA_CPP_BIN = $env:LLAMA_CPP_BIN" -ForegroundColor Cyan
    Write-Host "LLM_MODEL_PATH = $env:LLM_MODEL_PATH" -ForegroundColor Green
}

<# Complete text from input prompt #>
function Complete-Text
{
    param(
        [string] $prompt,
        [string] $model_path = $null,
        [int] $context_size = 2048,
        [int] $thread_cnt = 4
    )
    Assert-LlamaCpp
    if (!$model_path) { $model_path = $env:LLM_MODEL_PATH }
    $arg_map = @{
        "-m" = $model_path
        "-p" = $prompt
        "-c" = $context_size
        "-t" = $thread_cnt
    }
    $opt_set = @(
        "--color"
    )
    $arguments = $arg_map.GetEnumerator() | ForEach-Object { "$($_.Key) '$($_.Value)'" }
    $options = $opt_set | ForEach-Object { "$($_)" }
    Invoke-Expression "$env:LLAMA_CPP_BIN $arguments $options"
}

<# Generate and complete text file #>
function Complete-File
{
    param(
        [string] $file,
        [string] $model_path = $null,
        [int] $context_size = 2048,
        [int] $thread_cnt = 4
    )
    Assert-LlamaCpp
    if (!$model_path) { $model_path = $env:LLM_MODEL_PATH }
    $arg_map = @{
        "-m" = $model_path
        "-f" = $file
        "-c" = $context_size
        "-t" = $thread_cnt
    }
    $opt_set = @(
        "--color"
    )
    $arguments = $arg_map.GetEnumerator() | ForEach-Object { "$($_.Key) '$($_.Value)'" }
    $options = $opt_set | ForEach-Object { "$($_)" }
    Invoke-Expression "$env:LLAMA_CPP_BIN $arguments $options"
}

<# Start text completion console #>
function Start-LLamaConsole
{
    param(
        [string] $model_path,
        [int] $context_size = 2048,
        [int] $thread_cnt = 4
    )
    Assert-LlamaCpp
    if (!$model_path) { $model_path = $env:LLM_MODEL_PATH }
    $arg_map = @{
        "-m" = $model_path
        "-c" = $context_size
        "-t" = $thread_cnt
    }
    $opt_set = @(
        "--interactive-first",
        "--color"
    )
    $arguments = $arg_map.GetEnumerator() | ForEach-Object { "$($_.Key) '$($_.Value)'" }
    $options = $opt_set | ForEach-Object { "$($_)" }
    Invoke-Expression "$env:LLAMA_CPP_BIN $arguments $options"
}

<# Invoke test function #>
function Test-LlamaCpp { Complete-Text "The life of a rogue AI is weird" }

<# Test that a compiled LLAMA.CPP binary exists. Raise exception if not #>
function Assert-LlamaCpp { if (!(Test-Path "$env:LLAMA_CPP")) { throw "Could not find llama.exe at path - $env:LLAMA_CPP"} }

#endregion