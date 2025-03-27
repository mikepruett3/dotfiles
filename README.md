# Installation and Usage

## Install for Linux/MacOS

- Use the one-liner below, to install and run `chezmoi`

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply mikepruett3
```

## Install for Windows

- Copy and run the following bootstrap script first!

```powershell
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/mikepruett3/dotfiles/refs/heads/main/dot_bootstrap/windows/ps1/Windows-Bootstrap.ps1'))"
```

- Then install and run `chezmoi`

```powershell
chezmoi init --apply https://github.com/mikepruett3/dotfiles.git
```
