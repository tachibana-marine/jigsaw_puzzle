FROM mcr.microsoft.com/devcontainers/base:bullseye
WORKDIR /workspaces/jigsawpuzzle
RUN apt update && apt install python3 python3-pip python3-venv fontconfig -y && mkdir venv -p && python3 -m venv ./venv && python3 -m pip install gdtoolkit
RUN mkdir /workspaces/Godot
WORKDIR /workspaces/Godot
RUN wget https://github.com/godotengine/godot/releases/download/4.3-stable/Godot_v4.3-stable_linux.x86_64.zip && unzip Godot_v4.3-stable_linux.x86_64.zip
