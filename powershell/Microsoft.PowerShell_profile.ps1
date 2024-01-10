# set PowerShell to UTF-8
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

oh-my-posh --init --shell pwsh --config $HOME/dotfiles/powershell/customized-posh-themes/myposh3.omp.json | Invoke-Expression

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
    Get-Command -Name $command -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

function Invoke-EditPwshProfile {
    code (Get-Item $PROFILE).Directory
}

function uptime {
    #Windows Powershell only
	if ($PSVersionTable.PSVersion.Major -eq 5 ) {
	    Get-WmiObject win32_operatingsystem | Select-Object @{EXPRESSION={ $_.ConverttoDateTime($_.lastbootuptime)}} | Format-Table -HideTableHeaders
	} else {
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

function previewFileWithSyntaxHighlighting {
    # This function uses fzf to select a file and bat to preview the contents of the selected file with syntax highlighting.
    fzf --preview-window='60%,wrap' --preview 'bat {} --style=numbers --color=always'
}

function previewtldrpages {
    tldr --list | fzf --preview "tldr {1} --color=always" --preview-window=right,70%,wrap 
}

function ExplorerFromHere { 
    explorer (Get-Location).Path 
}

# Alias
Set-Alias -Name ll -Value longlisting
Set-Alias -Name tree -Value treeview
Set-Alias -Name g -Value git
Set-Alias -Name lg -Value lazygit
Set-Alias -Name touch -Value New-Item
Set-Alias -Name open -Value Invoke-Item
Set-Alias -Name su -Value admin
Set-Alias -Name profile-edit -Value Invoke-EditPwshProfile
Set-Alias -Name fzfp -Value previewFileWithSyntaxHighlighting
Set-Alias -Name tldrp -Value previewtldrpages
Set-Alias -Name this.explorer -Value ExplorerFromHere