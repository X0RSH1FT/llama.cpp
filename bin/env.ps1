#region Documentation
<#
    .SYNOPSIS
        Environment configuration PowerShell script for LLAMA.CPP

    .DESCRIPTION
        Sets environment variables for the current user
#>
#endregion

#region Parameters
param(
    # LLAMA.CPP project path
    [string] $llama_cpp_project_path = $null,
    # LLAMA.CPP executable path
    [string] $llama_cpp_binary_path = $null,
    # Default model path for environment
    [string] $llm_model_path = $null,
    # Persist environment variables
    [switch] $persist
)
#endregion

#region Initialize
Set-StrictMode -Version 3.0
Write-Host "Loading environment - $($MyInvocation.MyCommand.Path)" -ForegroundColor DarkYellow
#endregion

#region Defaults
$DEFAULT_LLAMA_CPP_PROJECT_PATH = "$PSScriptRoot\.."
$DEFAULT_LLAMA_CPP_BIN_PATH = "$DEFAULT_LLAMA_CPP_PROJECT_PATH\build\bin\Release\main.exe"
$DEFAULT_LLM_MODEL_PATH = "Z:\AI\LLM\dolphin-2.6-mixtral-8x7b-GGUF\dolphin-2.6-mixtral-8x7b.Q4_K_M.gguf"
#endregion

#region Apply configuration
Write-Verbose "Setting environment variables"
# Apply defaults if not specified
if (!$llama_cpp_project_path) { $llama_cpp_project_path = $DEFAULT_LLAMA_CPP_PROJECT_PATH }
if (!$llama_cpp_binary_path) { $llama_cpp_binary_path = $DEFAULT_LLAMA_CPP_BIN_PATH }
if (!$llm_model_path) { $llm_model_path = $DEFAULT_LLM_MODEL_PATH }
$env:LLAMA_CPP_PROJECT_PATH = Resolve-Path "$llama_cpp_project_path"
$env:LLAMA_CPP_BIN = Resolve-Path "$llama_cpp_binary_path"
$env:LLM_MODEL_PATH = Resolve-Path "$llm_model_path"
#endregion

#Region Persistent environment variables
if ($persist)
{
    Write-Verbose "Persisting environment variables"
    [Environment]::SetEnvironmentVariable("LLAMA_CPP_PROJECT_PATH", "$env:LLAMA_CPP_PROJECT_PATH", "User")
    [Environment]::SetEnvironmentVariable("LLAMA_CPP_BIN", "$env:LLAMA_CPP_BIN", "User")
    [Environment]::SetEnvironmentVariable("LLM_MODEL_PATH", "$env:LLM_MODEL_PATH", "User")
}
#endregion

#region Log state
Write-Host "-- LLAMA.CPP environment variables --" -ForegroundColor Magenta
Write-Host "LLAMA_CPP_PROJECT_PATH = $env:LLAMA_CPP_PROJECT_PATH" -ForegroundColor DarkGray
Write-Host "LLAMA_CPP_BIN = $env:LLAMA_CPP_BIN" -ForegroundColor Cyan
Write-Host "LLM_MODEL_PATH = $env:LLM_MODEL_PATH" -ForegroundColor Green
#endregion