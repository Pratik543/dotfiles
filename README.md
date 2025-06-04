# dotfiles
Configuration files of my development environment on windows

## Installation
- Clone this dotfiles in users folder

```powershell
git clone https://github.com/Pratik543/dotfiles.git
```

- Run setup in **Admin mode** (Press <kbd>Win</kbd> + <kbd>x</kbd> and select `Terminal (Admin)`)

```powershell
cd dotfiles
.\setup.ps1
```
This will install all necessary packages, modules and setup symlinks for you.

If setup runs into errors, try running the command in admin mode again or run the command from setup.ps1 manually.

#### Git

It is recommended to setup git and GitHub before anything else.

```powershell
git config --global user.name "Your Name"
git config --global user.email "your@email.com"

git config --global commit.gpgSign false #Disable GPG signing

gh auth login #Login to github
```

If you want to use GPG signing [check this](https://docs.github.com/en/authentication/managing-commit-signature-verification/adding-a-new-gpg-key-to-your-github-account)
