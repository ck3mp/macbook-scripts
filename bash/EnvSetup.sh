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

# Poetry
cd "$FOLDER" || exit
poetry init --name "$FOLDER" -n --dev-dependency black --dev-dependency pylama
poetry install --no-root

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
	    "python.pythonPath": ".venv/bin/python",
	    "python.terminal.activateEnvInCurrentTerminal": false,
	    "python.terminal.activateEnvironment": false,
	    "python.formatting.provider": "black",
	    "editor.codeActionsOnSave": {
	      "source.organizeImports": true
	    },
	    "[python]": {
	      "editor.formatOnPaste": false,
	      "editor.formatOnSaveMode": "file"
	    },
	    "terminal.integrated.env.osx": {
	      "ZSH_INIT_COMMAND": "poetry shell"
	    }
	  }
	}
EOM
