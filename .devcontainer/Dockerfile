FROM mcr.microsoft.com/devcontainers/base:bullseye
WORKDIR /workspaces/jigsawpuzzle
# Install gedit to get gui libs
RUN apt update && apt install python3 python3-pip fontconfig gedit -y &&  python3 -m pip install gdtoolkit
RUN mkdir /workspaces/Godot
WORKDIR /workspaces/Godot
RUN wget https://github.com/godotengine/godot/releases/download/4.3-stable/Godot_v4.3-stable_linux.x86_64.zip && unzip Godot_v4.3-stable_linux.x86_64.zip
