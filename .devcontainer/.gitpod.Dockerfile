FROM gitpod/workspace-node:latest

RUN npm install -g @devcontainers/cli

RUN sudo apt-get update -y && sudo apt-get install -y socat