# set PowerShell to UTF-8
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

# ---- Cache dir ----
$cacheDir = "$HOME\.cache\pwsh"
if (-not (Test-Path $cacheDir)) { New-Item -ItemType Directory -Path $cacheDir -Force | Out-Null }

# ---- oh-my-posh (cached) ----
$ompConfig = "$HOME/dotfiles/Documents/PowerShell/customized-posh-themes/myposh3.omp.json"
$ompCache  = "$cacheDir\omp-init.ps1"
if (-not (Test-Path $ompCache) -or (Get-Item $ompConfig).LastWriteTime -gt (Get-Item $ompCache).LastWriteTime) {
    oh-my-posh init pwsh --config $ompConfig | Out-File -FilePath $ompCache -Encoding utf8
}
. $ompCache

# ---- zoxide (cached) ----
$zoxideCache = "$cacheDir\zoxide-init.ps1"
$zoxideExe   = (Get-Command zoxide -ErrorAction SilentlyContinue).Source
if ($zoxideExe -and (-not (Test-Path $zoxideCache) -or (Get-Item $zoxideExe).LastWriteTime -gt (Get-Item $zoxideCache).LastWriteTime)) {
    zoxide init powershell | Out-File -FilePath $zoxideCache -Encoding utf8
}
if (Test-Path $zoxideCache) { . $zoxideCache }

# PSReadLine
Set-PSReadLineOption -EditMode Vi
Set-PSReadLineOption -BellStyle None
Set-PSReadLineOption -PredictionSource HistoryAndPlugin
Set-PSReadlineOption -PredictionViewStyle ListView
Set-PSReadlineKeyHandler -Key "RightArrow" -Function Complete
Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
Set-PSReadlineKeyHandler -Key "Alt+j" -Function NextHistory
Set-PSReadlineKeyHandler -Key "Alt+k" -Function PreviousHistory
Set-PSReadLineOption -Colors @{
    "Command"   = "Yellow"
    "Parameter" = "Green"
    "Operator"  = "Red"
    "Variable"  = "Cyan"
    "String"    = "DarkCyan"
    "Number"    = "Magenta"
    "Member"    = "Gray"
    "Default"   = "White"

}

# ---- Defer heavy, non-critical modules until the prompt is idle ----
$null = Register-EngineEvent -SourceIdentifier PowerShell.OnIdle -MaxTriggerCount 1 -Action {
    Import-Module Terminal-Icons
    Import-Module PSFzf
    Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'
    Set-PSReadlineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
}

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
    # Restart the shell with the current working directory preserved
    Start-Process pwsh -WorkingDirectory (Get-Location) -NoNewWindow
    exit
}

function pkill {
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

function rmf([string]$path) {
    Remove-Item -Recurse -Force $path
}

# Clipboard Utilities
function cpy { Set-Clipboard }

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
# Set-Alias -Name fzfp -Value previewFileWithSyntaxHighlighting
Set-Alias -Name tldrp -Value previewtldrpages
Set-Alias -Name pn -Value pnpm
Set-Alias -Name y -Value yazi
Set-Alias -Name ff -Value fastfetch
Set-Alias -Name kb -Value komorebic 
Set-Alias -Name rgp -Value Invoke-PsFzfRipgrep
Set-Alias -Name ss -Value Invoke-FuzzyScoop
Set-Alias -Name ip -Value Get-PubIP

# . "$HOME\.config\fzf\fzf.ps1"


