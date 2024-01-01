# set PowerShell to UTF-8
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

oh-my-posh --init --shell pwsh --config $env:POSH_THEMES_PATH/myposh3.omp.json | Invoke-Expression

Import-Module Terminal-Icons

# PSReadLine
Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineOption -BellStyle None
Set-PSReadLineOption -PredictionSource History
# Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadlineKeyHandler -Key "RightArrow" -Function Complete
Set-PSReadlineOption -PredictionViewStyle ListView

# Fzf
Import-Module PSFzf
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'

# Utilities
Function whereis ($command) {
  Get-Command -Name $command -ErrorAction SilentlyContinue |
    Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

Function Invoke-EditPwshProfile {
    code (Get-Item $PROFILE).Directory    
}

Function previewFileWithSyntaxHighlighting {
  # This function uses fzf to select a file and bat to preview the contents of the selected file with syntax highlighting.
  fzf --preview-window=60% --preview 'bat --style=numbers,grid --wrap=auto --color=always {}'
}

Function recentBranch {
# This function uses fzf to select a branch,shows the diff between the current branch and checkout the selected branch.
  git branch --sort=committerdate | fzf --header "Checkout Recent Branch" --preview "git diff {1} | delta" | ForEach-Object {
    $branchName = $_.Trim()  # Remove any leading or trailing spaces
    if ($branchName) {
        git checkout $branchName
    }
  }
}

Function checkGitHubPRs {
   # List GitHub PRs using the gh CLI, pipe the output to fzf for interactive selection, 
   # preview the selected PR using the gh CLI, extract the PR number, 
   # and checkout the selected PR using the gh CLI.
   $env:GH_FORCE_TTY = "100%"
   gh pr list | fzf --ansi --preview "gh pr view {1}" --preview-window down --header-lines 3 | ForEach-Object {($_ -split '\s+')[0]} | ForEach-Object {gh pr checkout $_}
}


# Alias
Set-Alias -Name cat -Value bat
Set-Alias -Name ll -Value eza
Set-Alias -Name g -Value git
Set-Alias -Name touch -Value New-Item
Set-Alias -Name open -Value Invoke-Item
Set-Alias -Name profile-edit -Value Invoke-EditPwshProfile
Set-Alias -Name fzfp -Value previewFileWithSyntaxHighlighting
Set-Alias -Name corb -Value recentBranch
Set-Alias -Name checkpr -Value checkGitHubPRs




