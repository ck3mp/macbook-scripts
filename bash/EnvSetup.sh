#!/bin/bash

CLEAN_REPO=${1%".git"}
FOLDER="$(echo "$CLEAN_REPO" | rev | cut -d'/' -f 1 | rev)"

if [ -z "${2}" ]; then
	PARENT_FOLDER="Default"
else
	PARENT_FOLDER="$(echo "$2" | rev | cut -d'/' -f 1 | rev)"
fi

mkdir -p /Users/chris/Development/"$PARENT_FOLDER"
cd /Users/chris/Development/"$PARENT_FOLDER" || exit
git clone "$1"

# Setup environment file for VS Code

echo "Setting up Workspace for $PARENT_FOLDER/$FOLDER"

WORKSPACE_FOLDER="/Users/chris/Development/Workspaces/$PARENT_FOLDER"
WORKSPACE_FILE="$WORKSPACE_FOLDER/$FOLDER.code-workspace"
mkdir -p "$WORKSPACE_FOLDER"

cat >"$WORKSPACE_FILE" <<-EOM
	{
	  "folders": [
	    {
	      "path": "/Users/chris/Development/$PARENT_FOLDER/$FOLDER"
	    }
	  ],
	  "settings": {
	    "python.defaultInterpreterPath": "/opt/homebrew/anaconda3/envs/$PARENT_FOLDER/bin/python",
	    "python.terminal.activateEnvInCurrentTerminal": false,
	    "python.terminal.activateEnvironment": true,
	    "python.formatting.provider": "black",
	    "editor.codeActionsOnSave": {
	      "source.organizeImports": true
	    },
	    "[python]": {
	      "editor.formatOnPaste": false,
	      "editor.formatOnSaveMode": "file"
	    }
	  }
	}
EOM
