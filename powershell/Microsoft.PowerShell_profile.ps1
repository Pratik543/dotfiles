# set PowerShell to UTF-8
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

oh-my-posh --init --shell pwsh --config $HOME/dotfiles/powershell/customized-posh-themes/myposh3.omp.json | Invoke-Expression

fastfetch # This command loads the fastfetch module when the profile is loaded

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

function unzip ($file) {
    Write-Output("Extracting", $file, "to", $pwd)
    Expand-Archive  $file 
}

function reload {
    . $profile
}

function pkill($name) {
    Get-Process $name -ErrorAction SilentlyContinue | Stop-Process
}

function pgrep($name) {
    Get-Process $name
}

function admin {
    Start-Process powershell.exe -Verb runas
}

function treeview {
    eza -lha --icons --tree --level=2
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

function ripGrepPreviewInFile {
    # This function uses fzf to select a file and ripgrep search term to preview in the selected file with syntax highlighting.
    $result = rg --smart-case --color=always --line-number --no-heading @Args |
      fzf --ansi `
       --color 'hl:-1:underline,hl+:-1:underline:reverse' `
        --delimiter ':' `
         --layout=reverse `
          --border `
           --padding=1 `
            --preview "bat --color=always {1} --highlight-line {2} --wrap=auto" `
             --preview-window 'up,60%,wrap,border-bottom,+{2}+3/3,~3' `
              --header='Live Grep Preview Enter filename or extension search the keyword in that file.'
       if ($result) {
        $parts = $result.Split(':')
        & code -g "$($parts[0]):$($parts[1])"
    }
}

function google {
    start "https://www.google.com/search?q=$args"
}

function host {
    start "http://localhost:$args"
}

# Alias
Set-Alias -Name ll -Value longlisting
Set-Alias -Name llt -Value treeview
Set-Alias -Name g -Value git
Set-Alias -Name lg -Value lazygit
Set-Alias -Name touch -Value New-Item
Set-Alias -Name open -Value Invoke-Item
Set-Alias -Name su -Value admin
Set-Alias -Name profile-edit -Value Invoke-EditPwshProfile
Set-Alias -Name fzfp -Value previewFileWithSyntaxHighlighting
Set-Alias -Name tldrp -Value previewtldrpages
Set-Alias -Name this.explorer -Value ExplorerFromHere
Set-Alias -Name pn -Value pnpm
Set-Alias -Name of -Value onefetch
Set-Alias -Name rgp -Value ripGrepPreviewInFile
Set-Alias -Name ff -Value fastfetch
