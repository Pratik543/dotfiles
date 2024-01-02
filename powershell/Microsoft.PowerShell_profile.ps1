# set PowerShell to UTF-8
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

oh-my-posh --init --shell pwsh --config $env:POSH_THEMES_PATH/myposh2.omp.json | Invoke-Expression

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
function whereis ($command) {
  Get-Command -Name $command -ErrorAction SilentlyContinue |
    Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

function Invoke-EditPwshProfile {
    code (Get-Item $PROFILE).Directory
}

function uptime {
    #Windows Powershell only
	If ($PSVersionTable.PSVersion.Major -eq 5 ) {
		Get-WmiObject win32_operatingsystem |
        Select-Object @{EXPRESSION={ $_.ConverttoDateTime($_.lastbootuptime)}} | Format-Table -HideTableHeaders
	} Else {
        net statistics workstation | Select-String "since" | foreach-object {$_.ToString().Replace('Statistics since ', '')}
    }
}

function unzip ($file) {
    Write-Output("Extracting", $file, "to", $pwd)
    Expand-Archive  $file 
}

function reload {
    & $profile
}

function pkill($name) {
    Get-Process $name -ErrorAction SilentlyContinue | Stop-Process
}

function pgrep($name) {
    Get-Process $name
}

function df {
    get-volume
}

function admin {
    Start-Process powershell.exe -Verb runas
}

function treeview {
    eza -lha --tree
}

function longlisting{
    eza -lha --git --icons
}

function checkGitHubPRs {
   # List GitHub PRs using the gh CLI, pipe the output to fzf for interactive selection, 
   # preview the selected PR using the gh CLI, extract the PR number, 
   # and checkout the selected PR using the gh CLI.
   $env:GH_FORCE_TTY = "100%"
   gh pr list | fzf --ansi --layout=reverse --preview "gh pr view {1}" --preview-window down --header-lines 3 | ForEach-Object {($_ -split '\s+')[0]} | ForEach-Object {gh pr checkout $_}
}

function checkGitHubIssues {
    # List GitHub issues using the gh CLI, pipe the output to fzf for interactive selection, 
    # preview the selected issue using the gh CLI, extract the issue number, 
    # and checkout the selected issue using the gh CLI.
    $env:GH_FORCE_TTY = "100%"
    gh issue list | fzf --ansi --layout=reverse --preview "gh issue view {1}" --preview-window down --header-lines 3 | ForEach-Object {($_ -split '\s+')[0]} | ForEach-Object {gh issue checkout $_}
}

function checkGitHubGists {
    # List GitHub gists using the gh CLI, pipe the output to fzf for interactive selection, 
    # preview the selected gist using the gh CLI, extract the gist id, 
    # and open the selected gist using the gh CLI.
    $env:GH_FORCE_TTY = "100%"
    gh gist list | fzf --ansi --layout=reverse --preview "gh gist view {1}" --preview-window down --header-lines 3 | ForEach-Object {($_ -split '\s+')[0]} | ForEach-Object {gh gist view $_}
}

function previewFileWithSyntaxHighlighting {
  # This function uses fzf to select a file and bat to preview the contents of the selected file with syntax highlighting.
  fzf --preview-window=60% --preview 'bat --style=numbers,grid --wrap=auto --color=always {}'
}

function modifiedBranchAheadOfMain {
# This function uses fzf to select a branch,shows the diff between the current branch and checkout the selected branch.
  git branch --sort=committerdate | fzf  --preview "git diff {1} | delta" --cycle --header "To switch to the selected branch which is modified and ahead of the main" | ForEach-Object {
    $branchName = $_.Trim()  # Remove any leading or trailing spaces
    if ($branchName) {
        git checkout $branchName
    }
  } 
}

function findDiffWithPreviousCommit() {
 # it will display the differences between the current state of the repository and the previous commit.
  git diff --name-only | fzf -m --ansi --preview 'git diff --color=always -- {-1} | delta' --cycle --header "Check diff between the current state and the previous commit"
}

function showOfCommits {

    git log --graph --date-order --date=short --pretty=format:'%C(cyan)%h %C(blue)%ar%C(auto)%d %C(yellow)%s%+b %C(black)%ae' | fzf --header "Select commit to show" --preview 'git show --color=always -- {1} | delta'
}

function previewtldrpages {
    tldr --list | fzf --preview "tldr {1} --color=always" --preview-window=right,70% 
}

# Alias
Set-Alias -Name ll -Value longlisting
Set-Alias -Name tree -Value treeview
Set-Alias -Name g -Value git
Set-Alias -Name touch -Value New-Item
Set-Alias -Name open -Value Invoke-Item
Set-Alias -Name su -Value admin
Set-Alias -Name profile-edit -Value Invoke-EditPwshProfile
Set-Alias -Name fzfp -Value previewFileWithSyntaxHighlighting
Set-Alias -Name tldrp -Value previewtldrpages
Set-Alias -Name corb -Value modifiedBranchAheadOfMain
Set-Alias -Name dipc -Value findDiffWithPreviousCommit
Set-Alias -Name soct -Value showOfCommits
Set-Alias -Name checkpr -Value checkGitHubPRs
Set-Alias -Name checkgist -Value checkGitHubGists
Set-Alias -Name checkissue -Value checkGitHubIssues