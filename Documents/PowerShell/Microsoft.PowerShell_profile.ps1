# set PowerShell to UTF-8
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

oh-my-posh --init --shell pwsh --config $HOME/dotfiles/Documents/PowerShell/customized-posh-themes/myposh3.omp.json | Invoke-Expression

fastfetch # This command loads the fastfetch module when the profile is loaded

Import-Module Terminal-Icons

# PSReadLine
Set-PSReadLineOption -EditMode Vi
Set-PSReadLineOption -BellStyle None
Set-PSReadLineOption -PredictionSource HistoryAndPlugin
# Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadlineKeyHandler -Key "RightArrow" -Function Complete
Set-PSReadlineOption -PredictionViewStyle ListView
Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
Set-PSReadlineKeyHandler -Key "Ctrl+j" -Function NextHistory
Set-PSReadlineKeyHandler -Key "Ctrl+k" -Function PreviousHistory
Set-PSReadLineOption -Colors @{
    Command = 'Yellow'
    Parameter = 'Green'
    String = 'DarkCyan'
}

# Fzf
Import-Module PSFzf
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'

# Utilities
function whereis ($command) {
    Get-Command -Name $command -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

function Invoke-EditPwshProfile {
    nvim (Get-Item $PROFILE).Directory
}

function unzip ($file) {
    Write-Output("Extracting", $file, "to", $pwd)
    $fullFile = Get-ChildItem -Path $pwd -Filter $file | ForEach-Object { $_.FullName }
    Expand-Archive -Path $fullFile -DestinationPath $pwd
}

function reload {
    & $profile
}

function pkill {
    # $selectedProcess = Get-Process | Select-Object -ExpandProperty ProcessName | fzf --layout=reverse --ansi --border=bold --preview-window='right,60%' --preview "echo This process will be killed if pressed enter"
    # if ($selectedProcess) {
    #     Stop-Process -InputObject (Get-Process -Name $selectedProcess)
    #     Write-Output($selectedProcess + " is sucessfully killed")
    # }
    Invoke-FuzzyKillProcess
}

function admin {
    if ($args.Count -gt 0) {
        $argList = "& '$args'"
        Start-Process wt -Verb runAs -ArgumentList "pwsh.exe -NoExit -Command $argList"
    } else {
        Start-Process wt -Verb runAs
    }
}

function treeview {
    eza -lhuUT --group-directories-first --git --icons --ignore-glob="node_modules"
}

function longlisting{
    eza -lhau --group-directories-first --git --icons --ignore-glob="node_modules"
}

function listAll { 
    Get-ChildItem -Path . -Force | Format-Table -AutoSize
}

function previewFileWithSyntaxHighlighting {
    # This function uses fzf to select a file and bat to preview the contents of the selected file with syntax highlighting.
    fzf --preview-window='60%,wrap' --preview 'bat {} --style=numbers --color=always'
}

function previewtldrpages {
    tldr --list | fzf --preview "tldr {1} --color=always" --preview-window=right,70%,wrap 
}

function google {
    start "https://www.google.com/search?q=$args"
}

function host {
    start "http://localhost:$args"
}

# Clipboard Utilities
function cpy { Set-Clipboard $args[0] }

function pst { Get-Clipboard }

# WinUtil
function winutil {
	iwr -useb https://christitus.com/win | iex
}

function Get-PubIP { 
    (Invoke-WebRequest http://ifconfig.me/all).Content
    # curlie ipconfig.me/all
}

function sysinfo {
    Get-ComputerInfo
}

# Alias
Remove-Alias cp
Set-Alias cp Set-Clipboard
Set-Alias -Name ll -Value longlisting
Set-Alias -Name la -Value listAll
Set-Alias -Name llt -Value treeview
Set-Alias -Name g -Value git
Set-Alias -Name lg -Value lazygit
Set-Alias -Name touch -Value New-Item
Set-Alias -Name open -Value Invoke-Item
Set-Alias -Name su -Value admin
Set-Alias -Name editProfile -Value Invoke-EditPwshProfile
Set-Alias -Name fzfp -Value previewFileWithSyntaxHighlighting
Set-Alias -Name tldrp -Value previewtldrpages
Set-Alias -Name pn -Value pnpm
Set-Alias -Name of -Value onefetch
Set-Alias -Name ff -Value fastfetch
Set-Alias -Name kb -Value komorebic 
Set-Alias -Name ya -Value yazi
Set-Alias -Name rgp -Value Invoke-PsFzfRipgrep
Set-Alias -Name ss -Value Invoke-FuzzyScoop
