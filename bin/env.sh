#!/bin/bash

# Documentation
: '
    SYNOPSIS
        Environment configuration Bash script for LLAMA.CPP

    DESCRIPTION
        This script is loaded by Bash when the user profile is loaded.
        Defines environment variables for interacting with the LLAMA.CPP binary
    
    NOTES
        Add source statement for this script to the user bash profile
        Open profile script with command -
            nano ~/.bashrc or nano ~/.bash_profile
        Add source statement -
            if [ -f "<PATH_TO_THIS_SCRIPT>" ]; then
                . "<PATH_TO_THIS_SCRIPT>"
            fi
        Example -
            if [ -f "$HOME/llama-cpp/bin/env.sh" ]; then
                . "$HOME/llama-cpp/bin/env.sh"
            fi
'

# Parameters
llama_cpp_project_path=${1:-}
llama_cpp_binary_path=${2:-}
llm_model_path=${3:-}
llm_models_directory_path=${4:-}

# Defaults
DEFAULT_LLAMA_CPP_PROJECT_PATH="$HOME/llama-cpp"
DEFAULT_LLAMA_CPP_BIN_PATH="${DEFAULT_LLAMA_CPP_PROJECT_PATH}/build/bin/main"
DEFAULT_LLM_MODELS_DIRECTORY_PATH="/data/llm"
DEFAULT_LLM_MODEL_PATH="$DEFAULT_LLM_MODELS_DIRECTORY_PATH/dolphin-2_6-phi-2-GGUF/dolphin-2_6-phi-2.Q4_K_M.gguf"

# Apply configuration
# Apply defaults if not specified
: ${llama_cpp_project_path:=$DEFAULT_LLAMA_CPP_PROJECT_PATH}
: ${llama_cpp_binary_path:=$DEFAULT_LLAMA_CPP_BIN_PATH}
: ${llm_model_path:=$DEFAULT_LLM_MODEL_PATH}
export LLAMA_CPP_PROJECT_PATH=$(realpath "$llama_cpp_project_path")
export LLAMA_CPP_BIN=$(realpath "$llama_cpp_binary_path")
export LLM_MODEL_DIRECTORY=$(realpath "$llm_models_directory_path")
export LLM_MODEL_PATH=$(realpath "$llm_model_path")

# Log state
echo "-- LLAMA.CPP environment variables --"
echo "LLAMA_CPP_PROJECT_PATH = $LLAMA_CPP_PROJECT_PATH"
echo "LLAMA_CPP_BIN = $LLAMA_CPP_BIN"
echo "LLM_MODEL_DIRECTORY = $LLM_MODEL_DIRECTORY"
echo "LLM_MODEL_PATH = $LLM_MODEL_PATH"