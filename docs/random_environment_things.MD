Got some vim bindings in commmand mode for notebook
from CHatGPT https://chat.openai.com/share/3b3e6f55-1c2f-457c-b9a5-ddf12c5a3d22
which i configured in the `Keyboard shortcuts JSON` in vscode:
```
[
    {
        "key": "o",
        "command": "notebook.cell.insertCodeCellBelow",
        "when": "notebookEditorFocused && vim.active && !inDebugRepl"
    },
    {
        "key": "O",
        "command": "notebook.cell.insertCodeCellAbove",
        "when": "notebookEditorFocused && vim.active && !inDebugRepl"
    }
]
```