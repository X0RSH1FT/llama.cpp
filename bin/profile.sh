#!/bin/bash

#region Documentation
: '
    SYNOPSIS
        LLAMA.CPP Bash profile script

    DESCRIPTION
        This script is loaded by Bash when the user profile is loaded.
        Defines functions for interacting with the LLAMA.CPP executable.
    
    NOTES
        Add source statement for this script to the user bash profile
        Open profile script with command -
            nano ~/.bashrc or nano ~/.bash_profile
        Add source statement -
            if [ -f "<PATH_TO_THIS_SCRIPT>" ]; then
                . "<PATH_TO_THIS_SCRIPT>"
            fi
        Example -
            if [ -f "$HOME/llama-cpp/bin/profile.sh" ]; then
                . "$HOME/llama-cpp/bin/profile.sh"
            fi
'
#endregion

#region Configuration

# Import environment variables from env.sh if it exists
ENV_SCRIPT="$(dirname "$(realpath "$0")")/env.sh"
if [ -f "$ENV_SCRIPT" ]; then
    . "$ENV_SCRIPT"
fi

#endregion

#region Operations

# Print environment variables
write_llama_environment()
{
    echo "-- LLAMA.CPP environment variables --"
    echo "LLAMA_CPP_PROJECT_PATH = $LLAMA_CPP_PROJECT_PATH"
    echo "LLAMA_CPP_BIN = $LLAMA_CPP_BIN"
    echo "LLM_MODEL_PATH = $LLM_MODEL_PATH"
}

# Complete text from input prompt
complete_text()
{
    local prompt=$1
    local model_path=${2:-$LLM_MODEL_PATH}
    local context_size=${3:-2048}
    local thread_cnt=${4:-4}

    assert_llama_cpp

    local arguments="-m '$model_path' -p '$prompt' -c $context_size -t $thread_cnt"
    local options="--color"

    eval "$LLAMA_CPP_BIN $arguments $options"
}

# Generate and complete text file
complete_file()
{
    local file=$1
    local model_path=${2:-$LLM_MODEL_PATH}
    local context_size=${3:-2048}
    local thread_cnt=${4:-4}

    assert_llama_cpp

    local arguments="-m '$model_path' -f '$file' -c $context_size -t $thread_cnt"
    local options="--color"

    eval "$LLAMA_CPP_BIN $arguments $options"
}

# Start text completion console
start_llama_console()
{
    local model_path=$1
    local context_size=${2:-2048}
    local thread_cnt=${3:-4}

    assert_llama_cpp

    local arguments="-m '$model_path' -c $context_size -t $thread_cnt"
    local options="--interactive-first --color"

    eval "$LLAMA_CPP_BIN $arguments $options"
}

# Invoke test function
test_llama_cpp()
{
    complete_text "The life of a rogue AI is weird"
}

# Test that a compiled LLAMA.CPP binary exists. Exit script if not
assert_llama_cpp()
{
    if [ ! -f "$LLAMA_CPP_BIN" ]; then
        echo "Could not find llama.exe at path - $LLAMA_CPP_BIN"
        return 1
    fi
}

#endregion