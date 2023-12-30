#!/bin/bash

# Documentation
: '
    SYNOPSIS
        Environment configuration bash script for LLAMA.CPP

    DESCRIPTION
        Sets environment variables for the current user
'

# Parameters
llama_cpp_project_path=${1:-}
llama_cpp_binary_path=${2:-}
llm_model_path=${3:-}

# Initialize
echo "Loading environment - $0" >&2

# Defaults
DEFAULT_LLAMA_CPP_PROJECT_PATH="$HOME/llama-cpp"
DEFAULT_LLAMA_CPP_BIN_PATH="${DEFAULT_LLAMA_CPP_PROJECT_PATH}/build/bin/main"
DEFAULT_LLM_MODEL_PATH="/data/llm/dolphin-2_6-phi-2-GGUF/dolphin-2_6-phi-2.Q4_K_M.gguf"

# Apply configuration
# Apply defaults if not specified
: ${llama_cpp_project_path:=$DEFAULT_LLAMA_CPP_PROJECT_PATH}
: ${llama_cpp_binary_path:=$DEFAULT_LLAMA_CPP_BIN_PATH}
: ${llm_model_path:=$DEFAULT_LLM_MODEL_PATH}
export LLAMA_CPP_PROJECT_PATH=$(realpath "$llama_cpp_project_path")
export LLAMA_CPP_BIN=$(realpath "$llama_cpp_binary_path")
export LLM_MODEL_PATH=$(realpath "$llm_model_path")

# Log state
echo "-- LLAMA.CPP environment variables --"
echo "LLAMA_CPP_PROJECT_PATH = $LLAMA_CPP_PROJECT_PATH"
echo "LLAMA_CPP_BIN = $LLAMA_CPP_BIN"
echo "LLM_MODEL_PATH = $LLM_MODEL_PATH"