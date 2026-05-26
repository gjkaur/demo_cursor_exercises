# Local workflow (private remote)

Use this project with a **private** remote and without putting remote URLs in tracked files or chat.

## One-time: make the remote repository private

1. Open your repository on the hosting site (Settings).
2. Go to **General** → **Danger Zone** (or **Visibility**).
3. Change visibility from **Public** to **Private**.
4. Confirm only you (and collaborators you add) can access the repo.

If the repo was ever public, past visibility cannot be fully undone; private mode limits access from now on.

## One-time: Cursor privacy

1. Open **Cursor Settings → Privacy**.
2. Enable **Privacy Mode** (or your plan’s equivalent) so your code is not used for training on public models.
3. Avoid pasting clone URLs or remote details into Agent chat.

## Optional: remote URL in a gitignored file

If you prefer the remote URL only in a local file (not only in `.git/config`):

1. Copy `local.git.env.example` to `local.git.env` (already gitignored).
2. Set `REMOTE_URL=` to your private remote URL (HTTPS or SSH).
3. `push-work.ps1` applies it before each push.

## Daily: commit and push

From the project root in PowerShell:

```powershell
.\scripts\push-work.ps1 -Message "Describe your change"
```

Stage specific paths only:

```powershell
.\scripts\push-work.ps1 -Message "Update calculator" calculator.c
```

The script does not contain a remote URL; it uses `git` configuration and optional `local.git.env`.

## Prerequisites

- Remote repository is **Private**.
- You are authenticated for `git push` (credential manager or SSH).
- Run the script from the repository root (or it resolves root via `scripts/`).

## Verification

- No remote host URLs in tracked `README.md`, `calculator.c`, or `scripts/*.ps1`.
- `git status` is clean after a successful run.
- `git log -1` shows your commit message.
