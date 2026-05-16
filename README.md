# Resumes

LaTeX-based resume workspace with live preview in VS Code. One `.tex` source per role, one shared output folder.

## Folder structure

```
Resumes/
├── resumes/                  All .tex source files (one per role)
│   └── main.tex              Full Stack Developer resume
├── build/                   Compiled PDFs (auto-generated, gitignored)
├── .vscode/
│   ├── settings.json         LaTeX Workshop config (auto-build on save, output → build/)
│   ├── tasks.json            Build / preview / new-resume tasks
│   └── extensions.json       Recommends LaTeX Workshop on project open
├── scripts/
│   ├── setup-mac.sh          One-shot installer for macOS
│   ├── setup-windows.ps1     One-shot installer for Windows
│   ├── install-tex-packages.sh  Installs LaTeX packages via tlmgr (BasicTeX users)
│   ├── build.sh / build.ps1  Build one or all resumes
│   └── new-resume.sh / .ps1  Scaffold a new resume from main.tex
├── .gitignore
└── README.md
```

**Naming rule:** `resumes/<name>.tex` → `build/<name>.pdf`.

The `build/` folder is visible in the file explorer and Finder. It's gitignored, so PDFs never end up in commits.

## First-time setup

### macOS

```bash
bash scripts/setup-mac.sh
```

Installs Homebrew (if missing), MacTeX-no-gui, VS Code, and the LaTeX Workshop extension.

If you already had **BasicTeX**, also run once to fetch the packages this resume uses:

```bash
bash scripts/install-tex-packages.sh
```

### Windows

```powershell
powershell -ExecutionPolicy Bypass -File scripts\setup-windows.ps1
```

Installs MiKTeX (with auto-install of missing packages), VS Code, and LaTeX Workshop. No separate package step needed — MiKTeX fetches packages on first compile.

## Live preview (everyday workflow)

1. Open the project in VS Code: `code .`
2. Open any `.tex` file inside `resumes/`.
3. Trigger the preview once: `Cmd+Option+V` (Mac) / `Ctrl+Alt+V` (Windows) — opens the PDF in a side tab.
4. Edit and save (auto-saves every 500 ms). The PDF tab refreshes automatically.

Build artifacts go to `build/` (visible at the workspace root). Gitignored so they're not committed.

## Keyboard shortcuts

Built into LaTeX Workshop:

| Action                     | macOS             | Windows       |
| -------------------------- | ----------------- | ------------- |
| Build current `.tex`       | `Cmd+Option+B`    | `Ctrl+Alt+B`  |
| Toggle PDF preview tab     | `Cmd+Option+V`    | `Ctrl+Alt+V`  |
| Source ⇄ PDF jump (SyncTeX)| `Cmd+Click`       | `Ctrl+Click`  |

> The Mac key labeled **Option** (⌥) is what VS Code internally calls `alt` — so in the JSON below the string stays `cmd+alt+...`. Same key, different name.

Optional shortcuts that map to `tasks.json` (paste into your **global** `keybindings.json` via `Cmd+Shift+P` → "Preferences: Open Keyboard Shortcuts (JSON)"):

```json
[
  { "key": "cmd+alt+m", "command": "workbench.action.tasks.runTask", "args": "Build current resume (mac)",   "when": "isMac" },
  { "key": "cmd+alt+p", "command": "workbench.action.tasks.runTask", "args": "Preview current PDF (mac)",   "when": "isMac" },
  { "key": "ctrl+alt+m","command": "workbench.action.tasks.runTask", "args": "Build current resume (windows)","when": "isWindows" },
  { "key": "ctrl+alt+p","command": "workbench.action.tasks.runTask", "args": "Preview current PDF (windows)", "when": "isWindows" }
]
```

## Manual build (without VS Code)

```bash
# macOS — one file
bash scripts/build.sh backend-engineer

# macOS — all resumes
bash scripts/build.sh

# Windows — one file
powershell -File scripts\build.ps1 backend-engineer

# Windows — all resumes
powershell -File scripts\build.ps1
```

PDFs land in `build/`.

## Add a new resume

```bash
# macOS
bash scripts/new-resume.sh backend-engineer

# Windows
powershell -File scripts\new-resume.ps1 backend-engineer
```

Copies `resumes/main.tex` → `resumes/backend-engineer.tex`. Open it, edit the role/title at the top, save — the PDF builds automatically.

Or in VS Code: `Cmd+Shift+P` → **Tasks: Run Task** → **New resume from template** → enter name.

## Run a task from VS Code

`Cmd+Shift+P` → **Tasks: Run Task**, then pick:

- *Build current resume* — compiles the focused `.tex`
- *Build ALL resumes* — compiles every file in `resumes/`
- *Preview current PDF* — opens the matching PDF in the system viewer
- *Build & Preview current* — both in sequence
- *New resume from template* — scaffold a new file

Each task has a `(mac)` and `(windows)` variant; pick the one for your OS.

## Troubleshooting

**`File 'titlesec.sty' not found`** — You have BasicTeX. Run `bash scripts/install-tex-packages.sh` once.

**`chktex could not be found`** — Linter warning only, not a build error. Already disabled in `.vscode/settings.json`.

**PDF preview tab doesn't appear** — Open it manually with `Cmd+Option+V` / `Ctrl+Alt+V`. The first time per session it has to be opened explicitly.

**Folder name has a trailing space** — The project folder is currently `Resumes ` (with trailing space). Rename to `Resumes` when convenient — some tools choke on it:

```bash
mv "Resumes " "Resumes"
```
