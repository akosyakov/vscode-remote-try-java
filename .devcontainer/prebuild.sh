#!/bin/sh
set -e

devcontainer up --remove-existing-container --workspace-folder "$(pwd)" --prebuild