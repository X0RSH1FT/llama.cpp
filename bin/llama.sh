#!/bin/bash

#region Documentation
: '
    SYNOPSIS
        LLAMA.CPP Bash project script

    DESCRIPTION
        Utility bash script to manage the LLAMA.CPP project
'
#endregion

#region Configuration
set -e # Exit script on any error
# Default build directory path relative to this script's location
LLAMA_BUILD_DIR_PATH="$(dirname "$(realpath "$0")")/../build"
#endregion

#region Operations

# Build LLAMA.CPP binary
build_llama_cpp()
{
    local build_path="$1"
    # Store the current working directory to restore after process
    local origin_dir
    origin_dir=$(pwd)
    # Set the build path to the default if not specified
    build_path=${build_path:-$LLAMA_BUILD_DIR_PATH}
    # Test if the build directory exists and create it if needed
    if [ ! -d "$build_path" ]; then
        echo "Creating build directory - $build_path"
        mkdir -p "$build_path"
    fi
    build_path="$(realpath "$build_path")"
    echo "Building LLAMA.CPP at path - $build_path"
    # Set the location to the build directory
    cd "$build_path"
    # Run the build commands
    cmake ..
    cmake --build . --config Release
    # Validate the compiled binary exists
    assert_llama_cpp
    echo "LLAMA.CPP compiled successfully"
    # Reset the working directory
    cd "$origin_dir"
}

# Test that a compiled LLAMA.CPP binary exists. Exit script if not
assert_llama_cpp()
{
    if [ ! -f "$LLAMA_CPP_BIN" ]; then
        echo "Could not find llama-cpp at path - $LLAMA_CPP_BIN"
        exit 1
    fi
}

#endregion

#region Execution

# Main script execution
for arg in "$@"; do
    case $arg in
        --clear)
            clear # Clear the console
            ;;
        --debug)
            set -x # Enable debug logger
            ;;
        --verbose)
            set -v # Enable verbose logger
            ;;
        --build)
            build=true # Compile the executable
            ;;
        *)
            echo "Unknown argument: $arg"
            exit 1
            ;;
    esac
done

# Execute build if requested
if [ "${build:-}" = true ]; then
    build_llama_cpp "$LLAMA_BUILD_DIR_PATH"
fi

#endregion