# set PowerShell to UTF-8
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

oh-my-posh init  pwsh --config $HOME/dotfiles/Documents/PowerShell/customized-posh-themes/myposh3.omp.json | Invoke-Expression

# fastfetch # This command loads the fastfetch module when the profile is loaded

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

# =============================================================================
#
# Utility functions for zoxide.
#

# Call zoxide binary, returning the output as UTF-8.
function global:__zoxide_bin {
    $encoding = [Console]::OutputEncoding
    try {
        [Console]::OutputEncoding = [System.Text.Utf8Encoding]::new()
        $result = zoxide @args
        return $result
    } finally {
        [Console]::OutputEncoding = $encoding
    }
}

# pwd based on zoxide's format.
function global:__zoxide_pwd {
    $cwd = Get-Location
    if ($cwd.Provider.Name -eq "FileSystem") {
        $cwd.ProviderPath
    }
}

# cd + custom logic based on the value of _ZO_ECHO.
function global:__zoxide_cd($dir, $literal) {
    $dir = if ($literal) {
        Set-Location -LiteralPath $dir -Passthru -ErrorAction Stop
    } else {
        if ($dir -eq '-' -and ($PSVersionTable.PSVersion -lt 6.1)) {
            Write-Error "cd - is not supported below PowerShell 6.1. Please upgrade your version of PowerShell."
        }
        elseif ($dir -eq '+' -and ($PSVersionTable.PSVersion -lt 6.2)) {
            Write-Error "cd + is not supported below PowerShell 6.2. Please upgrade your version of PowerShell."
        }
        else {
            Set-Location -Path $dir -Passthru -ErrorAction Stop
        }
    }
}

# =============================================================================
#
# Hook configuration for zoxide.
#

# Hook to add new entries to the database.
$global:__zoxide_oldpwd = __zoxide_pwd
function global:__zoxide_hook {
    $result = __zoxide_pwd
    if ($result -ne $global:__zoxide_oldpwd) {
        if ($null -ne $result) {
            zoxide add "--" $result
        }
        $global:__zoxide_oldpwd = $result
    }
}

# Initialize hook.
$global:__zoxide_hooked = (Get-Variable __zoxide_hooked -ErrorAction SilentlyContinue -ValueOnly)
if ($global:__zoxide_hooked -ne 1) {
    $global:__zoxide_hooked = 1
    $global:__zoxide_prompt_old = $function:prompt

    function global:prompt {
        if ($null -ne $__zoxide_prompt_old) {
            & $__zoxide_prompt_old
        }
        $null = __zoxide_hook
    }
}

# =============================================================================
#
# When using zoxide with --no-cmd, alias these internal functions as desired.
#

# Jump to a directory using only keywords.
function global:__zoxide_z {
    if ($args.Length -eq 0) {
        __zoxide_cd ~ $true
    }
    elseif ($args.Length -eq 1 -and ($args[0] -eq '-' -or $args[0] -eq '+')) {
        __zoxide_cd $args[0] $false
    }
    elseif ($args.Length -eq 1 -and (Test-Path $args[0] -PathType Container)) {
        __zoxide_cd $args[0] $true
    }
    else {
        $result = __zoxide_pwd
        if ($null -ne $result) {
            $result = __zoxide_bin query --exclude $result "--" @args
        }
        else {
            $result = __zoxide_bin query "--" @args
        }
        if ($LASTEXITCODE -eq 0) {
            __zoxide_cd $result $true
        }
    }
}

# Jump to a directory using interactive search.
function global:__zoxide_zi {
    $result = __zoxide_bin query -i "--" @args
    if ($LASTEXITCODE -eq 0) {
        __zoxide_cd $result $true
    }
}

# =============================================================================

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
Set-Alias -Name rgp -Value Invoke-PsFzfRipgrep
Set-Alias -Name ss -Value Invoke-FuzzyScoop
Set-Alias -Name z -Value __zoxide_z -Option AllScope -Scope Global -Force
Set-Alias -Name zi -Value __zoxide_zi -Option AllScope -Scope Global -Force

# Loading Scripts
Invoke-Expression (& { (zoxide init powershell | Out-String) })
. $HOME\dotfiles\Documents\PowerShell\python_scripts.ps1
