#!/bin/bash

if [ -z "$(ls -A /app)" ]; then
    cp -a /backup/. /app
    rm -rf /backup
    mv -f /launchSettings.json /app/api/Properties/
fi

# Create a new detached tmux session named 'my_session'
tmux new-session -d -s dev 

# Split the window into 3 panes
tmux split-window -h
tmux split-window -t dev:0.0 -v

# Run a command on each pane
tmux send-keys -t dev:0.0 'cd /app/api && dotnet watch run' C-m 
tmux send-keys -t dev:0.1 'cd /app/frontend && ng completion && ng serve --host 0.0.0.0 --port 3000 --disable-host-check' C-m

# Attach to the created session
tmux attach-session -t dev
