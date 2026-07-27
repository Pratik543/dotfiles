#!/usr/bin/env pwsh
# Script to find every single file and opens in neovim
# alias set as nzo in your PowerShell profile:
#   Set-Alias nzo "$HOME\path\to\nzo.ps1"
# Or as a function in $PROFILE:
#   function nzo { & "path\to\nzo.ps1" @args }

function Search-WithZoxide {
    param([string]$Pattern = "")

    # Helper: open file in neovim from its directory
    function Open-InNeovim {
        param([string]$FilePath)
        $dir      = Split-Path $FilePath -Parent
        $fileName = Split-Path $FilePath -Leaf
        Push-Location $dir
        try   { nvim $fileName }
        finally { Pop-Location }
    }

    $fdBaseArgs = @(
        '--type', 'f',
        '-I', '-H',
        '-E', '.git',
        '-E', '.git-crypt',
        '-E', '.cache',
        '-E', '.backup'
    )

    if ([string]::IsNullOrEmpty($Pattern)) {
        # ── No argument: search files in current dir with fd + fzf preview ──
        $file = fd @fdBaseArgs |
            fzf --height=70% --preview='bat -n --color=always --line-range :500 {}'

        if ($file) { Open-InNeovim $file }

    } else {
        # ── With argument: search zoxide-tracked dirs for matching files ──
        $zDirs = zoxide query -l

        if (-not $zDirs) {
            Write-Error "No directories tracked by zoxide."
            return
        }

        $extraExcludes = @('-E', '.vscode')
        $matches = foreach ($zDir in $zDirs) {
            if (Test-Path $zDir) {
                fd @fdBaseArgs @extraExcludes $Pattern $zDir 2>$null
            }
        }

        # Flatten and deduplicate
        $matches = $matches | Where-Object { $_ } | Select-Object -Unique

        if (-not $matches) {
            Write-Error "No matches found."
            return
        }

        $file = if (@($matches).Count -eq 1) {
            $matches
        } else {
            $matches |
                fzf --query=$Pattern --height=70% `
                    --preview='bat -n --color=always --line-range :500 {}' `
                    --no-sort
        }

        if ($file) { Open-InNeovim $file }
    }
}

Search-WithZoxide @args
